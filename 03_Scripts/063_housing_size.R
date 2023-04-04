## housing size


size_margin_of_error <- readRDS( file = "./04_Outputs/rds/home_characteristics.rds") %>% 
  select(city, contains("rooms"),  
         -contains("annotation"), -contains("percent"), -contains("estimate")) %>% 
  rename_with(~paste(str_extract(., "^\\w+"), str_extract(., "(?<=units_)\\w+")), contains("units_"))

size <- readRDS( file = "./04_Outputs/rds/home_characteristics.rds") %>% 
  select(city, contains("rooms"), -contains("bed"), -contains("med"),
         -contains("annotation"), -contains("percent"), -contains("margin"), -estimate_bedrooms_total_housing_units, -estimate_rooms_total_housing_units ) %>% 
  rename_with(~sub("^.*units_", "", .), contains("units_")) 

size_long <- size %>%
  pivot_longer(cols = -city, names_to = "rooms", values_to = "num_homes")

size_long$rooms <- str_replace_all(size_long$rooms,"_", " ")
size_long$rooms <- str_to_title(size_long$rooms)

# Create the interactive plot

ggplotly(
  ggplot(size_long, aes(x = city, y = num_homes, fill = rooms)) +
    geom_bar(stat = "identity") +
    labs(title = "Number of Rooms by Geographic Area", x = "Geographic Area", y = "Number of Homes") +
    theme(legend.position = "bottom", axis.text.x = element_text(angle = 45, hjust = 1))
)