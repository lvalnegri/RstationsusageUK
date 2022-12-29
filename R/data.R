#' @importFrom data.table data.table
NULL

#' Stations
#'
#' List of Railway Stations in Great Britain
#' 
#' @format A data.table with the following columns:
#' \describe{
#'   \item{NLC}{National Location Code}
#'   \item{TLC}{Three Letter Code}
#'   \item{name}{Name of Station}
#'   \item{x_lon}{The geographic longitude of the station (WGS84, EPSG:4326)}
#'   \item{y_lat}{The geographic latitude of the station (WGS84, EPSG:4326)}
#'   \item{OA}{Output Area that contains the station }
#'   \item{Easting}{The Easting reference for the station (British National Grid, EPSG:27700)}
#'   \item{Northing}{The Northing reference for the station (British National Grid, EPSG:27700)}
#'   \item{facility_owner}{The company that owns the station (as of last year)}
#'   \item{PTE_urban_area}{The station is within a urban area covered by PTE services}
#'   \item{is_london_travelcard}{The station is within a urban area covered by TfL services}
#'   \item{NRR}{High level Network Rail route associated with the station}
#'   \item{SRS}{Strategic Route Section code associated with the station}
#'   \item{SRSn}{Strategic Route Section name associated with the station}
#'   \item{is_request_stop}{Indicates if the stations is only on request}
#'   \item{has_interchange}{Indicates if the stations has interchange between two or more lines}
#'   \item{started_at}{First year of data collection}
#' }
#'
'stations'

#' Estimates of Station usage
#'
#' Annual estimates of the number of Entries/Exits (Totals plus Full/Reduced/Season tickets), 
#' and Interchanges at each Station in Great Britain.
#' 
#' @format A data.table with the following columns:
#' \describe{
#'   \item{NLC}{National Location Code}
#'   \item{year}{Financial year}
#'   \item{metric}{One in: `Total`, `Full`, `Reduced`, `Season`, `Rank`, `VarYoY`, `Changes`}
#'   \item{value}{The value for the Metric}
#' }
#'
'dataset'

#' Distances
#'
#' Linear Distances between each pair of Stations
#' 
#' @format A data.table with the following columns:
#' \describe{
#'   \item{NLCa}{National Location Code}
#'   \item{NLCb}{National Location Code}
#'   \item{distance}{Linear distance in metres}
#'   \item{knn}{The order of neighborhood}
#' }
#'
'distances'
