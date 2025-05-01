#!/usr/bin/env bash

# This script creates the SQL files for the MySQL Advanced tasks.

echo "Creating 0-uniq_users.sql..."
cat << 'EOF' > 0-uniq_users.sql
-- 0-uniq_users.sql
-- Creates the table 'users' with id, email (unique), and name columns.
-- The script does not fail if the table already exists.

CREATE TABLE IF NOT EXISTS users (
    id INT NOT NULL AUTO_INCREMENT,
    email VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(255),
    PRIMARY KEY (id)
);
EOF

echo "Creating 1-country_users.sql..."
cat << 'EOF' > 1-country_users.sql
-- 1-country_users.sql
-- Creates the table 'users' with id, email (unique), name,
-- and country (ENUM 'US', 'CO', 'TN', default 'US') columns.
-- The script does not fail if the table already exists.

CREATE TABLE IF NOT EXISTS users (
    id INT NOT NULL AUTO_INCREMENT,
    email VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(255),
    country ENUM('US', 'CO', 'TN') NOT NULL DEFAULT 'US',
    PRIMARY KEY (id)
);
EOF

echo "Creating 2-fans.sql..."
cat << 'EOF' > 2-fans.sql
-- 2-fans.sql
-- Ranks country origins of bands by the number of non-unique fans.
-- Columns: origin, nb_fans. Ordered by nb_fans descending.

SELECT origin, SUM(fans) AS nb_fans
FROM metal_bands
GROUP BY origin
ORDER BY nb_fans DESC;
EOF

echo "Creating 3-glam_rock.sql..."
cat << 'EOF' > 3-glam_rock.sql
-- 3-glam_rock.sql
-- Lists all bands with 'Glam rock' as their main style, ranked by longevity.
-- Calculates lifespan using 'formed' and 'split' years (using 2022 if split is NULL).
-- Columns: band_name, lifespan. Ordered by lifespan descending.

SELECT
    band_name,
    (IFNULL(split, 2022) - formed) AS lifespan
FROM
    metal_bands
WHERE
    style LIKE '%Glam rock%'
ORDER BY
    lifespan DESC;
EOF

echo "Creating 4-store.sql..."
cat << 'EOF' > 4-store.sql
-- 4-store.sql
-- Creates a trigger that decreases the quantity of an item
-- in the 'items' table after adding a new order to the 'orders' table.

DELIMITER //

CREATE TRIGGER decrease_item_quantity
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    -- Update the quantity in the items table for the ordered item
    UPDATE items
    SET quantity = quantity - NEW.number
    WHERE name = NEW.item_name;
END;

//

DELIMITER ;
EOF

echo "Creating 5-valid_email.sql..."
cat << 'EOF' > 5-valid_email.sql
-- 5-valid_email.sql
-- Creates a trigger that resets the 'valid_email' attribute to 0
-- only when the 'email' attribute has been changed.

DELIMITER //

CREATE TRIGGER reset_valid_email
BEFORE UPDATE ON users
FOR EACH ROW
BEGIN
    -- Check if the email column is being updated to a new value
    IF OLD.email <> NEW.email THEN
        -- Reset valid_email to 0 (false)
        SET NEW.valid_email = 0;
    END IF;
END;

//

DELIMITER ;
EOF

echo "Creating 6-bonus.sql..."
cat << 'EOF' > 6-bonus.sql
-- 6-bonus.sql
-- Creates a stored procedure AddBonus that adds a new correction for a student.
-- Takes user_id, project_name, score as input.
-- Creates the project if it doesn't exist.

DELIMITER //

CREATE PROCEDURE AddBonus(
    IN user_id INT,
    IN project_name VARCHAR(255),
    IN score INT
)
BEGIN
    DECLARE project_id INT;

    -- Check if the project exists, get its id
    SELECT id INTO project_id
    FROM projects
    WHERE name = project_name;

    -- If project does not exist, create it
    IF project_id IS NULL THEN
        INSERT INTO projects (name) VALUES (project_name);
        SET project_id = LAST_INSERT_ID();
    END IF;

    -- Insert the new correction
    INSERT INTO corrections (user_id, project_id, score)
    VALUES (user_id, project_id, score);
END;

//

DELIMITER ;
EOF

echo "Creating 7-average_score.sql..."
cat << 'EOF' > 7-average_score.sql
-- 7-average_score.sql
-- Creates a stored procedure ComputeAverageScoreForUser that
-- computes and stores the average score for a student.
-- Takes user_id as input.

DELIMITER //

CREATE PROCEDURE ComputeAverageScoreForUser(
    IN user_id INT
)
BEGIN
    DECLARE avg_score FLOAT;

    -- Calculate the average score for the user
    SELECT AVG(score) INTO avg_score
    FROM corrections
    WHERE corrections.user_id = user_id;

    -- Update the user's average_score in the users table
    UPDATE users
    SET average_score = IFNULL(avg_score, 0)
    WHERE id = user_id;
END;

//

DELIMITER ;
EOF

echo "Creating 8-index_my_names.sql..."
cat << 'EOF' > 8-index_my_names.sql
-- 8-index_my_names.sql
-- Creates an index idx_name_first on the table 'names'
-- indexing only the first letter of the 'name' column.

CREATE INDEX idx_name_first
ON names (name(1));
EOF

echo "Creating 9-index_name_score.sql..."
cat << 'EOF' > 9-index_name_score.sql
-- 9-index_name_score.sql
-- Creates a composite index idx_name_first_score on the table 'names'
-- indexing the first letter of the 'name' column and the 'score' column.

CREATE INDEX idx_name_first_score
ON names (name(1), score);
EOF

echo "Creating 10-div.sql..."
cat << 'EOF' > 10-div.sql
-- 10-div.sql
-- Creates a function SafeDiv that divides the first number by the second
-- or returns 0 if the second number is 0.
-- Takes a INT, b INT as input. Returns FLOAT or INT.

DELIMITER //

CREATE FUNCTION SafeDiv (a INT, b INT)
RETURNS FLOAT
DETERMINISTIC -- Indicates the function returns the same result for the same inputs
BEGIN
    IF b = 0 THEN
        RETURN 0;
    ELSE
        RETURN a / b;
    END IF;
END;

//

DELIMITER ;
EOF

echo "Creating 11-need_meeting.sql..."
cat << 'EOF' > 11-need_meeting.sql
-- 11-need_meeting.sql
-- Creates a view need_meeting that lists all students with a score < 80
-- AND (no last_meeting date OR the last_meeting was more than 1 month ago).

CREATE VIEW need_meeting AS
SELECT name
FROM students
WHERE score < 80 AND (last_meeting IS NULL OR last_meeting < DATE_SUB(CURDATE(), INTERVAL 1 MONTH));
EOF

echo "Creating 100-average_weighted_score.sql..."
cat << 'EOF' > 100-average_weighted_score.sql
-- 100-average_weighted_score.sql
-- Creates a stored procedure ComputeAverageWeightedScoreForUser
-- that computes and stores the average weighted score for a student.
-- Takes user_id as input.

DELIMITER //

CREATE PROCEDURE ComputeAverageWeightedScoreForUser(
    IN user_id INT
)
BEGIN
    DECLARE total_weighted_score FLOAT;
    DECLARE total_weight INT;

    -- Calculate the sum of (score * weight) for the user
    SELECT SUM(c.score * p.weight) INTO total_weighted_score
    FROM corrections c
    JOIN projects p ON c.project_id = p.id
    WHERE c.user_id = user_id;

    -- Calculate the sum of weights for the user's projects
    SELECT SUM(p.weight) INTO total_weight
    FROM corrections c
    JOIN projects p ON c.project_id = p.id
    WHERE c.user_id = user_id;

    -- Update the user's average_score
    IF total_weight > 0 THEN
        UPDATE users
        SET average_score = total_weighted_score / total_weight
        WHERE id = user_id;
    ELSE
        -- Handle case where user has no corrections or projects with weight > 0
        UPDATE users
        SET average_score = 0
        WHERE id = user_id;
    END IF;
END;

//

DELIMITER ;
EOF

echo "Creating 101-average_weighted_score.sql..."
cat << 'EOF' > 101-average_weighted_score.sql
-- 101-average_weighted_score.sql
-- Creates a stored procedure ComputeAverageWeightedScoreForUsers
-- that computes and stores the average weighted score for all students.
-- Takes no input.

DELIMITER //

CREATE PROCEDURE ComputeAverageWeightedScoreForUsers()
BEGIN
    -- Update average_score for all users based on their weighted scores
    UPDATE users u
    JOIN (
        SELECT
            c.user_id,
            SUM(c.score * p.weight) / SUM(p.weight) AS weighted_avg
        FROM corrections c
        JOIN projects p ON c.project_id = p.id
        GROUP BY c.user_id
    ) AS user_weighted_scores ON u.id = user_weighted_scores.user_id
    SET u.average_score = user_weighted_scores.weighted_avg;

    -- Set average_score to 0 for users with no corrections (they won't be in the subquery result)
    UPDATE users
    SET average_score = 0
    WHERE id NOT IN (SELECT DISTINCT user_id FROM corrections);
END;

//

DELIMITER ;
EOF

echo "All SQL files created successfully."

# End of script