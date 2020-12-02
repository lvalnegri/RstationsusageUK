
# load packages
pkgs <- c('popiFun', 'data.table', 'sp')
lapply(pkgs, require, char = TRUE)

## STATIONS -------------------------------------

# load dataset
ys <- fread('./data/stations_ori.csv', na.strings = '')
ys[ys == ''] <- NA

# find long & lat in WGS84, then add to dataset
ysp <- ys[, .(NLC, Easting, Northing)]
coordinates(ysp) <- ~Easting+Northing
proj4string(ysp) <- crs.gb
ysp <- spTransform(ysp, crs.wgs)
ysc <- data.table(ysp@data, ysp@coords)
setnames(ysc, c('NLC', 'x_lon', 'y_lat'))
ys <- ysc[ys, on = 'NLC']
setcolorder(ys, c('NLC', 'TLC', 'name'))
yn <- names(ys)[1:which(names(ys) == 'Northing')]

# find output areas (PiP), then add to dataset
bnd <- readRDS(file.path(bnduk_path, 'rds', 's05', 'OA'))
yo <- data.table(ysp$NLC, over(ysp, bnd))
setnames(yo, c('NLC', 'OA'))
# library(leaflet)
# leaflet() %>% 
#     addTiles() %>% 
#     addPolygons(data = subset(bnd, id %in% yo$OA), weight = 2) %>% 
#     addCircleMarkers(data = ys, lng = ~x_lon, lat = ~y_lat, radius = 6, weight = 1, color = 'black', fillColor = 'orange', label = ~paste(NLC, '*', name))
ys <- yo[ys, on = 'NLC']
setcolorder(ys, yn)

# calculate distances between all stations
yd <- calc_distances(ys, cid = 'NLC', verbose = TRUE)
fwrite(yd, './data/distances.csv')
zip('./data/distances', './data/distances.csv')


## DATASET --------------------------------------
yd <- fread('./data/dataset_ori.csv', na.strings = '')
yd <- melt(yd, id.vars = 'NLC')
yd[, c('year', 'metric') := tstrsplit(variable, '_', fixed = TRUE)]

# add first year of data to stations
ys <- yd[!is.na(value) & metric == 'Total', .(has_started = min(year)), NLC][ys, on = 'NLC']



# save
fwrite(ys, './data/stations.csv')
fwrite(yd, './data/dataset.csv')


## CLEANING -------------------------------------
