pkgs <- c('popiFun', 'data.table', 'sp')
lapply(pkgs, require, char = TRUE)

## STATIONS -------------------------------------

# load dataset
ys <- fread('./data/stations_ori.csv')

# find long & lat in WGS84, then add to dataset
ysp <- ys[, .(NLC, Easting, Northing)]
coordinates(ysp) <- ~Easting+Northing
proj4string(ysp) <- crs.gb
ysp <- spTransform(ysp, crs.wgs)
ysc <- data.table(yp@data, yp@coords)
setnames(ysc, c('NLC', 'x_lon', 'y_lat'))
ys <- ysc[ys, on = 'NLC']
setcolorder(ys, c('NLC', 'TLC', 'name'))

# find output areas (PiP), then add to dataset
bnd <- readRDS(file.path(bnduk_path, 'rds', 's05', 'OA'))
yo <- ysp[bnd,]


# calculate distances between all stations




## DATASET --------------------------------------
yd <- fread('./data/dataset_ori.csv', na.strings = '')
yd <- melt(yd, id.vars = 'NLC')
yd[, c('year', 'metric') := tstrsplit(variable, '_', fixed = TRUE)]

# add first year of data to stations
y <- yd[!is.na(value) & metric == 'Total', .(has_started = min(year)), NLC][ys, on = 'NLC']



# save
fwrite(ys, './data/stations.csv')
fwrite(yd, './data/dataset.csv')


## CLEANING -------------------------------------
