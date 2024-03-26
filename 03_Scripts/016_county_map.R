### Input ----------------
zev_sales_county <- read_excel("./02_inputs/New_ZEV_Sales_Last_updated_01-31-2024_ada.xlsx", sheet = "County") %>% 
  clean_names()

### Map -------------------
zev_sales_one_value <- zev_sales_county %>% 
  pivot_wider(names_from = c(fuel_type, make, model), values_from = number_of_vehicles) %>% 
  filter(data_year == 2023) %>%
  mutate(Total_Sales = rowSums(select(., -c(data_year, county)), na.rm = TRUE))

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

join_county_fips <- left_join(zev_sales_one_value, county_fips_map, by= "county") %>% 
  drop_na(fips) %>% #out of state
  mutate_at(vars(Total_Sales), as.numeric) %>% 
  #this was really annoying 
  mutate(fips = stringr::str_pad(fips, width = 5, pad = "0")) %>% 
  mutate_at(vars(fips), as.character)%>% 
  mutate_all(~ifelse(is.na(.), 0, .))

### include time frame
### need to check matching--------------------------
g <- list(
  fitbounds = "locations",
  visible = FALSE
)
fig <- plot_ly()
fig <- fig %>% add_trace(
  type="choropleth",
  geojson=counties,
  locations=join_county_fips$fips,
  z=join_county_fips$Total_Sales,
  colorscale="Blues",
  marker=list(line=list(
    width=0)
  )
)
fig <- fig %>% colorbar(title = "Total EV and PHEV Sales")
fig <- fig %>% layout(
  title = "Total EV an PHEV Sales by County"
)

fig <- fig %>% layout(
  geo = g
)

fig



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
  z=join_county_fips$Total_Sales,
  colorscale="Blues",
  marker=list(line=list(
    width=0)
  )
)
fig_2 <- fig_2 %>% colorbar(title = "Total EV an PHEV Sales")
fig_2 <- fig_2 %>% layout(
  title = "Total EV an PHEV Sales by County"
)

fig_2 <- fig_2 %>% layout(
  geo = g
)

fig_2
