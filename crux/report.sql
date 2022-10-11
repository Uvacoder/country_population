
.mode csv
.headers on

.output country_origin.csv
SELECT * from country_origin;

.output countries.csv
SELECT * from country;

.output stats.csv
SELECT country_code_base as country_code, country.name, CAST(ROUND(AVG(intersections)) as INT) average, MIN(intersections) minimum, MAX(intersections) maximum, SUM(intersections) total FROM country_intersection, country WHERE country.ISO2 = country_intersection.country_code_base GROUP BY country_code_base ORDER BY total desc;

.output intersections.csv
SELECT country_code_base, group_concat(country_code_compare), group_concat(intersections) FROM (SELECT * FROM country_intersection ORDER BY intersections desc) GROUP BY country_code_base;
.output stdout

-- SELECT a, b from (
--   SELECT a.ISO2 a, b.ISO2 b
--   FROM country a
--   INNER JOIN country b
--   ON a.ISO2 != b.ISO2
-- );

