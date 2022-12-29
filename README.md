## Great Britain Rail Stations Usage (data and shiny app)

Annual estimates of the number of Entries/Exits (Totals plus Full/Reduced/Season tickets), and Interchanges at each Station in Great Britain.

The package includes the following tables:
- `stations` the list of all *current* live stations (2,568 as of 31-12-2022), with geographic and projected coordinates and related *Output Area*.
- `dataset` the `Total` counts for *Entry&Exit* passengers, also segmented by `Full`, `Reduced`, and `Season` tickets, and  `Interchanges` at bigger stations. The `Rank` and  `VarYoY`, or variation year on year, is also provided.
- `distances` the linear distance in meters between each pair of stations.

The package is not on `CRAN`. To install the package:
```
remotes::install_github('lvalnegri/RstationsusageUK')
```

### Attributions

 - [ORR Office of Rail And Road, Estimates of station usage
](https://dataportal.orr.gov.uk/statistics/usage/estimates-of-station-usage), Tables 1410 and 1415. Last Published: 24-Nov-2022
 - Contains Ordnance Survey data © Crown copyright and database right 2022
