
import table_to_csv_headless from "https://deno.land/x/table_to_csv/table_to_csv_headless.js";
let resp = await fetch(
  "https://en.wikipedia.org/wiki/ISO_3166-1"
);
let text = await resp.text();
let csv = table_to_csv_headless(text, {
  tableSelector: "table.wikitable:nth-child(32)",
});

Deno.writeTextFileSync("iso_codes.csv", csv)
