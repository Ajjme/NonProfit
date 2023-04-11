#simple_PGE_solar_data <- readRDS(file = "./04_Outputs/rds/simple_PGE_solar_data.rds")
simple_PGE_solar_data <- readRDS(file = "./06_Reports_Rmd/city_solar_data_standardized.rds")

### EV ----------------------
solar_ev <- simple_PGE_solar_data %>% 
  select(app_approved_date, city, service_zip, service_county,
         electric_vehicle)

plot_ev_solar <- ggplot(solar_ev, aes(x = city, fill = electric_vehicle, text = paste("<br>Electric Vehicle: ", electric_vehicle))) + 
  geom_bar() + 
  labs(title = "Electric Vehicle by Service City", 
       x = "Service City", 
       y = "Count of Solar/Storage Installations in 2022") +
  theme(axis.title.x = element_text(hjust = 1),
        axis.title.y = element_text(hjust = 1),
        panel.grid.major.y = element_line(color = "gray"),
        panel.background = element_rect(fill = "white"),
        axis.text.x = element_text(angle = 45, hjust = 0.5))+
  guides(fill = "none")

plot_ev_solar <- ggplotly(plot_ev_solar, tooltip = "text", hoverinfo = "text")
# Convert the ggplot2 chart to an interactive plotly chart
plot_ev_solar


saveRDS(plot_ev_solar, file = "./06_Reports_Rmd/plot_ev_solar.rds")
