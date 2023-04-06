

source("./03_Scripts/000_init.R")

EV_stations <- readRDS(file = "./04_Outputs/rds/EV_stations.rds")
EV_stations_total_ccc <- readRDS(file = "./04_Outputs/rds/EV_stations_total_ccc.rds")
Hydrogen_stations <- readRDS(file = "./04_Outputs/rds/Hydrogen_stations.rds")
CNG_stations <- readRDS(file = "./04_Outputs/rds/EV_stations.rds")
#style------------------
#Coloring Icons in map!!!
#Could make a misive file with this code!
getColor <- function(EV_stations_ccc) {
  sapply(EV_stations_ccc$Total_stations, function(Total_stations) {
    if(Total_stations <= 15) {
      "green"
    } else if(Total_stations <= 5) {
      "orange"
    } else {
      "grey"
    } })
}

icons <- awesomeIcons(
  icon = 'ios-close',
  iconColor = 'black',
  library = 'ion',
  markerColor = getColor(EV_stations_ccc)
)

Cities <- fromJSON("./05_Geo/stanford-vj593xs7263-geojson.json", simplifyDataFrame=FALSE)

#individual------------
map_of_EV_small_ccc <-leaflet(data = EV_stations_ccc) %>% addTiles() %>%
  addProviderTiles(providers$CartoDB.Positron)%>%
  addGeoJSON(Cities, weight = 1, color = "#444444", fill = FALSE)%>%
  addAwesomeMarkers(lng = ~Longitude, lat = ~Latitude, popup = ~as.character(Facility.Type), icon=icons, label = ~as.character(Total_stations))

saveWidget(map_of_EV_small_ccc, file="./04_Outputs/html/map_of_EV_ccc.html")


####
###big file ####
####
#Could make a misive file with this code!
getColor <- function(EV_stations) {
  sapply(EV_stations$Total_stations, function(Total_stations) {
    if(Total_stations <= 20) {
      "green"
    } else if(Total_stations <= 5) {
      "orange"
    } else {
      "grey"
    } })
}

icons <- awesomeIcons(
  icon = 'ios-close',
  iconColor = 'black',
  library = 'ion',
  markerColor = getColor(EV_stations)
)

Cities <- fromJSON("./05_Geo/stanford-vj593xs7263-geojson.json", simplifyDataFrame=FALSE)

#individual------------
map_of_EV_small <-leaflet(data = EV_stations) %>% addTiles() %>%
  addProviderTiles(providers$CartoDB.Positron)%>%
  addGeoJSON(Cities, weight = 1, color = "#444444", fill = FALSE)%>%
  addAwesomeMarkers(lng = ~Longitude, lat = ~Latitude, popup = ~as.character(Facility.Type), icon=icons, label = ~as.character(Total_stations))

#saveWidget(map_of_EV_small, file="./04_Outputs/html/map_of_EV_small_full.html")

#Custer------------
leaflet(data = EV_stations) %>% addTiles() %>%
  addProviderTiles(providers$CartoDB.Positron)%>%
  addMarkers(
    clusterOptions = markerClusterOptions(), label = ~as.character(Total_stations)
  )
#map test -------------------
# 
# leaflet() %>% setView(lng = -98.583, lat = 39.833, zoom = 3) %>%
#   addTiles() %>%
#   addGeoJSON(Cities, weight = 1, color = "#444444", fill = FALSE)