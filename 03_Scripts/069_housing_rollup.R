
heating_fuel_score <- readRDS( file = "./06_Reports_Rmd/heating_fuel_score.rds")
electrification_data <- readRDS( file = "./04_Outputs/rds/electrification_data.rds")

electrification_data_shx <- readRDS(file = "./04_Outputs/rds/electrification_data_shx.rds")

scores_housing <- full_join(heating_fuel_score, electrification_data_shx, by = "city")

plotly_obj_scores_housing <- scores_housing %>% 
  plot_ly(x = ~city, type = "bar", y = ~Electrification_Score, name = "Electrification Ordiance Score", 
          marker = list(color = "yellow",line = list(color = "black", width = 1))) %>% 
  add_trace(y = ~fuel_percent_scaled, name = "Heating Fuel Score", 
            marker = list(color = "orange",line = list(color = "black", width = 1))) %>% 
  #removed for now
  # add_trace(y = ~bus_scaled, name = "Electric of Buses, Bonus", 
  #           marker = list(line = list(color = "black", width = 1))) %>% 
  layout(title = "Scores by City in Contra Costa County",
         xaxis = list(title = "City", tickangle = 45, categoryorder = "total descending"),
         yaxis = list(title = "Score"),
         barmode = "stack",
         legend = list(x = 0.5, y = -0.2, orientation = "h", traceorder = "normal", font = list(size = 12),
                       xanchor = "center", yanchor = "top", itemwidth = 10, itemsizing = "constant"))

# Display interactive graph
plotly_obj_scores_housing

saveRDS(plotly_obj_scores_housing, file = "./06_Reports_Rmd/plotly_obj_scores_housing.rds")


