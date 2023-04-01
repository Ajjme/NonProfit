
source("./03_Scripts/000_init.R")
### Inputs------------------
#may have to change downloaded name
buses <- read_xlsx("./02_inputs/School_Bus_and_School_Bus_Charger_Last_updated_01-30-2023.xlsx", sheet= "School Bus and Charger") %>% 
  clean_names()

url <- 'https://raw.githubusercontent.com/plotly/datasets/master/geojson-counties-fips.json'
counties <- rjson::fromJSON(file=url)

### add fips to data
urlmap <- "https://raw.githubusercontent.com/kjhealy/fips-codes/master/state_and_county_fips_master.csv"
county_fips_map <- read.csv(urlmap, colClasses=c(fips="character")) %>%
  filter(state == "CA") %>% 
  rename(county = name) %>% 
  mutate(county = ifelse(str_detect(county, " County"), str_replace(county, " County", ""), county))

join_county_fips_buses <- left_join(buses, county_fips_map, by= "county") %>% 
  mutate(fips = case_when(is.na(fips) ~ "6071",
                          TRUE ~ fips)) %>% 
  mutate(fips = stringr::str_pad(fips, width = 5, pad = "0")) %>% 
  mutate_at(vars(fips), as.character)




g <- list(
  scope = 'california',
  projection = list(type = 'albers usa'),
  showlakes = TRUE,
  lakecolor = toRGB('white')
)
fig <- plot_ly()
fig <- fig %>% add_trace(
  type="choropleth",
  geojson=counties,
  locations=join_county_fips_buses$fips,
  z=join_county_fips_buses$total_buses_awarded,
  colorscale="Blues",
  marker=list(line=list(
    width=0)
  )
)
fig <- fig %>% colorbar(title = "Total Buses Awarded")
fig <- fig %>% layout(
  title = "Total Buses Awarded by County"
)

fig <- fig %>% layout(
  geo = g
)

fig

#####

ccc_buses <- buses %>% 
  filter(county =="Contra Costa")

g <- list(
  scope = 'california',
  projection = list(type = 'albers usa', center = list(lon = -119, lat = 37.5)),
  showlakes = TRUE,
  lakecolor = toRGB('white')
)

fig <- plot_ly()
fig <- fig %>% add_trace(
  type="choropleth",
  geojson=counties,
  locations=join_county_fips_buses$fips,
  z=join_county_fips_buses$total_buses_awarded,
  colorscale="Blues",
  marker=list(line=list(
    width=0)
  )
)
fig <- fig %>% colorbar(title = "Total Buses Awarded")
fig <- fig %>% layout(
  title = "Total Buses Awarded by County"
)

fig <- fig %>% layout(
  geo = g
)

fig
# California Energy Commission School Bus Replacement Program to replace California's
# oldest diesel buses with all-new battery electric buses and install supporting charging 
# infrastructure. This dashboard will be updated quarterly to display the progress in delivering
# CEC awarded electric school buses and installing charging infrastructure throughout California.

### need to look for this data-----------------

# The California Air Resources Board (CARB) also funds electric school buses and supports the transition
# to a zero-emission school bus fleet.