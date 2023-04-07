
source("./03_Scripts/000_init.R")
### Inputs------------------
#may have to change downloaded name
#https://afdc.energy.gov/data_download/

Alt_stations <- read.csv("./02_inputs/alt_fuel_stations (Mar 31 2023).csv")

#Cities <- fromJSON("stanford-vj593xs7263-geojson.json", simplifyDataFrame=FALSE)

colnames(Alt_stations)

Cities_list <- list("San Ramon", "Danville", "Antioch", "Brentwood","Clayton", 
                    "Concord", "El Cerrito", "Hercules", "Lafayette", "Martinez",
                    'Moraga', "Oakley", "Orinda", "Pinole", "Pittsburg", "Pleasant Hill",
                    "Richmond", "San Pablo", "San Ramon", "Walnut Creek" )
census_designated_zones <-
  c(
    "Alamo",
    "Alhambra Valley",
    "Bay Point",
    "Bayview-Montalvin",
    "Bethel Island",
    "Blackhawk-Camino Tassajara",
    "Byron",
    "Camino Tassajara",
    "Castle Hill",
    "Clyde",
    "Crockett",
    "Diablo",
    "Discovery Bay",
    "East Richmond Heights",
    "El Sobrante",
    "Knightsen",
    "North Richmond",
    "Pacheco",
    "Port Costa",
    "Reliez Valley",
    "Rodeo",
    "Rollingwood",
    "Saranap",
    "Shell Ridge",
    "Tara Hills",
    "Vine Hill"
  )

### Main df--------------------------
#creating different station type dfs
EV_stations <- Alt_stations %>% select(ï..Fuel.Type.Code, City, Longitude, Latitude, State, EV.Level1.EVSE.Num, EV.Level2.EVSE.Num, EV.DC.Fast.Count, EV.Network, ID, Facility.Type, EV.Pricing, EV.On.Site.Renewable.Source, Restricted.Access) %>%
  filter(ï..Fuel.Type.Code == "ELEC") %>%
  filter(State == "CA") %>%
  replace(is.na(.), 0)%>%
  mutate(Total_stations = EV.Level1.EVSE.Num+EV.Level2.EVSE.Num+EV.DC.Fast.Count)

### totals----------------
EV_stations_total <- EV_stations%>%
  group_by(City)%>%
  summarise_at(vars(Total_stations),              # Specify column
      list(Total_stations = sum))

EV_stations_total_ccc <- EV_stations_total %>%
  filter(
    City == "San Ramon" |
      City == "Danville" |
      City == "Antioch" |
      City == "Brentwood" |
      City == "Clayton" |
      City == "Concord" |
      City == "El Cerrito" |
      City == "Hercules" |
      City == "Lafayette" |
      City == "Martinez" |
      City == 'Moraga' |
      City == "Oakley" |
      City == "Orinda" |
      City == "Pinole" |
      City == "Pittsburg" |
      City == "Pleasant Hill" |
      City == "Richmond" |
      City == "San Pablo" | City == "San Ramon" |
      City == "Walnut Creek" |
      City == "Byron" |
      City == "El Sobrante" 
  ) 

EV_stations_ccc <- EV_stations %>%
  filter(
    City == "San Ramon" |
      City == "Danville" |
      City == "Antioch" |
      City == "Brentwood" |
      City == "Clayton" |
      City == "Concord" |
      City == "El Cerrito" |
      City == "Hercules" |
      City == "Lafayette" |
      City == "Martinez" |
      City == 'Moraga' |
      City == "Oakley" |
      City == "Orinda" |
      City == "Pinole" |
      City == "Pittsburg" |
      City == "Pleasant Hill" |
      City == "Richmond" |
      City == "San Pablo" | City == "San Ramon" |
      City == "Walnut Creek"
  ) 

### CCC -------------------------
EV_stations_total_uni_ccc <- EV_stations_total %>%
  filter(City %in% census_designated_zones)

# 5 for UNI_CCC
#QC
# str(EV_stations)
# sapply(EV_stations, class) 

### other stations ----------------
Hydrogen_stations <-
  Alt_stations %>% select(
    ï..Fuel.Type.Code,
    City,
    Latitude,
    Longitude,
    State,
    Hydrogen.Status.Link,
    Hydrogen.Is.Retail,
    Hydrogen.Pressures,
    Hydrogen.Standards
  )

CNG_stations <-
  Alt_stations %>% select(
    ï..Fuel.Type.Code,
    City,
    Latitude,
    Longitude,
    State,
    CNG.Fill.Type.Code,
    CNG.Storage.Capacity,
    CNG.Total.Compression.Capacity,
    CNG.Vehicle.Class,
    CNG.On.Site.Renewable.Source,
    CNG.Dispenser.Num,
    CNG.PSI
  )


saveRDS(CNG_stations, file = "./04_Outputs/rds/CNG_stations.rds")

saveRDS(Hydrogen_stations, file = "./04_Outputs/rds/Hydrogen_stations.rds")

saveRDS(EV_stations, file = "./04_Outputs/rds/EV_stations.rds")

saveRDS(EV_stations_total, file = "./04_Outputs/rds/EV_stations_total.rds")

saveRDS(EV_stations_total_ccc, file = "./04_Outputs/rds/EV_stations_total_ccc.rds")

saveRDS(EV_stations_ccc, file = "./04_Outputs/rds/EV_stations_ccc.rds")
### Archive -----------

# EV_stations <- Alt_stations %>% select(Fuel.Type.Code, City, Longitude, Latitude, State, EV.Level1.EVSE.Num, EV.Level2.EVSE.Num, EV.DC.Fast.Count, EV.Network, ID, Facility.Type, EV.Pricing, EV.On.Site.Renewable.Source, Restricted.Access) %>%
#   filter(Fuel.Type.Code == "ELEC") %>%
#   filter(State == "CA") %>%
#   filter(City == "San Ramon"| City =="Danville"| City =="Antioch"|City =="Brentwood"|City =="Clayton"|City == "Concord"|City == "El Cerrito"|City == "Hercules"|City == "Lafayette"|City == "Martinez"|City == 'Moraga'|City == "Oakley"|City == "Orinda"|City == "Pinole"|City == "Pittsburg"|City == "Pleasant Hill"|City == "Richmond"|City == "San Pablo"|City == "San Ramon"|City == "Walnut Creek" )%>%
#   #filter(City == Cities_list)%>%
#   replace(is.na(.), 0)%>%
#   mutate(Total_stations = EV.Level1.EVSE.Num+EV.Level2.EVSE.Num+EV.DC.Fast.Count)