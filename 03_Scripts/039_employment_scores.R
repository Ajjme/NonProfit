cac_data <- readRDS(file = "./06_Reports_Rmd/cac_data.rds")
civic_data <- readRDS( file = "./04_Outputs/rds/civic_data.rds")

all_joined <- full_join(cac_data, civic_data, by = "city")

### Making scores -----------
scores_employ <- all_joined %>% 
  mutate(total = (x23_24_full_term_points + civic_score)) %>% 
  arrange(total)

saveRDS(scores_employ, file = "./06_Reports_Rmd/scores_employ.rds")
### Stacked bar graph-----------------

plotly_obj_scores_employ <- scores_employ %>% 
  plot_ly(x = ~city, type = "bar", y = ~x23_24_full_term_points, name = "Climate Action Fellow Score", 
          marker = list(color = "green",line = list(color = "black", width = 1))) %>% 
  add_trace(y = ~civic_score, name = "Civic Spark Score", 
            marker = list(color = "grey",line = list(color = "black", width = 1))) %>% 
  #removed for now
  # add_trace(y = ~bus_scaled, name = "Electric of Buses, Bonus", 
  #           marker = list(line = list(color = "black", width = 1))) %>% 
  layout(title = "Sustainability Employment Scores by City in Contra Costa County",
         xaxis = list(title = "City", tickangle = 45, categoryorder = "total descending"),
         yaxis = list(title = "Score"),
         barmode = "stack",
         legend = list(x = 0.5, y = -0.2, orientation = "h", traceorder = "normal", font = list(size = 12),
                       xanchor = "center", yanchor = "top", itemwidth = 10, itemsizing = "constant"))

# Display interactive graph
plotly_obj_scores_employ


saveRDS(plotly_obj_scores_employ, file = "./06_Reports_Rmd/plotly_obj_scores_employ.rds")

