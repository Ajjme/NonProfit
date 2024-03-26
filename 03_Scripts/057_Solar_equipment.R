simple_PGE_solar_data <- readRDS(file = "./04_Outputs/rds/simple_PGE_solar_data.rds")


### equipment ----------------------
equipment <- simple_PGE_solar_data %>% 
  select(app_approved_date, service_city, service_zip, service_county, technology_type,
         inverter_manufacturer_1, generator_manufacturer_1,
         generator_model_1, inverter_model_1, interconnection_program, contains_2022) %>% 
  filter(service_county == "CONTRA COSTA") %>% 
  filter(contains_2023 == TRUE) 


top_manufacturers <- equipment %>%
  group_by(service_city, generator_manufacturer_1) %>%
  summarise(count = n()) %>%
  ungroup() %>%
  arrange(desc(count)) %>%
  group_by(service_city) %>%
  slice(1)
#install.packages("DT")

library(DT)
# Display the top generator manufacturer for each service city
datatable(top_manufacturers, 
          options = list(pageLength = 10, lengthMenu = c(10, 20, 50))) 
