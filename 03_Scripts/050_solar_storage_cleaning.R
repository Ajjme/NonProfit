
source("./03_Scripts/000_init.R")
### Inputs------------------
#may have to change downloaded name

PGE_solar_data <- read_csv("./02_inputs/PGE_Interconnected_Project_Sites_2023-12-31.csv") %>% 
  clean_names()
### I still think we can look at generators and inverters as well as Tariff info and interconnection program
### maybe even interconnection vs app time
### pace financing could be cool too


### NEMPV I think is net metering
simple_PGE_solar_data <- PGE_solar_data %>% 
  select(app_approved_date, service_city, service_zip, service_county, system_size_ac, 
         storage_capacity_k_wh, storage_size_k_w_ac, total_system_cost, electric_vehicle, installer_name, 
         third_party_owned, third_party_name,technology_type, inverter_manufacturer_1, generator_manufacturer_1,
         generator_model_1, inverter_model_1, interconnection_program, customer_sector) %>% 
  mutate(contains_2023 = str_detect(app_approved_date, "2023")) %>% 
  #filter(contains_2022 == TRUE)  %>%
  mutate(app_approved_date = ymd(app_approved_date),
         service_city = str_to_title(service_city))
### need to add a column with number of homes or some other standardizing metric
#need to clean County city names

### Standardize ---------------------


#we need to clean the service city names
saveRDS(simple_PGE_solar_data, file = "./04_Outputs/rds/simple_PGE_solar_data.rds")
