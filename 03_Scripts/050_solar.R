
source("./03_Scripts/000_init.R")
### Inputs------------------
#may have to change downloaded name
PGE_solar_data <- read_csv("./02_inputs/PGE_Interconnected_Project_Sites_2023-12-31.csv") %>% 
  clean_names()

solar_data <- PGE_solar_data %>% 
  filter(service_county == "CONTRA COSTA")%>% 
  filter(year(app_approved_date) == 2023) %>% 
  rename(city = service_city) %>% 
  mutate(city = str_to_lower(city)) 

city_solar_data_clean <- clean_city_names_uni_ccc(solar_data) 

### Standardize by population -----------------
# input number of cars-------------------
population <- readRDS(file = "./04_Outputs/rds/full_ccc_census.rds") %>% 
  clean_names() %>% 
  select(city, total_pop) %>% 
  mutate(city = if_else(city == "Uni_CCC", "Uni. CCC", city)) 

city_solar_data_standardized <- full_join(population, city_solar_data_clean, by = "city") 

saveRDS(city_solar_data_standardized, file = "./06_Reports_Rmd/city_solar_data_standardized.rds")
