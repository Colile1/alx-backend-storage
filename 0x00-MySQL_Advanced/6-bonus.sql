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
