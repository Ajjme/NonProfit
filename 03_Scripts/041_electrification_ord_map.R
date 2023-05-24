electrification_data <- readRDS(file = "./04_Outputs/rds/electrification_data.rds")

library(sf)
library(ggplot2)
library(ggmap)

# Load the shapefile of California cities
electrification_data_shx <- st_read("./02_inputs/BND_LAFCO_City_SOI.shx")


electrification_data_shx$city <- c("Antioch", "Brentwood", "Clayton", "Concord", "Danville", "El Cerrito", 
                      "Hercules", "Lafayette", "Martinez", "Moraga", "Oakley", "Orinda", "Pinole",
                      "Pittsburg", "Pleasant Hill", "Richmond", "San Pablo", "San Ramon", "Walnut Creek")

electrification_data_shx$Electrification_Score <- c("0", "0", "0", "0", "0", "25", 
                                   "100", "25", "25", "0", "0", "0", "0",
                                   "0", "0", "100", "0", "0", "0")

# Plot the map
p <- ggplot(electrification_data_shx) +
  geom_sf(aes(fill = Electrification_Score, text = city)) +
  scale_fill_manual(values = c("100" = "green", "25" = "yellow", "0" = "white")) +
  theme_void()


saveRDS(p, file = "./06_Reports_Rmd/elect_ord_map.rds")

ord_map <- ggplotly(p)



cities <- c("Antioch", "Brentwood", "Clayton", "Concord", "Danville", "El Cerrito", 
            "Hercules", "Lafayette", "Martinez", "Moraga", "Oakley", "Orinda", "Pinole",
            "Pittsburg", "Pleasant Hill", "Richmond", "San Pablo", "San Ramon", "Walnut Creek")
