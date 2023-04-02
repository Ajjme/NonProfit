
simple_PGE_solar_data <- readRDS(file = "./04_Outputs/rds/simple_PGE_solar_data.rds")

### Costs--------------------------------------------------------
cost_system <- simple_PGE_solar_data %>% 
  select(app_approved_date, service_city, service_zip, service_county, total_system_cost) %>% 
  filter(service_county == "CONTRA COSTA")

# Create a boxplot of total system cost by service city using plotly, removing outliers
plot <- plot_ly(cost_system, x = ~service_city, y = ~total_system_cost, type = "box",
                boxpoints = "outliers", jitter = 0.3, pointpos = -1.8)

# Set plot title and axis labels
plot <- plot %>% layout(title = "Total System Cost by Service City",
                        xaxis = list(title = "Service City"),
                        yaxis = list(title = "Total System Cost ($)", range = c(0, 100000)))

# Show 
plot
