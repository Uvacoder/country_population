
-- This is meant to be run after '.cd' into a subfolder (for example `.cd 082022`), so the paths are relative to that 
-- sqlite3 data.sqlite -cmd ".cd 082022" -cmd ".read ../schema.sql" ".read ../report.sql"

CREATE TABLE "country"(
"name" TEXT NOT NULL, "ISO3" TEXT NOT NULL, "ISO2" TEXT NOT NULL PRIMARY KEY, "population" INTEGER NOT NULL);

.mode csv
.import ../../country_population_noheaders.csv country

CREATE TABLE "origin"(
"url" TEXT NOT NULL PRIMARY KEY,
"tld" TEXT);

CREATE TABLE "country_origin"(
  "country_code" TEXT NOT NULL,
  "origin" TEXT NOT NULL,
  FOREIGN KEY(country_code) REFERENCES country(ISO2),
  FOREIGN KEY(origin) REFERENCES origin(url)
);

CREATE INDEX idx_country_origin_country_code
ON country_origin (country_code);


CREATE TEMP TABLE "_csv_import" ("url" text, "country_code" text);

.import top1k.csv _csv_import

INSERT INTO origin (url) SELECT DISTINCT url
    FROM _csv_import;

INSERT INTO country_origin(country_code, origin) SELECT country_code, url as origin
    FROM _csv_import;

DROP TABLE _csv_import;


CREATE TEMP TABLE "_report_country" ("country_code");
INSERT INTO _report_country (country_code) SELECT DISTINCT country_code FROM country_origin;

CREATE TABLE "country_intersection"(
  "country_code_base" TEXT NOT NULL,
  "country_code_compare" TEXT NOT NULL,
  "intersections" INT NOT NULL,
  FOREIGN KEY(country_code_base) REFERENCES country(ISO2),
  FOREIGN KEY(country_code_compare) REFERENCES country(ISO2)
);


INSERT INTO country_intersection (country_code_base, country_code_compare, intersections)
  SELECT country_code_base, country_code_compare, (SELECT COUNT(*) FROM
                  (SELECT origin from country_origin WHERE country_code = country_code_base INTERSECT SELECT origin from country_origin WHERE country_code = country_code_compare)) intersections
  FROM (
  SELECT a.country_code country_code_base, b.country_code country_code_compare
  FROM _report_country a
  INNER JOIN _report_country b
  ON a.country_code != b.country_code
  );

DROP TABLE _report_country;
