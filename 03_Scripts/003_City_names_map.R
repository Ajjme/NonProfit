

source("./03_Scripts/000_init.R")


names_and_code <- readRDS(file = "./04_Outputs/rds/acs_general_pct_ca_city.rds") %>% 
  select(place, place_FIPS, V4, V7) %>% 
   rename(county = V7,
          city = V4)

contra_costa_census <- names_and_code %>% 
  filter(county == "Contra Costa County")
