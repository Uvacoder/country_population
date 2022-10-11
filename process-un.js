import papaparse from "https://esm.sh/papaparse/";

// SortOrder,LocID,Notes,ISO3_code,ISO2_code,SDMX_code,LocTypeID,LocTypeName,ParentID,Location,VarID,Variant,Time,TPopulation1Jan,TPopulation1July
let { data } = papaparse.parse(Deno.readTextFileSync("un-indicators.csv"), {
  dynamicTyping: true,
  header: true,
});

data = data.filter((row) => row.ISO3_code && row.Time == 2021);

data = data
  .map((row) => ({
    name: row.Location,
    ISO3: row.ISO3_code,
    ISO2: row.ISO2_code,
    population: Math.round(row.TPopulation1July),
  }))
  .sort((a, b) => b.population - a.population);

console.log(data.slice(0, 10), data.length);

Deno.writeTextFileSync("country_population.csv", papaparse.unparse(data));
Deno.writeTextFileSync(
  "country_population_noheaders.csv",
  papaparse.unparse(data, {
    header: false,
  })
);
