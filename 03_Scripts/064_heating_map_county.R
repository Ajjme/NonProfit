
#INput--------------------------
home_characteristics_county <- readRDS(file = "./04_Outputs/rds/060_home_characteristics_county.rds") %>% 
  select(county_name, county_fips, contains("heating_fuel"),  
         -contains("annotation"), -contains("percent"), -contains("margin"), -estimate_house_heating_fuel_occupied_housing_units) %>% 
  rename_with(~sub("^.*units_", "", .), contains("units_")) 


### use clean names ---------------

heating_fuel_long <- home_characteristics_county %>%
  pivot_longer(cols = -c(county_name, county_fips),  names_to = "fuel_type", values_to = "num_homes")

heating_fuel_long$fuel_type <- str_replace_all(heating_fuel_long$fuel_type, "_", " ")
heating_fuel_long$fuel_type <- str_to_title(heating_fuel_long$fuel_type)

### Standardize -----------
heating_fuel_percent <- heating_fuel_long %>% 
  mutate(dirty_v_clean = case_when(fuel_type == "Electricity" ~ "Clean",
                                   fuel_type == "No Fuel Used" ~ "Clean", 
                                   fuel_type == "Solar Energy" ~ "Clean",
                                   TRUE ~ "Combustion")) %>% 
  group_by(county_name, county_fips) %>% 
  mutate(total_homes = sum(num_homes)) %>% 
  ungroup() %>% 
  group_by(county_name, county_fips, dirty_v_clean) %>% 
  mutate(total_homes_fuel = sum(num_homes)) %>% 
  mutate(fuel_percent = total_homes_fuel/total_homes)

### remove dulps-------
heating_fuel_percent_county <- heating_fuel_percent %>% 
  select(county_name, county_fips, dirty_v_clean, fuel_percent) %>% 
  distinct() %>% 
  filter(dirty_v_clean == "Clean")%>%
  mutate(county_fips = sprintf("%05d", county_fips),
         fuel_percent = paste0(round(fuel_percent * 100)))
### percent clean is our standard ------------------------------

saveRDS(heating_fuel_percent_county, file = "./04_Outputs/rds/064_heating_fuel_percent__county.rds")







url <- 'https://raw.githubusercontent.com/plotly/datasets/master/geojson-counties-fips.json'
counties <- rjson::fromJSON(file=url)

library("RColorBrewer")
brewer.pal.info
##### scaled---------------
g <- list(
  fitbounds = "locations",
  visible = FALSE
)
fig_2 <- plot_ly()
fig_2 <- fig_2 %>% add_trace(
  type="choropleth",
  geojson=counties,
  locations=heating_fuel_percent_county$county_fips,
  z=heating_fuel_percent_county$fuel_percent,
  colorscale= 'Oranges', #colors = PrGn
  reversescale = T,
  marker=list(line=list(
    color = "black", width=.5)
  ),
  hovertemplate = "<b>%{text}</b><br>" ,
  text = heating_fuel_percent_county$fuel_percent
)

fig_2 <- fig_2 %>% colorbar(title = "Percent Clean Heating",
                            len = 0.7, # set the length of the colorbar
                            y = 0.9 # set the y position of the colorbar
)
fig_2 <- fig_2 %>% layout(
  title = "Percent Clean Heating in each County",
  margin = list(l = 0, r = 0, t = 20, b = 0)
)

fig_2 <- fig_2 %>% layout(
  geo = g
)

fig_2

saveRDS(fig_2, file = "./06_Reports_Rmd/map_heating_percent.rds")
#saveRDS(fig_2, file = "./04_Outputs/rds/map_ev_percent_county.rds")
