simple_PGE_solar_data <- readRDS(file = "./04_Outputs/rds/simple_PGE_solar_data.rds")


### 3rd party ----------------------
three_rd_party <- simple_PGE_solar_data %>% 
  select(app_approved_date, service_city, service_zip, service_county,
         third_party_owned, third_party_name, total_system_cost, contains_2022) %>% 
  filter(service_county == "CONTRA COSTA",
         third_party_owned == "Yes") %>% 
  filter(contains_2022 == TRUE) 
  

# Count the total system cost by third party name and service city
third_party_costs <- three_rd_party %>%
  group_by(service_city, third_party_name) %>%
  summarize(total_cost = sum(total_system_cost)) %>%
  ungroup()

# Keep only the top five third party names based on total system cost in each service city
top_third_parties <- third_party_costs %>%
  group_by(service_city) %>%
  top_n(5, total_cost) %>% 
  filter(total_cost != 0)

# Create an interactive bar chart of total system cost by third party name and service city
plot <- plot_ly(top_third_parties, x = ~service_city, y = ~total_cost, color = ~third_party_name, type = "bar")

# Set plot title and axis labels
plot <- plot %>% layout(title = "Total System Cost by Third Party and Service City 2022",
                        xaxis = list(title = "Third Party Name"),
                        yaxis = list(title = "Total System Cost ($)"))

# Add dropdown menu to filter by service city

# Show plot
plot
