
`top1k.csv` is exported from the output of `bigquery.sql`

Create a new month:
```
mkdir 082022
sqlite3 data.sqlite -cmd ".cd 082022" -cmd ".read ../schema.sql" ".read ../report.sql"
deno run -A update-tlds.js 082022/data.sqlite
```


```
# Iterate on schema
rm -f 082022/data.sqlite && sqlite3 data.sqlite -cmd ".cd 082022" -cmd ".read ../schema.sql" ".read ../report.sql"

# Just reporting
sqlite3 data.sqlite -cmd ".cd 082022" ".read ../report.sql"
```

```
datasette 082022/data.sqlite -o  
```
