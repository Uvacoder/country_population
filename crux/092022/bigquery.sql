
CREATE TEMP TABLE report (origin string, country_code string);

INSERT INTO report (origin, country_code)
SELECT
    DISTINCT origin,
    country_code
  FROM
    `chrome-ux-report.materialized.country_summary`
  WHERE
    yyyymm = 202209
    AND rank = 1000
  GROUP BY
    country_code,
    origin
  ORDER BY
    country_code,
    origin;


DELETE FROM report WHERE country_code IN (
SELECT country_code FROM (
SELECT
  country_code,
  COUNT(origin) AS count_origins
FROM
  report
GROUP BY country_code) where count_origins < 1000);

-- Export the dataset to csv
SELECT origin, UPPER(country_code) AS country_code FROM report;
