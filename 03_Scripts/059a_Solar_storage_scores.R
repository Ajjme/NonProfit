
solar_city_standardized <- readRDS(file = "./06_Reports_Rmd/solar_city_standardized.rds")

storage_city_standardized <- readRDS(file = "./06_Reports_Rmd/storage_city_standardized.rds")


scores_solar<- full_join(solar_city_standardized, storage_city_standardized, by = "city")

plotly_obj_scores_solar <- scores_solar %>% 
  plot_ly(x = ~city, type = "bar", y = ~storage_per_pop_scaled, name = "Storage Score", 
          marker = list(color = "yellowgreen",line = list(color = "black", width = 1))) %>% 
  add_trace(y = ~solar_per_pop_scaled, name = "Solar Score", 
            marker = list(color = "rgb(255, 255, 128)",line = list(color = "black", width = 1))) %>% 

  layout(title = "",
         xaxis = list(title = "City", tickangle = 45, categoryorder = "total descending"),
         yaxis = list(title = "Score"),
         barmode = "stack",
         legend = list(x = 0.5, y = -0.2, orientation = "h", traceorder = "normal", font = list(size = 12),
                       xanchor = "center", yanchor = "top", itemwidth = 10, itemsizing = "constant"))

# Display interactive graph
plotly_obj_scores_solar

saveRDS(plotly_obj_scores_solar, file = "./06_Reports_Rmd/59a_plotly_obj_scores_solar.rds")

