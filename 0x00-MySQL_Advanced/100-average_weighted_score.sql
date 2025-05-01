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
