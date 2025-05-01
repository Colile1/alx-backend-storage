-- 11-need_meeting.sql
-- Creates a view need_meeting that lists all students with a score < 80
-- AND (no last_meeting date OR the last_meeting was more than 1 month ago).

CREATE VIEW need_meeting AS
SELECT name
FROM students
WHERE score < 80 AND (last_meeting IS NULL OR last_meeting < DATE_SUB(CURDATE(), INTERVAL 1 MONTH));
