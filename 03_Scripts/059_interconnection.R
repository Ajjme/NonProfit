simple_PGE_solar_data <- readRDS(file = "./04_Outputs/rds/simple_PGE_solar_data.rds")


### interconnection ----------------------
interconnection <- simple_PGE_solar_data %>% 
  select(app_approved_date, service_city, service_zip, service_county, technology_type,
         interconnection_program, contains_2022) %>% 
  filter(service_county == "CONTRA COSTA") %>% 
  filter(contains_2022 == TRUE) 
# Create a bar chart of the count of interconnection_program and service_city
p <- ggplot(interconnection, aes(x = service_city, fill = interconnection_program)) +
  geom_bar() +
  labs(title = "Count of Interconnection Programs by Service City",
       x = "Service City",
       y = "Count",
       fill = "Interconnection Program")

# Convert the ggplot object to a plotly object and add interactive features
ggplotly(p) %>%
  layout(legend = list(orientation = "v", x = 1, y = 0.5),
         xaxis = list(tickangle = 45, tickfont = list(size = 12))) %>%
  config(displayModeBar = TRUE)
