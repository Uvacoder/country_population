import papaparse from "https://esm.sh/papaparse/";

const { data: iso_codes } = papaparse.parse(
  Deno.readTextFileSync("iso_codes.csv").split("\n").slice(1).join("\n")
);

const { data: pop_total } = papaparse.parse(
  Deno.readTextFileSync("pop-total.csv").split("\n").slice(4).join("\n")
);

let country_code_index = pop_total[0].indexOf("Country Code");
let year_index = pop_total[0].indexOf("2021");

let result = [["ISO Alpha-2 code", "ISO Alpha-3 code", "Population"]];
for (let country of pop_total.slice(1)) {
  let two_letter = iso_codes.find((el) => {
    return el[2] == country[country_code_index];
  });

  if (!two_letter) {
    console.log(
      `Skipping ${country[country_code_index]} due to no matching ISO code`
    );
    console.log(country);
    continue;
  }

  two_letter = two_letter[1];
  console.log("FOUND ", two_letter, country[country_code_index]);
  result.push([
    two_letter,
    country[country_code_index],
    parseInt(country[year_index]),
  ]);
}

console.log(result);

Deno.writeTextFileSync("country_population.csv", papaparse.unparse(result));
