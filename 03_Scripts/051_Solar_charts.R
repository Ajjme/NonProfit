#Solar
simple_PGE_solar_data <- readRDS(file = "./04_Outputs/rds/simple_PGE_solar_data.rds")

### Solar -----------------
solar_ac <- simple_PGE_solar_data %>% 
  select(app_approved_date, service_city, service_zip, service_county, system_size_ac) %>% 
  filter(service_county == "CONTRA COSTA") %>% 
  filter(contains_2022 == TRUE)

# ranking of total install in 2022 by city
# Group by city and sum the system size by city
city_totals_solar <- solar_ac %>%
  group_by(service_city) %>%
  summarise(total_size = sum(system_size_ac))

# Create plotly plot
plot_solar <- plot_ly(city_totals_solar, x = ~service_city, y = ~total_size, type = "bar")

# Set plot title and axis labels
plot_solar <- plot_solar %>% layout(title = "Total System Size by City",
                                    xaxis = list(title = "City"),
                                    yaxis = list(title = "Total System Size (AC) kW"))

# Show plot
plot_solar
## Calendar Heat map-------------

solar_ac_all_years <- simple_PGE_solar_data %>% 
  select(app_approved_date, service_city, service_zip, service_county, system_size_ac) %>% 
  filter(service_county == "CONTRA COSTA") 
# Group the data by year and month and calculate the total system size for each month
monthly_totals <- solar_ac_all_years %>%
  group_by(year = year(app_approved_date), month = month(app_approved_date)) %>%
  summarise(total_size = sum(system_size_ac))

# Create plotly plot
heat_map_plot <- plot_ly(monthly_totals, x = ~month, y = ~year, z = ~total_size, type = "heatmap")

# Set plot title and axis labels
heat_map_plot <- heat_map_plot %>% layout(title = "Total System Size by Time of Year",
                                          xaxis = list(title = "Month"),
                                          yaxis = list(title = "Year"))
# Show plot
heat_map_plot
# there doesn't appear to be any time of year pattern
