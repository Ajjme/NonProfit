heating_fuel_percent_two <- readRDS(file = "./04_Outputs/rds/heating_fuel_percent_two.rds")
#comes from 061

max_value <- max(heating_fuel_percent_two$fuel_percent)
heating_fuel_score <- heating_fuel_percent_two %>%  
  mutate(#fuel_percent = fuel_percent*100,
         fuel_percent_scaled = 100 * fuel_percent/max_value)

saveRDS(heating_fuel_score, file = "./06_Reports_Rmd/heating_fuel_score.rds")


plot_ly(heating_fuel_score, x = ~city, y = ~fuel_percent_scaled, name = "Heating Fuel Score", type = "bar", showlegend = FALSE, marker = list(line = list(color = "black", width = 1))) %>%
  add_trace(y = ~fuel_percent, name = "Percent Clean Heating", type = "bar", visible = FALSE) %>%
   layout( 
    updatemenus = list(
      list(
        type = "buttons",
        direction = "down",
        showactive = TRUE,
        buttons = list(
          list(method = "update",
               args = list(list(visible = c(TRUE, FALSE))),
               label = "Scores"
               ),
          list(method = "update",
               args = list(list(visible = c(FALSE, TRUE))),
               label = "Percent Clean Heating"
               )
        ),
        pad = list(r = 15, t = 0, b = 0, l = 0)
      )
    ),
    xaxis = list(title = "City", tickfont = list(size = 14), tickangle = 45),
    yaxis = list(title = "Heating Fuel Score", tickfont = list(size = 14)),
    margin = list(l = 60, r = 20, t = 40, b = 40),
    font = list(family = "Arial", size = 14)
  )



