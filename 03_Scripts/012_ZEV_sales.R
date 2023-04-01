
source("./03_Scripts/000_init.R")
### Inputs------------------
#may have to change downloaded name

zev_sales_zip <- read_xlsx("./02_inputs/New_ZEV_Sales_Last_updated_01-18-2023.xlsx", sheet = "ZIP")

zip_map_ccc <- readRDS(file = "./04_Outputs/rds/ccc_zip_code_map.rds")

library(readxl)
zev_sales_county <- read_excel("./02_inputs/New_ZEV_Sales_Last_updated_01-18-2023.xlsx", sheet = "County") %>% 
  clean_names()

### bar graph
zev_plot <- zev_sales_county %>%
  group_by(county) %>%
  summarise(total_sales = sum(number_of_vehicles)) %>%
  plot_ly(x = ~county, y = ~total_sales, type = "bar",
          marker = list(color = "#636EFA")) %>%
  layout(xaxis = list(title = "County", showgrid = FALSE),
         yaxis = list(title = "Total Number of Vehicles", showgrid = FALSE),
         title = "Total Zero-Emission Vehicle Sales by County",
         margin = list(l = 100, r = 100, t = 100, b = 100),
         plot_bgcolor = "#F4F4F4",
         paper_bgcolor = "#F4F4F4",
         font = list(family = "Helvetica Neue"))

zev_plot

### Map -------------------
zev_sales_one_value <- zev_sales_county %>% 
  pivot_wider(names_from = c(fuel_type, make, model), values_from = number_of_vehicles) %>% 
  filter(data_year == 2022) %>%
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
fig <- fig %>% colorbar(title = "Total EV an PHEV Sales")
fig <- fig %>% layout(
  title = "Total EV an PHEV Sales by County"
)

fig <- fig %>% layout(
  geo = g
)

fig
#####