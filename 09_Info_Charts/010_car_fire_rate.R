
source("../03_Scripts/000_init.R")

vehicle_type <- c("Gas", "Electric")
fires_per_100k_sales <- c(1529.9, 25.1)
df <- data.frame(vehicle_type, fires_per_100k_sales)

fig_car_fire <- plot_ly(df, x = ~vehicle_type, y = ~fires_per_100k_sales, type = 'bar', name = 'Fires per 100k Sales',
               marker = list(color = c('darkred', 'green')),
               text = paste(df$fires_per_100k_sales, 'fires per 100k sales'),
               hoverinfo = "text")

fig_car_fire <- fig %>% layout(title = "Vehicle Fires per 100k Sales",
                      xaxis = list(title = "Vehicle Type"),
                      yaxis = list(title = "Fires per 100k Sales"))

fig_car_fire
saveWidget(fig_car_fire, file = "vehicle_fires.html")
