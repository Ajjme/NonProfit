#points for Lat and Log 
df_city_lat_long <- data.frame(
  city = c("Antioch", "Brentwood", "Clayton", "Concord", "Danville", "El Cerrito", "Hercules", 
           "Lafayette", "Martinez", "Moraga", "Oakley", "Orinda", "Pinole", "Pittsburg", 
           "Pleasant Hill", "Richmond", "San Pablo", "San Ramon", "Walnut Creek", "Uni. CCC"),
  Latitude = c(38.0049, 37.9319, 37.9410, 37.9775, 37.8216, 37.9172, 38.0171, 37.8858, 
               38.0194, 37.8349, 37.9974, 37.8771, 38.0044, 38.0272, 37.9485, 37.9358, 
               37.9622, 37.7799, 37.9101, 37.9264),
  Longitude = c(-121.8058, -121.6958, -121.9358, -122.0312, -121.9999, -122.3119, -122.2886, 
                -122.1180, -122.1339, -122.1297, -121.7125, -122.1797, -122.3011, -121.8847, 
                -122.0608, -122.3477, -122.3455, -121.9780, -122.0652, -121.9288)
)
df_city_lat_long <- df_city_lat_long %>% 
  mutate(city = str_to_lower(city)) %>% 
  clean_city_names_uni_ccc()

saveRDS(df_city_lat_long, file = "./04_Outputs/rds/df_city_lat_long.rds")
#unincorporated 
#approximately 37.9264 degrees North latitude and 121.9288 degrees West longitude.
library(ggmap)

# this sets your google map for this session
source("./03_Scripts/000_init.R")
source("../Special/API.R")
register_google(key)

San_Ramon_map <- get_map(location ='San Ramon', source="stamen")
ggmap(San_Ramon_map)


cities_ls <- full_mce %>% 
  select(community)

# Convert the data frame to a character vector
cities_vec <- unlist(cities_ls$community)

# View the resulting vector
cities_vec

#cities2 <- c("San Francisco", "Los Angeles", "San Diego", "Sacramento")


coords <- geocode(cities_vec, output = "more")

# Extract the city name from the location field and add it as a new column
coords$city <- gsub(",.*$", "", coords$address)

# View the resulting data frame
coords %>% 
  select(city, lon, lat)%>%
  na.omit()

saveRDS(coords, file = "./04_Outputs/rds/coords.rds")

### wow this acturally works
library(sf)
library(ggplot2)

# Load the shapefile of California cities
ca_cities <- st_read("./02_inputs/BND_LAFCO_City_SOI.shx")


library(rgdal)
library(sp)
library(sf)
library(terra)
#my_sf <- readOGR("./shapes/BND_LAFCO_City_SOI.shp")

my_sf_all_city_CA <- readOGR(dsn ="./02_inputs/City_Boundaries.shp")
saveRDS(my_sf, file = "./02_inputs/my_sf.rds")

require(sf)
shape <- read_sf(dsn = ".", layer = "./02_inputs/City_Boundaries.shp")

gj = system.file("shapes/cycle_hire.geojson",package="spData")

# # Geocoding API: You can use a geocoding API to retrieve latitude and longitude data for cities in California.
# Google Maps Platform and OpenCage Data are two popular geocoding APIs that offer free and paid plans.
# With these APIs, you can submit a city name or address and receive the corresponding latitude and longitude 
# coordinates.
# # 
# # Geospatial datasets: There are many geospatial datasets available online that include latitude and longitude
# data for cities in California. For example, the US Census Bureau's TIGER/Line Shapefiles include geographic data 
# for states, counties, and cities. The Natural Earth dataset is another option that provides geospatial data for 
# the world, including cities in California.
# # 
# # R packages: There are several R packages that include geospatial data for cities in California. For example, 
# the ggmap package provides latitude and longitude data for cities in California as part of its built-in datasets. 
# The maps package provides data for cities in California as well as other states in the US.