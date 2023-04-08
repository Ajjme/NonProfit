

heating_fuel_margin_of_error <- readRDS( file = "./04_Outputs/rds/home_characteristics.rds") %>% 
  select(city, contains("heating_fuel"),  
          -contains("annotation"), -contains("percent"), -contains("estimate")) %>% 
  rename_with(~paste(str_extract(., "^\\w+"), str_extract(., "(?<=units_)\\w+")), contains("units_"))

heating_fuel <- readRDS( file = "./04_Outputs/rds/home_characteristics.rds") %>% 
  select(city, contains("heating_fuel"),  
         -contains("annotation"), -contains("percent"), -contains("margin"), -estimate_house_heating_fuel_occupied_housing_units) %>% 
  rename_with(~sub("^.*units_", "", .), contains("units_")) 


### use clean names ---------------

heating_fuel_long <- heating_fuel %>%
  pivot_longer(cols = -city, names_to = "fuel_type", values_to = "num_homes")

heating_fuel_long$fuel_type <- str_replace_all(heating_fuel_long$fuel_type, "_", " ")
heating_fuel_long$fuel_type <- str_to_title(heating_fuel_long$fuel_type)

# Stacked chart

ggplotly(
  ggplot(heating_fuel_long, aes(x = city, y = num_homes, fill = fuel_type)) +
    geom_bar(stat = "identity") +
    labs(title = "Heating Fuel by Geographic Area", x = "Geographic Area", y = "Number of Homes") +
    theme(legend.position = "bottom", axis.text.x = element_text(angle = 45, hjust = 1))
)
### standardize with number of homes---------------



### Scoring for Home heating all Electric
#need the chart of heating being solar and electric