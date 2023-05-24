# housing age


### this should really be a box plot



structure <- readRDS( file = "./04_Outputs/rds/home_characteristics.rds") %>% 
  select(city, contains("structure"),  
         -contains("annotation"), -contains("percent"), -contains("margin"), -estimate_year_structure_built_total_housing_units) %>% 
  rename_with(~sub("^.*units_", "", .), contains("units_")) 

structure_long <- structure %>%
  pivot_longer(cols = -city, names_to = "time_built", values_to = "num_homes")

structure_long$time_built <- str_replace_all(structure_long$time_built,"_", " ")
structure_long$time_built <- str_to_title(structure_long$time_built)

#sum all the matching groups

structure_long_summarized <- structure_long %>%
  group_by(city, time_built) %>%
  summarize(`Number of Homes` = sum(num_homes)) %>% 
  rename(City = city,
         `Time` = time_built)


# make into a box plot 

home_age <- ggplotly(
  ggplot(structure_long_summarized, aes(x = City, y = `Number of Homes`, fill = `Time`)) +
    geom_bar(stat = "identity") +
    labs(title = "Age of Home by Geographic Area", x = "Geographic Area", y = "Number of Homes") +
    theme(legend.position = "bottom", axis.text.x = element_text(angle = 45, hjust = 1), panel.background = element_blank())
)

saveRDS(home_age, file = "./06_Reports_Rmd/home_age.rds")


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

# 
# structure_margin_of_error <- readRDS( file = "./04_Outputs/rds/home_characteristics.rds") %>% 
#   select(city, contains("structure"),  
#          -contains("annotation"), -contains("percent"), -contains("estimate")) %>% 
#   rename_with(~paste(str_extract(., "^\\w+"), str_extract(., "(?<=units_)\\w+")), contains("units_"))
