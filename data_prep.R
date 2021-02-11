########################################
# UK STATIONS USAGE * DATA PREPARATION #
########################################
# This script is based on a preprocessing done in Excel over tables 1410 and 1415 from ORR 
# https://dataportal.orr.gov.uk/statistics/usage/estimates-of-station-usage
# see also excel file <stations_usage.xlsx> in data subdirectory

# load packages
pkgs <- c('popiFun', 'data.table', 'sp')
lapply(pkgs, require, char = TRUE)

## STATIONS -------------------------------------

# load dataset
ys <- fread('./data/stations_ori.csv', na.strings = '')
ys[ys == ''] <- NA

# find long & lat in WGS84, then add to dataset
ys <- conv2spdf(ys, cid = 'NLC', ENtoLL = TRUE, output = 'mgdf')
ysp <- conv2spdf(ys, cid = 'NLC')
yn <- names(ys)[1:which(names(ys) == 'y_lat')]

# find output areas (PiP), then add to dataset
bnd <- readRDS(file.path(bnduk_path, 'rds', 's00', 'OA'))
yo <- data.table(ysp$NLC, over(ysp, bnd))
setnames(yo, c('NLC', 'OA'))
ys <- yo[ys, on = 'NLC']
setcolorder(ys, yn)

# calculate distances between all stations
yd <- calc_distances(ys, cid = 'NLC', verbose = TRUE)
fwrite(yd, './data/distances.csv')
zip('./data/distances', './data/distances.csv')


## DATASET --------------------------------------

#load data
yd <- fread('./data/dataset_ori.csv', na.strings = '')

# transform in long format
yd <- melt(yd, id.vars = 'NLC')

# split column names into variables
yd[, c('year', 'metric') := tstrsplit(variable, '_', fixed = TRUE)][, variable := NULL]
setcolorder(yd, c('NLC', 'year', 'metric'))

# clean unavailable data
yd <- yd[!is.na(value)]

# add first year of data to stations
yn <- names(ys)[1:which(names(ys) == 'OA')]
ys <- yd[metric == 'Total', .(has_started = min(year)), NLC][ys, on = 'NLC']
ys <- ys[!is.na(has_started)]
setcolorder(ys, yn)

# save as csv
fwrite(ys, './data/stations.csv')
fwrite(yd, './data/dataset.csv')

# reclass
yd[, `:=`( 
    year = as.integer(year), 
    metric = factor(metric, levels = c('Full', 'Reduced', 'Season', 'Total', 'Rank', 'VarYoY', 'Changes' ))
)]
cols <- names(ys)[which(names(ys) == 'facility_owner'):ncol(ys)]
ys[, (cols) := lapply(.SD, factor), .SDcols = cols]
     
# save as fst
fst::write_fst(ys, './data/stations')
fst::write_fst(yd, './data/dataset')


## CLEANING -------------------------------------
rm(list = ls())
gc()