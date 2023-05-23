elect_place_long <- readRDS(file = "./04_Outputs/rds/employment_place_data.rds")


plot_ly(elect_place_long, x = ~city, y = ~stand_electr, name = "Electricians by Population", type = "bar", showlegend = FALSE, marker = list(color = "darkgreen", line = list(color = "black", width = 1))) %>%
  add_trace(y = ~value, name = "Total Electricians", type = "bar", visible = FALSE) %>%
 
  layout( 
    updatemenus = list(
      list(
        type = "buttons",
        direction = "down",
        showactive = TRUE,
        buttons = list(
          list(method = "update",
               args = list(list(visible = c(TRUE, FALSE, FALSE))),
               label = "Electricians by Population"),
          list(method = "update",
               args = list(list(visible = c(FALSE, TRUE, FALSE))),
               label = "Total Electricians"
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