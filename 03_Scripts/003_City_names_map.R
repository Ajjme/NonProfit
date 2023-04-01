

source("./03_Scripts/000_init.R")


names_and_code <- readRDS(file = "./04_Outputs/rds/acs_general_pct_ca_city.rds") %>% 
  select(place, place_FIPS, placename, county) %>% 
  rename(city = placename )

contra_costa_census <- names_and_code %>% 
  filter(county == "Contra Costa County")

urlmap <- "https://raw.githubusercontent.com/kjhealy/fips-codes/master/state_and_county_fips_master.csv"
county_fips_map <- read.csv(urlmap)