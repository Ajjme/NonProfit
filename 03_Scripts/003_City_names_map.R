source("./03_Scripts/000_init.R")

### Inputs-------------------
names_and_code <- readRDS(file = "./04_Outputs/rds/acs_general_pct_ca_city.rds") %>% 
  select(place, place_FIPS, placename, county, contains("vehicle"), contains("public"), "carpool"  ,
         "drove_alone", "walked_to_work", total_pop) %>% 
  rename(city = placename )

### CCC filter and cleaning--------------------
contra_costa_census <- names_and_code %>% 
  filter(county == "Contra Costa County") %>% 
  mutate(is_CDP = str_detect(city, "CDP$")) %>%
  filter(!is_CDP)
  
Uni_contra_costa_census <- names_and_code %>% 
  filter(county == "Contra Costa County") %>%
  mutate(is_CDP = str_detect(city, "CDP$")) %>%
  filter(is_CDP) %>%
  select(-place, -place_FIPS) %>% 
  mutate(across(-c(city, county, is_CDP), as.numeric)) %>% 
  summarise(across(where(is.numeric), sum))%>%
  mutate(city = "Uni_CCC")

full_ccc_census <- bind_rows(contra_costa_census, Uni_contra_costa_census)%>%
  mutate(city = str_remove_all(city, "(?i)\\b(city|town)\\b")) %>%
  mutate(city = str_trim(city))

saveRDS(full_ccc_census, file = "./04_Outputs/rds/full_ccc_census.rds")

Official_City_Names <- full_ccc_census %>% 
  select(city)
saveRDS(Official_City_Names, file = "./04_Outputs/rds/Official_City_Names.rds")



urlmap <- "https://raw.githubusercontent.com/kjhealy/fips-codes/master/state_and_county_fips_master.csv"
county_fips_map <- read.csv(urlmap)