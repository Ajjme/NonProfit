

source("./03_Scripts/000_init.R")

EV_stations <- readRDS(file = "./04_Outputs/rds/EV_stations.rds")
EV_stations_total_ccc <- readRDS(file = "./04_Outputs/rds/EV_stations_total_ccc.rds") 

EV_stations_ccc <- readRDS( file = "./04_Outputs/rds/EV_stations_ccc.rds") %>% 
  mutate(Total_stations = as.numeric(Total_stations)) %>% 
  rename(ev_network = EV.Network) %>% 
  filter(ID != as.numeric("306576"),
         ID != as.numeric("306577"),
         ID != as.numeric("306575"))


Hydrogen_stations <- readRDS(file = "./04_Outputs/rds/Hydrogen_stations.rds")
CNG_stations <- readRDS(file = "./04_Outputs/rds/EV_stations.rds")
#style------------------

Cities <- read_json("./05_Geo/stanford-vj593xs7263-geojson.json",  simplifyVector = FALSE)

#mapping colors to sites
#colors <- c("grey", "red", "chargepoint", "green", "blink", "electrify america", "pink g", "yellow", "purple g", "orange g", "lightgreen g")

colors <- c("green", "red", "darkred", "green", "blue", "lightblue", "pink", "orange", "purple", "green", "lightgreen")

icons <- awesomeIcons(
  icon = "ion-ios-bolt-outline",
  iconColor = 'black',
  library = 'ion',
  markerColor = colors[match(EV_stations_ccc$ev_network, unique(EV_stations_ccc$ev_network))]
)

# Map with colored icons
map_of_EV_small_ccc <- leaflet(data = EV_stations_ccc) %>% 
  addTiles() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addGeoJSON(Cities, weight = 1, color = "#444444", fill = FALSE) %>%
  addAwesomeMarkers(
    lng = ~Longitude,
    lat = ~Latitude,
    popup = ~paste(as.character(Facility.Type), "<br>", City, "<br>", ev_network),
    icon = icons,
    label = ~as.character(Total_stations)
    
    )

#saveWidget(map_of_EV_small_ccc, file="./06_Reports_Rmd/map_of_EV_small_full_ccc.html")
saveRDS(map_of_EV_small_ccc, file = "./06_Reports_Rmd/map_of_EV_small_ccc.rds")



# 
# 
# 
# ####
# ###big file ####
# ####
# #Could make a misive file with this code!
# getColor <- function(EV_stations) {
#   sapply(EV_stations$Total_stations, function(Total_stations) {
#     if(Total_stations <= 20) {
#       "green"
#     } else if(Total_stations <= 5) {
#       "orange"
#     } else {
#       "grey"
#     } })
# }
# 
# icons <- awesomeIcons(
#   icon = 'ios-close',
#   iconColor = 'black',
#   library = 'ion',
#   markerColor = getColor(EV_stations)
# )
# 
# Cities <- fromJSON("./05_Geo/stanford-vj593xs7263-geojson.json", simplifyDataFrame=FALSE)
# 
# #individual------------
# map_of_EV_small <-leaflet(data = EV_stations) %>% addTiles() %>%
#   addProviderTiles(providers$CartoDB.Positron)%>%
#   addGeoJSON(Cities, weight = 1, color = "#444444", fill = FALSE)%>%
#   addAwesomeMarkers(lng = ~Longitude, lat = ~Latitude, popup = ~as.character(Facility.Type), icon=icons, label = ~as.character(Total_stations))
# 
# saveWidget(map_of_EV_small, file="./06_Reports_Rmd/map_of_EV_small_full.html")
# 
# #Custer------------
# leaflet(data = EV_stations) %>% addTiles() %>%
#   addProviderTiles(providers$CartoDB.Positron)%>%
#   addMarkers(
#     clusterOptions = markerClusterOptions(), label = ~as.character(Total_stations)
#   )
# 
# 
# #Archive ----------------
# icons <- awesomeIcons(
#   icon = "ion-ios-bolt-outline",
#   iconColor = 'black',
#   library = 'ion',
#   markerColor = "green"
# )
# #individual CCC------------
# map_of_EV_small_ccc <-leaflet(data = EV_stations_ccc) %>% addTiles() %>%
#   addProviderTiles(providers$CartoDB.Positron)%>%
#   addGeoJSON(Cities, weight = 1, color = "#444444", fill = FALSE)%>%
#   addAwesomeMarkers(lng = ~Longitude, lat = ~Latitude, popup = ~paste(as.character(Facility.Type), "<br>", City,  "<br>", ev_network), 
#                     icon = icons,
#                     label = ~as.character(Total_stations))
# map_of_EV_small_ccc
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# #not
#   # Define a color palette for the marker groups
#   pal <- colorFactor(palette = "Set1", domain = EV_stations_ccc$ev_network)
# 
# # Create the map with colored markers
# map_of_EV_small_ccc <- leaflet(data = EV_stations_ccc) %>% 
#   addTiles() %>%
#   addProviderTiles(providers$CartoDB.Positron) %>%
#   addGeoJSON(Cities, weight = 1, color = "#444444", fill = FALSE) %>%
#   addCircleMarkers(
#     lng = ~Longitude, 
#     lat = ~Latitude, 
#     radius = 5,  # set the radius of the markers
#     color = "#000000",  # set the color of the marker border
#     stroke = TRUE,  # show the marker border
#     fillOpacity = 0.8,  # set the opacity of the marker fill
#     fillColor = ~pal(ev_network),  # set the marker fill color based on the group
#     popup = ~paste(as.character(Facility.Type), "<br>", City)
#   )
# # Show the map
# map_of_EV_small_ccc
# #map test -------------------
# # 
# # leaflet() %>% setView(lng = -98.583, lat = 39.833, zoom = 3) %>%
# #   addTiles() %>%
# #   addGeoJSON(Cities, weight = 1, color = "#444444", fill = FALSE)