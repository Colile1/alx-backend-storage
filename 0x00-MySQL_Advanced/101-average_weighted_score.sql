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
