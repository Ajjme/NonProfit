
clean_solar_data <- readRDS(file = "./06_Reports_Rmd/city_solar_data_standardized.rds")

### Costs--------------------------------------------------------
cost_system <- clean_solar_data %>% 
  select(app_approved_date, city, service_zip, service_county, total_system_cost) %>% 
  filter(total_system_cost != 0)

# Create a boxplot of total system cost by service city using plotly, removing outliers
plot_cost <- plot_ly(cost_system, x = ~city, y = ~total_system_cost, type = "box",
                boxpoints = "outliers", jitter = 0.3, pointpos = -1.8)

# Set plot title and axis labels
plot_cost <- plot_cost %>% layout(title = "Total System Cost by Service City",
                        xaxis = list(title = "Service City"),
                        yaxis = list(title = "Total System Cost ($)", range = c(0, 100000)))

# Show 
plot_cost

saveRDS(plot_cost, file = "./06_Reports_Rmd/plot_cost.rds")
