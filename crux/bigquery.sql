CREATE OR REPLACE TABLE
  `httparchive-sandbox.crux.country_summary_082022` AS (
  SELECT
    DISTINCT origin,
    country_code
  FROM
    `chrome-ux-report.materialized.country_summary`
  WHERE
    yyyymm = 202208
    AND rank = 1000
  GROUP BY
    country_code,
    origin
  ORDER BY
    country_code,
    origin );

-- Prune countries that don't have 1000
-- 237 -> 209
DELETE FROM `httparchive-sandbox.crux.country_summary_082022` WHERE country_code IN (
SELECT country_code FROM (
SELECT
  country_code,
  COUNT(origin) AS count_origins
FROM
  `httparchive-sandbox.crux.country_summary_082022`
GROUP BY country_code) where count_origins < 1000);

-- Export the dataset to csv
SELECT origin, UPPER(country_code) AS country_code FROM `httparchive-sandbox.crux.country_summary_082022`;
