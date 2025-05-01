-- 2-fans.sql
-- Ranks country origins of bands by the number of non-unique fans.
-- Columns: origin, nb_fans. Ordered by nb_fans descending.

SELECT origin, SUM(fans) AS nb_fans
FROM metal_bands
GROUP BY origin
ORDER BY nb_fans DESC;
