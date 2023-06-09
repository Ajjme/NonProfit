#Zip to City map

#https://simplemaps.com/data/us-zips. source

source("./03_Scripts/000_init.R")

zip_code_map <- read.csv("./02_inputs/uszips.csv") %>% 
  filter(state_name == "California")

ccc_zip_code_map <- zip_code_map %>% 
  filter(str_detect(county_name, "Contra Costa"))

saveRDS(ccc_zip_code_map, file = "./04_Outputs/rds/ccc_zip_code_map.rds")


county_zip_code_map <- zip_code_map %>% 
  select(zip, "lat"  ,       county_weights,     "lng", "county_fips",      "county_name",  "county_names_all", "population")
saveRDS(county_zip_code_map, file = "./04_Outputs/rds/county_zip_code_map.rds")
