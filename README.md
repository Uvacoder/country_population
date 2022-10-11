

```
wget "https://population.un.org/wpp/Download/Files/1_Indicators%20(Standard)/CSV_FILES/WPP2022_Demographic_Indicators_Medium.zip" -O un-indicators.zip && unzip -o un-indicators.zip -d un-indicators && cp un-indicators/WPP2022_Demographic_Indicators_Medium.csv ./un-indicators.csv && rm -r un-indicators un-indicators.zip
deno run -A process-un.js
```