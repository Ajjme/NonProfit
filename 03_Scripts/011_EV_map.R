

source("./03_Scripts/000_init.R")

EV_stations <- readRDS(file = "./04_Outputs/rds/EV_stations.rds.rds")
Hydrogen_stations <- readRDS(file = "./04_Outputs/rds/Hydrogen_stations.rds")
CNG_stations <- readRDS(file = "./04_Outputs/rds/EV_stations.rds")
#style------------------
#Coloring Icons in map!!!
getColor <- function(EV_stations) {
  sapply(EV_stations$Total_stations, function(Total_stations) {
    if(Total_stations <= 20) {
      "green"
    } else if(Total_stations <= 5) {
      "orange"
    } else {
      "red"
    } })
}

icons <- awesomeIcons(
  icon = 'ios-close',
  iconColor = 'black',
  library = 'ion',
  markerColor = getColor(EV_stations)
)

#map-------------------

leaflet() %>% setView(lng = -98.583, lat = 39.833, zoom = 3) %>%
  addTiles() %>%
  addGeoJSON(Cities, weight = 1, color = "#444444", fill = FALSE)

#Custer------------
leaflet(data = EV_stations) %>% addTiles() %>%
  addProviderTiles(providers$CartoDB.Positron)%>%
  addMarkers(
    clusterOptions = markerClusterOptions(), label = ~as.character(Total_stations)
  )


#individual------------
map_of_EV_small <-leaflet(data = EV_stations) %>% addTiles() %>%
  addProviderTiles(providers$CartoDB.Positron)%>%
  addGeoJSON(Cities, weight = 1, color = "#444444", fill = FALSE)%>%
  addAwesomeMarkers(lng = ~Longitude, lat = ~Latitude, popup = ~as.character(Facility.Type), icon=icons, label = ~as.character(Total_stations))

saveWidget(map_of_EV_small, file="./04_Outputs/html/map_of_EV_small_full.html")

