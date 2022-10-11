import { getPublicSuffix } from "https://esm.sh/tldjs";
import { DB } from "https://deno.land/x/sqlite/mod.ts";

import { parse } from "https://deno.land/std/flags/mod.ts";
let args = parse(Deno.args);

let filename = args["_"];

if (!filename) {
  throw new Error("Must supply a sqlite filename");
}

const db = new DB(filename);

console.log(
  "Origins missing TLD (before)",
  db.query(`
SELECT COUNT(*) from origin where tld is null;
`)
);

let results = db.query(`
SELECT * from origin
WHERE tld IS NULL;
`);

db.transaction(() => {
  for (const [url] of results) {
    // console.log(url, getPublicSuffix(url));
    db.query(
      `
        UPDATE origin
        SET tld=?
        WHERE url=?;
  `,
      [getPublicSuffix(url), url]
    );
  }
});

console.log(
  "Origins missing TLD (after)",
  db.query(`
SELECT COUNT(*) from origin where tld is null;
`)
);
