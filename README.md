## Great Britain Rail Stations Usage

An $R$ package cotaining the annual estimates (by financial year since 1997/98) of the number of *Entries/Exits* (*Totals* plus *Full*/*Reduced*/*Season* tickets), and *Interchanges* at each Station in Great Britain.

The package is not on `CRAN`. To install the package:
```
remotes::install_github('lvalnegri/RstationsusageUK')
```

The package includes the following tables:
- `stations` the list of all *current* live stations (2,568 as of 31-12-2022), with geographic and projected coordinates and related *Output Area*.
- `dataset` the `Total` counts for *Entry&Exit* passengers, also segmented by `Full`, `Reduced`, and `Season` tickets, and  `Interchanges` at bigger stations. The `Rank` and  `VarYoY`, or variation year on year, is also provided.
- `distances` the linear distance in meters between each pair of stations.

All the above datasets are also provided in `csv` format in the `data-raw/csv` folder.

This is an early version containing only data. 

### Attributions
 - [ORR Office of Rail And Road, Estimates of station usage
](https://dataportal.orr.gov.uk/statistics/usage/estimates-of-station-usage), Tables 1410 and 1415. Last Published: 24-Nov-2022
 - Contains Ordnance Survey data © Crown copyright and database right 2022
