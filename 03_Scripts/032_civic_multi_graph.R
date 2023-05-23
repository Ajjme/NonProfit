
civic_data <- readRDS( file = "./04_Outputs/rds/civic_data.rds")
saveRDS(civic_data, file = "./06_Reports_Rmd/civic_data.rds")
# Score and then the number they have had and the number they have now 3 layers
plot_ly(civic_data, x = ~city, y = ~civic_score, name = "Scores", type = "bar", showlegend = FALSE, marker = list(color = "grey", line = list(color = "black", width = 1))) %>%
  add_trace(y = ~this_year, name = "Civic Spark Fellow this Year", type = "bar", visible = FALSE) %>%
  add_trace(y = ~total_number, name = "Total Civic Spark Fellows", type = "bar", visible = FALSE) %>%
  layout( 
    updatemenus = list(
      list(
        type = "buttons",
        direction = "down",
        showactive = TRUE,
        buttons = list(
          list(method = "update",
               args = list(list(visible = c(TRUE, FALSE, FALSE))),
               label = "Scores"),
          list(method = "update",
               args = list(list(visible = c(FALSE, TRUE, FALSE))),
               label = "Civic Spark Fellow this Year"
          ),
          list(method = "update",
               args = list(list(visible = c(FALSE,  FALSE, TRUE))),
               label = "Total Civic Spark Fellows"
          )
        ),
        pad = list(r = 15, t = 0, b = 0, l = 0)
      )
    ),
    xaxis = list(title = "City", tickfont = list(size = 14), tickangle = 45),
    yaxis = list(title = "", tickfont = list(size = 14)),
    margin = list(l = 60, r = 20, t = 40, b = 40),
    font = list(family = "Arial", size = 14)
  )