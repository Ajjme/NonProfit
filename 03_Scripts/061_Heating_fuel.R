
# 
# heating_fuel_margin_of_error <- readRDS( file = "./04_Outputs/rds/home_characteristics.rds") %>% 
#   select(city, contains("heating_fuel"),  
#           -contains("annotation"), -contains("percent"), -contains("estimate")) %>% 
#   rename_with(~paste(str_extract(., "^\\w+"), str_extract(., "(?<=units_)\\w+")), contains("units_"))

heating_fuel <- readRDS( file = "./04_Outputs/rds/home_characteristics.rds") %>% 
  select(city, contains("heating_fuel"),  
         -contains("annotation"), -contains("percent"), -contains("margin"), -estimate_house_heating_fuel_occupied_housing_units) %>% 
  rename_with(~sub("^.*units_", "", .), contains("units_")) 


### use clean names ---------------

heating_fuel_long <- heating_fuel %>%
  pivot_longer(cols = -city, names_to = "fuel_type", values_to = "num_homes")

heating_fuel_long$fuel_type <- str_replace_all(heating_fuel_long$fuel_type, "_", " ")
heating_fuel_long$fuel_type <- str_to_title(heating_fuel_long$fuel_type)

### Standardize -----------
heating_fuel_percent <- heating_fuel_long %>% 
  mutate(dirty_v_clean = case_when(fuel_type == "Electricity" ~ "Clean",
                         fuel_type == "No Fuel Used" ~ "Clean", 
                         fuel_type == "Solar Energy" ~ "Clean",
                         TRUE ~ "Combustion")) %>% 
  group_by(city) %>% 
  mutate(total_homes = sum(num_homes)) %>% 
  ungroup() %>% 
  group_by(city, dirty_v_clean) %>% 
  mutate(total_homes_fuel = sum(num_homes)) %>% 
  mutate(fuel_percent = total_homes_fuel/total_homes)

### remove dulps-------
heating_fuel_percent_two <- heating_fuel_percent %>% 
  select(city, dirty_v_clean, fuel_percent) %>% 
  distinct() %>% 
  filter(dirty_v_clean == "Clean")
### percent clean is our standard ------------------------------

saveRDS(heating_fuel_percent_two, file = "./04_Outputs/rds/heating_fuel_percent_two.rds")





# Stacked chart of all fuel types--------------------------

plot_heating <- 
  ggplot(heating_fuel_long, aes(x = city, y = num_homes, fill = fuel_type, text = paste("Fuel Type: ", fuel_type, "<br>Number of Homes: ", num_homes))) +
    geom_bar(stat = "identity") +
    labs(title = "Heating Fuel by Geographic Area", x = "Geographic Area", y = "Number of Homes") +
    theme(axis.title.y = element_text(hjust = 1),
          panel.grid.major.y = element_line(color = "gray"),
          panel.background = element_rect(fill = "white"),
          axis.text.x = element_text(angle = 45, hjust = 0.5))+
    guides(fill = "none")
### standardize with number of homes---------------


plot_heating <- ggplotly(plot_heating, tooltip = "text", hoverinfo = "text")


saveRDS(plot_heating, file = "./06_Reports_Rmd/plot_heating.rds")
