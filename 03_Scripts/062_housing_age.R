# housing age


### this should really be a box plot




structure_margin_of_error <- readRDS( file = "./04_Outputs/rds/home_characteristics.rds") %>% 
  select(city, contains("structure"),  
         -contains("annotation"), -contains("percent"), -contains("estimate")) %>% 
  rename_with(~paste(str_extract(., "^\\w+"), str_extract(., "(?<=units_)\\w+")), contains("units_"))

structure <- readRDS( file = "./04_Outputs/rds/home_characteristics.rds") %>% 
  select(city, contains("structure"),  
         -contains("annotation"), -contains("percent"), -contains("margin"), -estimate_year_structure_built_total_housing_units) %>% 
  rename_with(~sub("^.*units_", "", .), contains("units_")) 

structure_long <- structure %>%
  pivot_longer(cols = -city, names_to = "time_built", values_to = "num_homes")

structure_long$time_built <- str_replace_all(structure_long$time_built,"_", " ")
structure_long$time_built <- str_to_title(structure_long$time_built)

# make into a box plot 

ggplotly(
  ggplot(structure_long, aes(x = city, y = num_homes, fill = time_built)) +
    geom_bar(stat = "identity") +
    labs(title = "Age of Home by Geographic Area", x = "Geographic Area", y = "Number of Homes") +
    theme(legend.position = "bottom", axis.text.x = element_text(angle = 45, hjust = 1))
)

##Need to pull out and rank by average age














# # Pivot the data to long format
# structure_long_2 <- pivot_longer(structure, -city, names_to = "year_built", values_to = "count")
# 
# # Create the interactive box plot
# plot <- ggplot(structure_long_2, aes(x = year_built, y = count)) +
#   geom_boxplot() +
#   labs(title = "Distribution of Year Built", x = "Year Built", y = "Count") +
#   theme(plot.title = element_text(hjust = 0.5))
# 
# ggplotly(plot)