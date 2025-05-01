-- 9-index_name_score.sql
-- Creates a composite index idx_name_first_score on the table 'names'
-- indexing the first letter of the 'name' column and the 'score' column.

CREATE INDEX idx_name_first_score
ON names (name(1), score);
