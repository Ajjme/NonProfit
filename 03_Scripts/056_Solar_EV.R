simple_PGE_solar_data <- readRDS(file = "./04_Outputs/rds/simple_PGE_solar_data.rds")


### EV ----------------------
solar_ev <- simple_PGE_solar_data %>% 
  select(app_approved_date, service_city, service_zip, service_county,
         electric_vehicle, contains_2022) %>% 
  filter(service_county == "CONTRA COSTA") %>% 
  filter(contains_2022 == TRUE) 

ggplot(solar_ev, aes(x = service_city, fill = electric_vehicle)) + 
  geom_bar() + 
  labs(title = "Electric Vehicle by Service City", 
       x = "Service City", 
       y = "Count of Solar/Storage Installations in 2022") +
  theme_bw()+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Convert the ggplot2 chart to an interactive plotly chart
ggplotly()