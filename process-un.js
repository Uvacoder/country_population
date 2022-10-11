import papaparse from "https://esm.sh/papaparse/";

let { data } = papaparse.parse(Deno.readTextFileSync("un-indicators.csv"), {
  dynamicTyping: true,
  header: true,
});

data = data
  .filter((row) => row.ISO3_code && row.Time == 2021)
  .map((row) => ({
    Name: row.Location,
    ISO3: row.ISO3_code,
    ISO2: row.ISO2_code,
    Population: Math.round(row.TPopulation1July),
  }))
  .sort((a, b) => b.Population - a.Population);

console.log(data.slice(0, 10), data.length);
// SortOrder,LocID,Notes,ISO3_code,ISO2_code,SDMX_code,LocTypeID,LocTypeName,ParentID,Location,VarID,Variant,Time,TPopulation1Jan,TPopulation1July


Deno.writeTextFileSync("country_population.csv", papaparse.unparse(data));
