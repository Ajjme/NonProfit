
####
library(plotly)
library(rjson)

 url <- 'https://raw.githubusercontent.com/plotly/datasets/master/geojson-counties-fips.json'
counties <- rjson::fromJSON(file=url)
# 
# ### add fips to data
# 
# urlmap <- "https://raw.githubusercontent.com/kjhealy/fips-codes/master/state_and_county_fips_master.csv"
join_county_fips <- left_join(standardized_county_electricians, county_fips_map, by= "county") %>% 
  #drop_na(fips) %>% #out of state
  mutate_at(vars(value), as.numeric) %>% 
  #this was really annoying 
  mutate(fips = stringr::str_pad(fips, width = 5, pad = "0")) %>% 
  mutate_at(vars(fips), as.character) %>% 
  mutate_all(~ifelse(is.na(.), 0, .))


standardized_county_electricians <- readRDS(file = "./04_Outputs/rds/employment_county_data_map.rds")

library(jsonlite)

# Download California GeoJSON data
url <- 'https://raw.githubusercontent.com/plotly/datasets/master/geojson-counties-fips.json'
all_counties <- fromJSON(url)

# Extract California GeoJSON data
#california_geojson <- all_counties$features[all_counties$features$properties$STATE == "06", ]
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
  z=standardized_county_electricians$standardized_electricians_per_ten_thousand,
  colorscale= 'oranges', #colors = PrGn
  reversescale = T,
  marker=list(line=list(
    color = "black", width=.5)
  ),
  hovertemplate = "<b>%{text}</b><br>" ,
  text = standardized_county_electricians$county_electricians_per_ten_thousand
)

fig_2 <- fig_2 %>% colorbar(title = "Electricians per Ten Thousand",
                            len = 0.7, # set the length of the colorbar
                            y = 0.9 # set the y position of the colorbar
)
fig_2 <- fig_2 %>% add_polygons(
  data = california_geojson,  # GeoJSON data for California
  color = I("black"),         # Color of the outline
  opacity = 0.5,              # Opacity of the outline
  showlegend = FALSE          # Hide the legend for the California outline
)

fig_2 <- fig_2 %>% layout(
  title = "Electricians per Ten Thousand",
  margin = list(l = 0, r = 0, t = 20, b = 0)
)


fig_2 <- fig_2 %>% layout(
  geo = g
)

fig_2

saveRDS(fig_2, file = "./06_Reports_Rmd/map_Electricians per Ten Thousand.rds")
