###heating
#occupany
#Renters
#value

#https://www.census.gov/acs/www/about/why-we-ask-each-question/heating/
 
  #Just going to download by hand


source("./03_Scripts/000_init.R")
### Inputs------------------
  
  # https://data.census.gov/table?g=040XX00US06_160XX00US0668378&tid=ACSDP5Y2021.DP04&moe=false
#https://data.census.gov/table?g=040XX00US06,06$8600000_160XX00US0668378&tid=ACSDP5Y2021.DP04&moe=false

home_characteristics_data <- read.csv("./02_inputs/ACSDP5Y2021_Housing_zip_code.csv", skip = 1) %>% 
  clean_names()%>% 
  select(geographic_area_name, contains("heating_fuel"), contains("structure_built"), contains("housing_occupancy_total"), 
  contains("value_owner_occupied_units"), contains("vehicles_available") , contains("rooms_total"), 
  contains("cooking"), -contains("annotation")) %>% 
  slice(-1:-2)%>%
  mutate(geographic_area_name = str_remove(geographic_area_name, "^[^ ]+ ")) %>% 
  mutate(geographic_area_name = as.integer(geographic_area_name))


ccc_zip_simple_map <- readRDS(file = "./04_Outputs/rds/ccc_zip_code_map.rds") %>% 
  select("zip"       ,       "lat",              "lng"     ,         "city", "population") %>% 
  mutate(zip = as.integer(zip))


home_characteristics <- left_join( ccc_zip_simple_map, home_characteristics_data , by = c("zip" = "geographic_area_name"))


saveRDS(home_characteristics, file = "./04_Outputs/rds/home_characteristics.rds")





