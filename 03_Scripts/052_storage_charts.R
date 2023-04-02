#INputs-------------

simple_PGE_solar_data <- readRDS(file = "./04_Outputs/rds/simple_PGE_solar_data.rds")


### Storage ----------------------
storage_ac <- simple_PGE_solar_data %>% 
  select(app_approved_date, service_city, service_zip, service_county,
         storage_capacity_k_wh, storage_size_k_w_ac) %>% 
  filter(service_county == "CONTRA COSTA")

# ranking of total install in 2022 by city
# Group by city and sum the system size by city
city_totals_storage <- storage_ac %>%
  group_by(service_city) %>%
  summarise(total_size = sum(storage_size_k_w_ac))

# Create plotly plot
plot_storage <- plot_ly(city_totals_storage, x = ~service_city, y = ~total_size, type = "bar")

# Set plot title and axis labels
plot_storage <- plot_storage %>% layout(title = "Total Storage Size by City",
                                        xaxis = list(title = "City"),
                                        yaxis = list(title = "Total Storage Size (AC) kW"))

# Show plot
plot_storage