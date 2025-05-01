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
