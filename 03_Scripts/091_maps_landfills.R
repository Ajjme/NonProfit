

source("./03_Scripts/000_init.R")

# by land fill how much waste sent by Juristiction
#where the waste goes 2022 year filter county stacked bar or map (size/piechart) of total waste at each landfill by juristiction
total_tonnage_jurisdiction <- read_xlsx("./02_inputs/Waste/Jurisdiction/JurisdictionDisposalAndBeneficial use.xlsx") %>% 
  clean_names() %>% 
  filter(county == "Contra Costa") %>% 
  group_by(jurisdiction) %>% 
  summarise(landfill = sum(landfill_includes_host_assigned_tons_due_to_missing_reports, na.rm = TRUE))







map_site_jurisdiction <- read_xlsx("./02_inputs/Waste/Jurisdiction/JurisdictionDisposalAndBeneficial use.xlsx") %>% 
  clean_names() %>% 
  filter(county == "Contra Costa") %>% 
  group_by(destination_facility) %>% 
  summarise(landfill = sum(landfill_includes_host_assigned_tons_due_to_missing_reports, na.rm = TRUE))

waste_site_locations_1 <- data.frame(
  destination_facility = c(
    "Acme Landfill (Acme Landfill - RD10130)",
    "Altamont Landfill & Resource Recovery Facility (Altamont Landfill & Resource Recovery Facility - RD10192)",
    "Avenal Landfill (Madera Disposal Systems, Inc. - RD10596)",
    "Azusa Land Reclamation, Inc. (Azusa Land Reclamation, Inc. - RD10038)",
    "CLOVER FLAT LANDFILL (CLOVER FLAT LANDFILL - RD12027)",
    "County of Yolo (Solid Waste Landfill - RD10125)",
    "Covanta Stanislaus, Inc (Covanta Staislaus, Inc - RD10268)",
    "Foothill Sanitary Landfill (Disposal facility - RD10600)",
    "Forward Landfill (Forward Landfill - RD11122)",
    "Guadalupe Recycling & Disposal Facility (Guadalupe Landfill - RD10198)",
    "International Disposal Corporation of Ca (Newby Island Sanitary Landfill - RD10973)",
    "John Smith Landfill (John Smith Landfill - RD10846)",
    "Keller Canyon Landfill (Keller Canyon Landfill - RD10351)",
    "Kirby Canyon Recycling & Disposal Facility (Kirby Canyon Recycling and Disposal Facility - RD10190)",
    "L and D Landfill Limited Partnership (L and D Landfill Limited Partnership - RD10738)",
    "Merced County Regional Waste Management Authority (Billy Wright Landfill - RD11090)",
    "Monterey Regional Waste Management District (Monterey Regional Waste Management District - RD11102)",
    "North County Recycling Center & Sanitary Landfill (landfill - RD10603)",
    "Ox Mountain Sanitary Landfill (Ox Mtn Sanitary Landfill - RD10976)",
    "Potrero Hills Landfill, Inc. (Potrero Hills Landifll, Inc - RD10775)",
    "Recology Hay Road  (Recology Hay Road - RD10319)",
    "Recology Ostrom Road (Recology Ostrom Road - RD10514)",
    "Redwood Landfill (Redwood Landfill, Inc - RD10187)",
    "Sacramento County Kiefer Landfill (Sacramento County Kiefer Landfill - RD10436)",
    "Simi Valley Landfill and Recycling Center (Simi Valley Landfill and Recycling Center - RD10046)",
    "Stanislaus County Fink Road Landfill (Stanislaus County Fink Road Landfill - RD10305)",
    "Vasco Road Landfill (Vasco Road Landfill - RD10316)",
    "Zanker Material Processing Facility (Solid Waste Landfill - RD11198)"
  ),
  Latitude = c(
    38.0200, 37.7147, 36.0049, 34.1283, 37.2869, 38.6798, 37.4910, 37.8585, 37.6370, 37.4197, 37.4361, 34.7335,
    37.9661, 37.4578, 37.8349, 37.2613, 36.7291, 37.7123, 37.3652, 38.0271, 38.2090, 38.4020, 37.9054, 38.4484,
    34.3155, 37.5775, 37.6923, 37.4623
  ),
  Longitude = c(
    -122.0852, -121.5503, -120.1419, -117.8963, -122.1583, -121.8978, -120.9397, -122.0479, -122.0441, -121.9924,
    -121.9544, -118.2682, -122.0619, -121.6338, -121.6193, -120.4884, -121.7610, -122.0503, -122.3214, -122.1971,
    -121.9481, -121.9525, -122.0829, -121.1809, -118.7233, -120.9758, -121.7502, -121.8752
  ),
County = c(
  "Contra Costa", "Alameda", "Kings", "Los Angeles", "Santa Clara", "Yolo", "Stanislaus", "Contra Costa",
  "Contra Costa", "Santa Clara", "Santa Clara", "Los Angeles", "Contra Costa", "Santa Clara", "Contra Costa",
  "Merced", "Monterey", "Contra Costa", "San Mateo", "Contra Costa", "Solano", "Yolo", "Contra Costa",
  "Sacramento", "Ventura", "Stanislaus", "Alameda", "Santa Clara"
)
)

waste_site_locations <- full_join(waste_site_locations_1, map_site_jurisdiction , by = "destination_facility")

contra_costa_sites <- waste_site_locations %>% filter(County == "Contra Costa")

Cities <- read_json("./05_Geo/stanford-vj593xs7263-geojson.json",  simplifyVector = FALSE)

icons <- awesomeIcons(
  icon = "flag",
  iconColor = 'black',
  library = 'ion',
  #markerColor = colors[match(EV_stations_ccc$ev_network, unique(EV_stations_ccc$ev_network))]
)
waste_map_icons <- leaflet(data = waste_site_locations) %>% 
  addTiles() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addGeoJSON(Cities, weight = 1, color = "#444444", fill = FALSE) %>%
  addAwesomeMarkers(
    lng = ~Longitude,
    lat = ~Latitude,
    popup = ~paste(as.character( SiteName), "<br>",  SiteName),
    icon = icons,
    label = ~as.character(SiteName)
    
  )
waste_map_icons

#sized
waste_map <- leaflet(data = waste_site_locations) %>% 
  addTiles() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addGeoJSON(Cities, weight = 1, color = "#444444", fill = FALSE) %>%
  addCircles(
  lng = waste_site_locations$Longitude,  # Longitude of the circles
  lat = waste_site_locations$Latitude,  # Latitude of the circles
  radius = (waste_site_locations$landfill/20),  # Size of the circles
  color = "green",  # Border color of the circles
  fillColor = "brown",  # Fill color of the circles
  fillOpacity = 0.5  # Opacity of the circles
)

#waste_map
#saveWidget(map_of_EV_small_ccc, file="./06_Reports_Rmd/map_of_EV_small_full_ccc.html")
saveRDS(waste_map, file = "./06_Reports_Rmd/091_waste_map.rds")

waste_site_locations_ccc <- waste_site_locations %>% 
  filter(County == "Contra Costa")


waste_map_ccc <- leaflet(data = waste_site_locations_ccc) %>% 
  addTiles() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addGeoJSON(Cities, weight = 1, color = "#444444", fill = FALSE) %>%
  addAwesomeMarkers(
    lng = ~Longitude,
    lat = ~Latitude,
    popup = ~paste(as.character(destination_facility), "<br>",  destination_facility),
    icon = icons,
    label = ~as.character(destination_facility)
    
  )

#waste_map_ccc
saveRDS(waste_map_ccc, file = "./06_Reports_Rmd/091_waste_map_ccc.rds")

