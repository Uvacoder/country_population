```
wget "https://api.worldbank.org/v2/en/indicator/SP.POP.TOTL?downloadformat=csv" -O pop-total.zip && unzip -o pop-total.zip -d pop_total && cp pop_total/API_SP.POP.TOTL_DS2_en_csv_v2_4578059.csv ./pop_total.csv && rm -r pop_total pop-total.zip

deno run -A download_iso_table.js
deno run -A create_population_table.js
```