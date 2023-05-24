## housing size

size <- readRDS( file = "./04_Outputs/rds/home_characteristics.rds") %>% 
  select(city, contains("rooms"), -contains("bed"), -contains("med"),
         -contains("annotation"), -contains("percent"), -contains("margin"), -estimate_bedrooms_total_housing_units, -estimate_rooms_total_housing_units ) %>% 
  rename_with(~sub("^.*units_", "", .), contains("units_")) 

size_long <- size %>%
  pivot_longer(cols = -city, names_to = "rooms", values_to = "num_homes")

size_long$rooms <- str_replace_all(size_long$rooms,"_", " ")
size_long$rooms <- str_to_title(size_long$rooms)

# make into a box plot

# Create a boxplot of total system cost by service city using plotly, removing outliers
plot_cost <- plot_ly(size_long, x = ~city, y = ~num_homes, type = "box",
                     boxpoints = "outliers", jitter = 0.3, pointpos = -1.8)

# Set plot title and axis labels
plot_cost <- plot_cost %>% layout(title = "Typical Homes Size by Service City",
                                  xaxis = list(title = "City"),
                                  yaxis = list(title = "Square Footage"))

# Show 
plot_cost
saveRDS(plot_cost, file = "./06_Reports_Rmd/plot_cost.rds")

#rooms include kitchen and living rooms

# Bar graph but not useful
ggplotly(
  ggplot(size_long, aes(x = city, y = num_homes, fill = rooms)) +
    geom_bar(stat = "identity") +
    labs(title = "Number of Rooms by Geographic Area", x = "Geographic Area", y = "Number of Homes") +
    theme(legend.position = "bottom", axis.text.x = element_text(angle = 45, hjust = 1))
)