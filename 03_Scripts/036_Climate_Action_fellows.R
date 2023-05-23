
source("./03_Scripts/000_init.R")
### Inputs------------------
#update by hand
cac_data <- read_csv("./02_inputs/Climate_Action_fellows.csv") %>% 
  clean_names() %>% 
  mutate(city = str_to_lower(city)) %>% 
  clean_city_names_uni_ccc() %>% 
  mutate(x23_24_full_term_points = ifelse(is.na(x23_24_full_term_points), 0, x23_24_full_term_points))
saveRDS(cac_data, file = "./06_Reports_Rmd/cac_data.rds")

# Score and then the number they have had and the number they have now 3 layers
plot_ly(cac_data, x = ~city, y = ~x23_24_full_term_points, name = "Scores", type = "bar", showlegend = FALSE, marker = list(color = "grey", line = list(color = "black", width = 1))) %>%
  add_trace(y = ~past_fellows, name = "CAC Fellow in Past Years", type = "bar", visible = FALSE) %>%
  add_trace(y = ~total_fellows, name = "Total CAC Fellows", type = "bar", visible = FALSE) %>%
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
               label = "CAC Fellow in Past Years"
          ),
          list(method = "update",
               args = list(list(visible = c(FALSE,  FALSE, TRUE))),
               label = "Total CAC Fellows"
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
