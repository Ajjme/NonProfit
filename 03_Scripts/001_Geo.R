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

library(ggmap)

# this sets your google map for this session
source("./03_Scripts/000_init.R")
source("../Special/API.R")
register_google(key)

San_Ramon_map <- get_map(location ='San Ramon', source="stamen")
ggmap(San_Ramon_map)
