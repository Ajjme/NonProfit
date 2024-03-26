### Input ----------------
zev_sales_county <- read_excel("./02_inputs/New_ZEV_Sales_Last_updated_01-31-2024_ada.xlsx", sheet = "County") %>% 
  clean_names()

### Map -------------------
zev_sales_one_value <- zev_sales_county %>% 
  pivot_wider(names_from = c(fuel_type, make, model), values_from = number_of_vehicles) %>% 
  filter(data_year == 2023) %>%
  mutate(Total_Sales = rowSums(select(., -c(data_year, county)), na.rm = TRUE))

zev_sales_all <- zev_sales_county %>% 
  pivot_wider(names_from = c(fuel_type, make, model), values_from = number_of_vehicles) %>% 
  #filter(data_year == 2022) %>%
  mutate(Total_Sales = rowSums(select(., -c(data_year, county)), na.rm = TRUE)) %>%  
  group_by(county) %>% 
  summarise(all_sales_ev = sum(Total_Sales)) %>% 
  ungroup()

####
library(plotly)
library(rjson)

url <- 'https://raw.githubusercontent.com/plotly/datasets/master/geojson-counties-fips.json'
counties <- rjson::fromJSON(file=url)

### add fips to data

urlmap <- "https://raw.githubusercontent.com/kjhealy/fips-codes/master/state_and_county_fips_master.csv"



county_fips_map <- read.csv(urlmap, colClasses=c(fips="character")) %>%
  filter(state == "CA") %>% 
  rename(county = name) %>% 
  mutate(county = ifelse(str_detect(county, " County"), str_replace(county, " County", ""), county))

#saveRDS(county_fips_map,  file = "county_test.rds")

join_county_fips <- left_join(zev_sales_all, county_fips_map, by= "county") %>% 
  drop_na(fips) %>% #out of state
  mutate_at(vars(all_sales_ev), as.numeric) %>% 
  #this was really annoying 
  mutate(fips = stringr::str_pad(fips, width = 5, pad = "0")) %>% 
  mutate_at(vars(fips), as.character)%>% 
  mutate_all(~ifelse(is.na(.), 0, .))

# join_county_fips <- left_join(zev_sales_one_value, county_fips_map, by= "county") %>% 
#   drop_na(fips) %>% #out of state
#   mutate_at(vars(Total_Sales), as.numeric) %>% 
#   #this was really annoying 
#   mutate(fips = stringr::str_pad(fips, width = 5, pad = "0")) %>% 
#   mutate_at(vars(fips), as.character)%>% 
#   mutate_all(~ifelse(is.na(.), 0, .))
### has vehicle numbers --------
acs_general_pct_named_county <- readRDS(file = "./04_Outputs/rds/acs_general_pct_named_county.rds") %>% 
  select(county, total_vehicle) %>% 
  rename(fips = county)

join_county_fips_vehicle <- left_join(join_county_fips, acs_general_pct_named_county, by="fips")

standardized_county_evs <- join_county_fips_vehicle %>% 
  mutate(standardized_percent_ev_sales = round(100 * all_sales_ev/total_vehicle)) %>% 
  mutate(county_percent_ev = paste(county, standardized_percent_ev_sales, sep = " "))%>% 
  mutate(county_percent_ev = paste(county_percent_ev, "%", sep = ""))

#Changing to total ev vs total vehicles (not just the year)
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
  locations=join_county_fips$fips,
  z=standardized_county_evs$standardized_percent_ev_sales,
  colorscale= 'Greens', #colors = PrGn
  reversescale = T,
  marker=list(line=list(
    color = "black", width=.5)
  ),
  hovertemplate = "<b>%{text}</b><br>" ,
  text = standardized_county_evs$county_percent_ev
)

fig_2 <- fig_2 %>% colorbar(title = "Percent EV (starting 1988)",
                            len = 0.7, # set the length of the colorbar
                            y = 0.9 # set the y position of the colorbar
                            )
fig_2 <- fig_2 %>% layout(
  title = "Percent EVs in each County",
  margin = list(l = 0, r = 0, t = 20, b = 0)
)

fig_2 <- fig_2 %>% layout(
  geo = g
)

fig_2

saveRDS(fig_2, file = "./06_Reports_Rmd/map_ev_percent_county.rds")
#saveRDS(fig_2, file = "./04_Outputs/rds/map_ev_percent_county.rds")
