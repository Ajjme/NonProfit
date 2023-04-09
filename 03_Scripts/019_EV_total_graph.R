#https://cleancities.energy.gov/accomplishments/
 # Build a shiny app like this on with tabs
  
  buses_ccc <- readRDS( file = "./06_Reports_Rmd/buses_ccc.rds")
  ZEV_sales_city_standardized_elect <- readRDS( file = "./06_Reports_Rmd/ZEV_sales_city_standardized_elect.rds")
  EV_stations_standardized <- readRDS( file = "./06_Reports_Rmd/EV_stations_standardized.rds")
  
  joined <- full_join(buses_ccc, ZEV_sales_city_standardized_elect, by = "city")
  all_joined <- full_join(joined, EV_stations_standardized, by = "city")
  
  ### Making scores -----------
  scores_ev <- all_joined %>% 
    select(city, number_of_buses, ev_per_total_vehicle_scaled, chargers_per_total_vehicle_scaled) %>% 
    mutate(bus_scaled = number_of_buses*25) %>% 
    select(-number_of_buses)
  ### Stacked bar graph-----------------
  
  plotly_obj_scores_ev <- scores_ev %>% 
    plot_ly(x = ~city, type = "bar", y = ~chargers_per_total_vehicle_scaled, name = "Chargers per Vehicle Score", 
            marker = list(line = list(color = "black", width = 1))) %>% 
    add_trace(y = ~ev_per_total_vehicle_scaled, name = "EVs per Vehicle Score", 
              marker = list(line = list(color = "black", width = 1))) %>% 
    add_trace(y = ~bus_scaled, name = "Electric of Buses, Bonus", 
              marker = list(line = list(color = "black", width = 1))) %>% 
    layout(title = "EV Scores by City in Contra Costa County",
           xaxis = list(title = "City", tickangle = 45),
           yaxis = list(title = "Score"),
           barmode = "stack",
           legend = list(x = 0.5, y = -0.2, orientation = "h", traceorder = "normal", font = list(size = 12),
                         xanchor = "center", yanchor = "top", itemwidth = 10, itemsizing = "constant"))
  
  # Display interactive graph
  plotly_obj_scores_ev
  
  
  saveRDS(plotly_obj_scores_ev, file = "./06_Reports_Rmd/plotly_obj_scores_ev.rds")
  