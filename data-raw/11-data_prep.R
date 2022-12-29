########################################
# UK STATIONS USAGE * DATA PREPARATION #
########################################
# This script is based on a preprocessing done in Excel over tables 1410 and 1415 from ORR 
# https://dataportal.orr.gov.uk/statistics/usage/estimates-of-station-usage
# methodology: https://dataportal.orr.gov.uk/media/1917/station-usage-quality-and-methodology-report.pdf

Rfuns::load_pkgs('data.table', 'sf')

out_path <- file.path(datauk_path, 'stations_usage')
dbn <- 'stations_usage_uk'
yoa <- RpostcodesUK::OA |> st_transform(27700)

## DATASET --------
yv <- readxl::read_xlsx('./data-raw/csv/stations_usage.xlsx', sheet = 'dataset') |> 
        as.data.table() |> 
        melt(id.vars = 'NLC', variable.factor = FALSE)

yv[, c('year', 'metric') := tstrsplit(variable, '_', fixed = TRUE)][, variable := NULL]
setcolorder(yv, c('NLC', 'year', 'metric'))
yv <- yv[!is.na(value)]
yv[, `:=`( 
    year = as.integer(year), 
    metric = factor(metric, levels = c('Full', 'Reduced', 'Season', 'Total', 'Rank', 'VarYoY', 'Changes' ))
)]
save_dts_pkg(yv, 'dataset', out_path, c('NLC', 'year'), TRUE, dbn)

## STATIONS -------
ys <- readxl::read_xlsx('./data-raw/csv/stations_usage.xlsx', sheet = 'stations')
ysg <- ys |> st_as_sf(coords = c('Easting', 'Northing'), crs = 27700)
ys <- data.table(
        ys, 
        ysg |> 
            st_transform(4326) |> 
            st_coordinates() |> 
            st_drop_geometry() |> 
            as.data.table() |> 
            setnames(c('x_lon', 'y_lat')),
        ysg |> 
            st_join(yoa, join = st_within) |> 
            subset(select = 'OA') |> 
            st_drop_geometry()
) |> setcolorder(c('NLC', 'TLC', 'name', 'x_lon', 'y_lat', 'OA'))
ysm <- ys[is.na(OA)]
if(nrow(ysm) > 0){
    ysm <- data.table(
              NLC = ysm$NLC, 
              yoa[ysg |> subset(NLC %in% ysm$NLC) |> st_nearest_feature(yoa),] |> st_drop_geometry()
    )
    ys <- ysm[ys, on = 'NLC'][is.na(OA), OA := i.OA][, i.OA := NULL]
}
ys[, started_at := NULL]
yn <- names(ys)
ys[, has_interchange := 'No'][NLC %in% unique(yv[metric == 'Changes' & value > 0, NLC]), has_interchange := 'Yes']
ys <- yv[metric == 'Total', .(started_at = min(year)), NLC][ys, on = 'NLC']
setcolorder(ys, yn)
save_dts_pkg(ys, 'stations', out_path, 'NLC', TRUE, dbn)

## DISTANCES ------
yd <- st_distance(ysg) |> as.data.table()
names(yd) <- as.character(ysg$NLC)
yd[, NLCa := ysg$NLC]
yd <- melt(yd, id.vars = 'NLCa', variable.name = 'NLCb', value.name = 'distance', variable.factor = FALSE)
yd <- yd[, lapply(.SD, as.integer)][NLCa != NLCb][order(NLCa, distance)]
yd[, knn := 1:.N, NLCa]
save_dts_pkg(yd, 'distances', out_path, 'NLCa', TRUE, dbn, csv2zip = TRUE)

## CLEANING -------
rm(list = ls())
gc()