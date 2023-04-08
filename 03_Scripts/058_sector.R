simple_PGE_solar_data <- readRDS(file = "./04_Outputs/rds/simple_PGE_solar_data.rds")


### sector ----------------------

## Storage ----------------------------------------
sector_storage <- simple_PGE_solar_data %>% 
  select(app_approved_date, service_city, service_zip, service_county, technology_type,
          customer_sector, contains_2022) %>% 
  filter(service_county == "CONTRA COSTA") %>% 
  filter(contains_2022 == TRUE,
         technology_type == "Storage") 

# Create a bar chart using ggplot2
### Data incomplete
ggplot(sector_storage, aes(x = service_city, fill = customer_sector)) + 
  geom_bar() + 
  labs(title = "Entries by Customer Sector in Each Service City", 
       x = "Service City", 
       y = "Count") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Convert the ggplot2 chart to an interactive plotly chart
ggplotly()
### Solar------------------------
sector_solar <- simple_PGE_solar_data %>% 
  select(app_approved_date, service_city, service_zip, service_county, technology_type,
         customer_sector, contains_2022) %>% 
  filter(service_county == "CONTRA COSTA") %>% 
  filter(contains_2022 == TRUE,
         technology_type == "Solar PV") 

ggplot(sector_solar, aes(x = service_city, fill = customer_sector)) + 
  geom_bar() + 
  labs(title = "Entries by Customer Sector in Each Service City", 
       x = "Service City", 
       y = "Count") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Convert the ggplot2 chart to an interactive plotly chart
ggplotly()


### pulling out Res
sector_solar_non_res <- simple_PGE_solar_data %>% 
  select(app_approved_date, service_city, service_zip, service_county, technology_type,
         customer_sector, contains_2022) %>% 
  filter(service_county == "CONTRA COSTA") %>% 
  filter(contains_2022 == TRUE,
         technology_type == "Solar PV",
         customer_sector != "Residential") 



ggplot(sector_solar_non_res, aes(x = service_city, fill = customer_sector)) + 
  geom_bar() + 
  labs(title = "Entries by Customer Sector in Each Service City", 
       x = "Service City", 
       y = "Count") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Convert the ggplot2 chart to an interactive plotly chart
ggplotly()

### County Wide Bubble chart-------------