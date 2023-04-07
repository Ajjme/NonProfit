#charger bar chart
#Input charges--------------
EV_stations_total <- readRDS(file = "./04_Outputs/rds/EV_stations_total.rds")
EV_stations_total_ccc <- readRDS(file = "./04_Outputs/rds/EV_stations_total_ccc.rds") %>% 
  # Convert column names to lowercase
  rename_all(tolower) %>%
  # Convert strings in 'city' column to lowercase
  mutate(city = tolower(city))

EV_stations_total_ccc$Total_stations <- as.numeric(EV_stations_total_ccc$Total_stations)
  # input number of cars-------------------
num_vehicles <- readRDS(file = "./04_Outputs/rds/full_ccc_census.rds") %>% 
  clean_names() %>% 
  select(city, total_vehicle)

EV_stations_total_ccc_clean <- clean_city_names(EV_stations_total_ccc)


#standardize ----------------
EV_stations_standardized <- full_join(num_vehicles, EV_stations_total_ccc_clean, by = "city") %>% 
  mutate(total_stations = replace_na(total_stations, 0)) %>% 
  mutate(stations_per_car = (total_stations/total_vehicle))%>% 
  mutate(chargers_per_total_vehicle_scaled = 100 * stations_per_car / max(stations_per_car))
### Saving-----------
saveRDS(EV_stations_standardized, file = "./06_Reports_Rmd/EV_stations_standardized.rds")

### Plot------------------------

### great example of fixing the hover text
# Create the ggplot object
ggplot_obj <- ggplot(EV_stations_standardized, aes(x = reorder(city, desc(stations_per_car)), y = stations_per_car, fill = stations_per_car, text = paste("Stations per Car: ", stations_per_car))) +
  geom_bar(stat = "identity") +
  xlab("City") +
  ylab("Total Stations") +
  my_future_theme()+
  ggtitle("Total EV Stations by City")  +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  scale_fill_gradient(low = "grey", high = "darkgreen")
# Convert the ggplot object to an interactive plotly object
plotly_obj <- ggplotly(ggplot_obj, tooltip = "text", hoverinfo = "text")

# Print the interactive plotly object
print(plotly_obj)

### Output--------------
saveWidget(plotly_obj, file = "./06_Reports_Rmd/Rankings_charger_ccc_015.html")


fig_multi <- plot_ly(EV_stations_standardized, x = ~city, y = ~chargers_per_total_vehicle_scaled, name = "Stations Score", type = "bar", showlegend = FALSE, marker = list(line = list(color = "black", width = 1))) %>%
  add_trace(y = ~total_stations, name = "Total Stations", type = "bar", visible = FALSE) %>%
  layout( 
    updatemenus = list(
      list(
        type = "buttons",
        direction = "down",
        showactive = TRUE,
        buttons = list(
          list(method = "update",
               args = list(list(visible = c(TRUE, FALSE))),
               label = "EV Score"),
          list(method = "update",
               args = list(list(visible = c(FALSE, TRUE))),
               label = "Total Stations"
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



### Archive ----------------------------
# # Define the ggplot object
# ggplot_obj <- ggplot(EV_stations_standardized, aes(x = city, y = total_stations, fill = total_stations)) +
#   geom_bar(stat = "identity") +
#   xlab("city") +
#   ylab("Total Stations") +
#   my_enviro_theme()+
#   ggtitle("Total EV Stations by City")  +
#   theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
#   scale_fill_gradient(low = "grey", high = "darkgreen")
# 
# # Convert the ggplot object to an interactive plotly object
# plotly_obj <- ggplotly(ggplot_obj)
# 
# # Check if the dropdown filter is added correctly and is referencing the correct column name
# if (!("stations_per_car" %in% names(EV_stations_standardized))) {
#   stop("The 'stations_per_car' column does not exist in the data.")
# }
# 
# # Add the dropdown filter for 'stations_per_car'
# plotly_obj <- plotly_obj %>%
#   layout(
#     updatemenus = list(
#       list(
#         buttons = list(
#           list(
#             method = "update",
#             args = list(list(y = EV_stations_standardized$total_stations),
#                         list(title = "Total EV Stations by City")),
#             label = "Total Stations"
#           ),
#           list(
#             method = "update",
#             args = list(list(y = EV_stations_standardized$stations_per_car),
#                         list(title = "EV Stations per Car by City")),
#             label = "Stations per Car"
#           )
#         ),
#         type = "buttons",
#         direction = "right",
#         showactive = TRUE,
#         x = 0.05,
#         xanchor = "left",
#         y = 1.1,
#         yanchor = "top"
#       )
#     )
#   )
# 
# # Print the interactive plotly object
# print(plotly_obj)

   

