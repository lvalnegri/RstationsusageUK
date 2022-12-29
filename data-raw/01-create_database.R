###################################################################
# UK STATIONS USAGE * Create databases and tables in MySQL server #
###################################################################

library(Rfuns)

dbn <- 'stations_usage_uk'
dd_create_db(dbn)

## STATIONS -------
x <- "
    `NLC` SMALLINT UNSIGNED NOT NULL,
    `TLC` CHAR(3) NOT NULL,
    `name` CHAR(50) NOT NULL,
    `x_lon` DECIMAL(10,8) NOT NULL,
    `y_lat` DECIMAL(10,8) NOT NULL,
    `OA` CHAR(9) NOT NULL,
    `Easting` MEDIUMINT UNSIGNED NOT NULL,
    `Northing` MEDIUMINT UNSIGNED NOT NULL,
    `facility_owner` CHAR(50) NOT NULL,
    `PTE_urban_area` CHAR(20) NULL DEFAULT NULL,
    `is_london_travelcard` CHAR(3) NOT NULL,
    `NRR` CHAR(20) NOT NULL,
    `SRS` CHAR(4) NULL DEFAULT NULL,
    `SRSn` CHAR(120) NULL DEFAULT NULL,
    `has_interchange` CHAR(3) NOT NULL,
    `is_request_stop` CHAR(3) NOT NULL,
    `started_at` SMALLINT UNSIGNED NOT NULL,
    PRIMARY KEY (`NLC`),
    UNIQUE KEY `TLC` (`TLC`),
    KEY `OA` (`OA`),
    KEY `SRS` (`SRS`),
    KEY `is_london_travelcard` (`is_london_travelcard`)
"
dd_create_dbtable('stations', dbn, x)

## DATASET --------
x <- "
    `NLC` SMALLINT UNSIGNED NOT NULL,
    `year` SMALLINT UNSIGNED NOT NULL,
    `metric` CHAR(7) NOT NULL,
    `value` INT NOT NULL,
    PRIMARY KEY (`NLC`, `year`, `metric`)
"
dd_create_dbtable('dataset', dbn, x)

## DISTANCES ------
x <- "
    `NLCa` SMALLINT UNSIGNED NOT NULL,
    `NLCb` SMALLINT UNSIGNED NOT NULL,
    `distance` MEDIUMINT UNSIGNED NOT NULL,
    `knn` SMALLINT UNSIGNED NOT NULL,
    PRIMARY KEY (`NLCa`, `NLCb`)
"
dd_create_dbtable('distances', dbn, x)

## END ------------
rm(list = ls())
gc()
