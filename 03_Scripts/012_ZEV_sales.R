
source("./03_Scripts/000_init.R")
### Inputs------------------
#may have to change downloaded name

zev_sales_zip <- read_xlsx("./02_inputs/New_ZEV_Sales_Last_updated_01-18-2023.xlsx", sheet = "ZIP")

zip_map_ccc <- readRDS(file = "./04_Outputs/rds/ccc_zip_code_map.rds")

zev_sales_ccc <- left_join()



zev_sales_county <- read_xlsx("./02_inputs/New_ZEV_Sales_Last_updated_01-18-2023.xlsx", sheet = "County") %>% 
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

library(rjson)
library(jsonlite)


url <- 'https://raw.githubusercontent.com/plotly/datasets/master/geojson-counties-fips.json'
counties <- rjson::fromJSON(file=url)

### map
zev_map <- zev_sales_county_mapped %>%
  group_by(county_name) %>%
  summarise(total_sales = sum(number_of_vehicles)) %>%
  plot_geo(locations = ~county_name, z = ~total_sales,
           locationmode = "USA-states",
           type = "choropleth",
           colors = "Blues",
           marker = list(line = list(color = "#FFF", width = 1))) %>%
  layout(title = "Total Zero-Emission Vehicle Sales by County in California",
         geo = list(scope = "usa",
                    projection = list(type = "albers usa"),
                    showlakes = TRUE,
                    lakecolor = toRGB("white"))) %>%
  colorbar(title = "Total Number of Vehicles",
           tickprefix = "",
           ticksuffix = "",
           len = 0.7,
           y = 0.5,
           x = 1.02)

zev_map