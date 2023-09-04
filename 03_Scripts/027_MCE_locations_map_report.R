full_mce <- readRDS( file = "./04_Outputs/rds/full_mce.rds")

city_data <- data.frame(
  community = c("Concord", "Contra Costa", "Danville", "El Cerrito", "Lafayette", "Martinez", "Moraga",
           "Oakley", "Pinole", "Pittsburg", "Pleasant Hill", "Richmond", "San Pablo", "San Ramon",
           "Walnut Creek", "Hercules", "Belvedere", "Corte Madera", "Fairfax", "Larkspur", "Marin County",
           "Mill Valley", "Novato", "Ross", "San Anselmo", "San Rafael", "Sausalito", "Tiburon",
           "American Canyon", "Calistoga", "Napa", "Napa Co.", "St. Helena", "Yountville", "Benicia",
           "Fairfield", "Vallejo", "Solano County"),
  Latitude = c(37.9775, 37.8534, 37.8216, 37.9163, 37.8858, 38.0194, 37.8349, 37.9974, 38.0044, 38.0275,
               37.9474, 37.9358, 37.9621, 37.7799, 37.9101, 38.0171, 37.8716, 37.9255, 37.9871, 37.9341,
               38.0834, 37.9063, 38.1074, 37.9619, 37.9747, 37.9735, 37.8591, 37.8733, 38.2235, 38.5788,
               38.2975, 38.5025, 38.5052, 38.4016, 38.0494, 38.2494, 38.1041, 38.2676),
  Longitude = c(-122.0312, -122.0670, -121.9999, -122.3108, -122.1180, -122.1334, -122.1297, -121.7125,
                -122.2989, -121.8847, -122.0608, -122.3478, -122.3426, -121.9780, -122.0652, -122.2886,
                -122.4649, -122.5275, -122.5897, -122.5352, -122.7633, -122.5457, -122.5697, -122.5554,
                -122.5614, -122.5311, -122.4853, -122.4567, -122.2264, -122.5790, -122.2869, -122.2654,
                -122.4707, -122.3614, -122.1586, -122.0399, -122.2566, -121.9399)
)

#join
mce <- full_join(full_mce, city_data, by = "community")

# map 
library(leaflet)
library(htmlwidgets)

# Create a Leaflet map
map <- leaflet(mce) %>%
  addTiles()  %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  setView(lng = -122.5, lat = 38.2, zoom = 9)  %>% # Adjust the center and zoom level as per your preference
  addCircleMarkers(
    lng = ~Longitude, lat = ~Latitude,
    label = ~community,
    color = "green", fillOpacity = 1,
    radius = 8
  )
map
# Display the map
saveRDS(map, file = "./06_Reports_Rmd/027_map_cities_in_MCE.rds")
