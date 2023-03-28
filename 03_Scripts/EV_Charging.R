# install.packages("tidyverse", type = "source")
# #install.packages("plotly", type = "source")
# #install.packages("rjson", type = "source")
# install.packages("ggplot2", type = "source")
# install.packages("dplyr", type = "source")
# #install.packages("geojsonio", type = "source")
# ##install.packages("leaflet")
# install.packages("leaflet")

library(tidyverse)
library(ggplot2)
#library(plotly)
#library(rjson)
library(dplyr)
library(jsonlite)

library(leaflet)
#may have to change downloaded name
Alt_stations <- read.csv("alt_fuel_stations.csv")

Cities <- fromJSON("stanford-vj593xs7263-geojson.json", simplifyDataFrame=FALSE)

colnames(Alt_stations)

Cities_list <- list("San Ramon", "Danville", "Antioch", "Brentwood","Clayton", "Concord", "El Cerrito", "Hercules", "Lafayette", "Martinez", 'Moraga', "Oakley", "Orinda", "Pinole", "Pittsburg", "Pleasant Hill", "Richmond", "San Pablo", "San Ramon", "Walnut Creek" )

#creating different station type dfs
EV_stations <- Alt_stations %>% select(Fuel.Type.Code, City, Longitude, Latitude, State, EV.Level1.EVSE.Num, EV.Level2.EVSE.Num, EV.DC.Fast.Count, EV.Network, ID, Facility.Type, EV.Pricing, EV.On.Site.Renewable.Source, Restricted.Access) %>%
  filter(Fuel.Type.Code == "ELEC") %>%
  filter(State == "CA") %>%
  #filter(City == "San Ramon"| City =="Danville"| City =="Antioch"|City =="Brentwood"|City =="Clayton"|City == "Concord"|City == "El Cerrito"|City == "Hercules"|City == "Lafayette"|City == "Martinez"|City == 'Moraga'|City == "Oakley"|City == "Orinda"|City == "Pinole"|City == "Pittsburg"|City == "Pleasant Hill"|City == "Richmond"|City == "San Pablo"|City == "San Ramon"|City == "Walnut Creek" )%>%
  #filter(City == Cities_list)%>%
  replace(is.na(.), 0)%>%
  mutate(Total_stations = EV.Level1.EVSE.Num+EV.Level2.EVSE.Num+EV.DC.Fast.Count)

# EV_stations <- Alt_stations %>% select(Fuel.Type.Code, City, Longitude, Latitude, State, EV.Level1.EVSE.Num, EV.Level2.EVSE.Num, EV.DC.Fast.Count, EV.Network, ID, Facility.Type, EV.Pricing, EV.On.Site.Renewable.Source, Restricted.Access) %>%
#   filter(Fuel.Type.Code == "ELEC") %>%
#   filter(State == "CA") %>%
#   filter(City == "San Ramon"| City =="Danville"| City =="Antioch"|City =="Brentwood"|City =="Clayton"|City == "Concord"|City == "El Cerrito"|City == "Hercules"|City == "Lafayette"|City == "Martinez"|City == 'Moraga'|City == "Oakley"|City == "Orinda"|City == "Pinole"|City == "Pittsburg"|City == "Pleasant Hill"|City == "Richmond"|City == "San Pablo"|City == "San Ramon"|City == "Walnut Creek" )%>%
#   #filter(City == Cities_list)%>%
#   replace(is.na(.), 0)%>%
#   mutate(Total_stations = EV.Level1.EVSE.Num+EV.Level2.EVSE.Num+EV.DC.Fast.Count)

EV_stations_total <- EV_stations%>%
  group_by(City)%>%
  summarise_at(vars(Total_stations),              # Specify column
      list(name = sum))

#QC
str(EV_stations)
sapply(EV_stations, class) 

Hydrogen_stations <- Alt_stations %>% select(Fuel.Type.Code, City, Latitude, Longitude, State, Hydrogen.Status.Link, Hydrogen.Is.Retail, Hydrogen.Pressures, Hydrogen.Standards)

CNG_stations <- Alt_stations%>% select(Fuel.Type.Code, City, Latitude, Longitude, State, CNG.Fill.Type.Code, CNG.Storage.Capacity, CNG.Total.Compression.Capacity, CNG.Vehicle.Class, CNG.On.Site.Renewable.Source, CNG.Dispenser.Num, CNG.PSI)

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

#map

leaflet() %>% setView(lng = -98.583, lat = 39.833, zoom = 3) %>%
  addTiles() %>%
  addGeoJSON(Cities, weight = 1, color = "#444444", fill = FALSE)

#Custer
leaflet(data = EV_stations) %>% addTiles() %>%
  addProviderTiles(providers$CartoDB.Positron)%>%
  addMarkers(
    clusterOptions = markerClusterOptions(), label = ~as.character(Total_stations)
  )


#individual
map_of_EV_small <-leaflet(data = EV_stations) %>% addTiles() %>%
  addProviderTiles(providers$CartoDB.Positron)%>%
  addGeoJSON(Cities, weight = 1, color = "#444444", fill = FALSE)%>%
  addAwesomeMarkers(lng = ~Longitude, lat = ~Latitude, popup = ~as.character(Facility.Type), icon=icons, label = ~as.character(Total_stations))

library(htmlwidgets)
saveWidget(map_of_EV_small, file="map_of_EV_small_full.html")

