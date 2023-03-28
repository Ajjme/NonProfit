install.packages("tidyverse")

library(tidyverse)

Alt_stations <- read.csv("alt_fuel_stations.csv")

Cities <- fromJSON(file = "stanford-vj593xs7263-geojson.json")

colnames(Alt_stations)

#creating different station type dfs
EV_stations <- Alt_stations %>% select(Fuel.Type.Code, City, Latitude, Longitude, State, EV.Level1.EVSE.Num, EV.Level2.EVSE.Num, EV.DC.Fast.Count, EV.Network, ID, Facility.Type, EV.Pricing, EV.On.Site.Renewable.Source, Restricted.Access) %>%
  filter(Fuel.Type.Code == "ELEC") %>%
  replace(is.na(.), 0)%>%
  mutate(Total_stations = EV.Level1.EVSE.Num+EV.Level2.EVSE.Num+EV.DC.Fast.Count)

Hydrogen_stations <- Alt_stations %>% select(Fuel.Type.Code, City, Latitude, Longitude, State, Hydrogen.Status.Link, Hydrogen.Is.Retail, Hydrogen.Pressures, Hydrogen.Standards)

CNG_stations <- Alt_stations%>% select(Fuel.Type.Code, City, Latitude, Longitude, State, CNG.Fill.Type.Code, CNG.Storage.Capacity, CNG.Total.Compression.Capacity, CNG.Vehicle.Class, CNG.On.Site.Renewable.Source, CNG.Dispenser.Num, CNG.PSI)



