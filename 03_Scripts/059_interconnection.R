simple_PGE_solar_data <-readRDS(file = "./06_Reports_Rmd/city_solar_data_standardized.rds")

#clean_solar_data <- readRDS(file = "./06_Reports_Rmd/city_solar_data_standardized.rds")


### interconnection ----------------------
interconnection <- simple_PGE_solar_data %>% 
  select(app_approved_date, city, service_zip, service_county, technology_type,
         interconnection_program) %>% 
  filter(service_county == "CONTRA COSTA") 
# Create a bar chart of the count of interconnection_program and service_city
p <- ggplot(interconnection, aes(x = city, fill = interconnection_program, text = paste("Interconnection Program: ", interconnection_program))) +
  geom_bar() + #color = "black"
  labs(title = "Count of Interconnection Programs by Service City",
       x = "Service City",
       y = "Number of Installs",
       fill = "Interconnection Program") +
  theme(panel.background = element_rect(fill = "white"))+
  guides(fill = "none")
p <- ggplotly(p, tooltip = "text", hoverinfo = "text")
# Convert the ggplot object to a plotly object and add interactive features
plot_int_con <- ggplotly(p) %>%
  layout(legend = list(orientation = "v", x = 1.025, y = 0.5),
         xaxis = list(tickangle = 45, tickfont = list(size = 12))) %>%
  config(displayModeBar = TRUE)


saveRDS(plot_int_con, file = "./06_Reports_Rmd/plot_int_con.rds")
