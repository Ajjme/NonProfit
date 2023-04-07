
source("../03_Scripts/000_init.R")
### inputs--------
vehicle_type <- c("Gas", "Electric")
fires_per_100k_sales <- c(1529.9, 25.1)
df <- data.frame(vehicle_type, fires_per_100k_sales)
### Source
#Dept transportation crash data

### Plot-----------------
fig_car_fire <- plot_ly(df, x = ~vehicle_type, y = ~fires_per_100k_sales, type = 'bar', name = 'Fires per 100k Sales',
               marker = list(color = c('darkred', 'green')),
               text = paste(df$fires_per_100k_sales, 'fires per 100k sales'),
               hoverinfo = "text")

fig_car_fire <- fig_car_fire %>% layout(title = "Vehicle Fires per 100k Sales",
                      xaxis = list(title = "Vehicle Type"),
                      yaxis = list(title = "Fires per 100k Sales"))

fig_car_fire


### Output--------------------
saveWidget(fig_car_fire, file = "./06_Reports_Rmd/vehicle_fires.html")
saveRDS(fig_car_fire, file = "./06_Reports_Rmd/fig_car_fire.rds")
