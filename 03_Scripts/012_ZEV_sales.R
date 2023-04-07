
source("./03_Scripts/000_init.R")
### Inputs------------------
#may have to change downloaded name

zev_sales_zip <- read_excel("./02_inputs/New_ZEV_Sales_Last_updated_01-18-2023.xlsx", sheet = "ZIP") %>% 
  clean_names() %>% 
  filter(data_year == "2022")

zev_sales_zip$number_of_vehicles <- as.numeric(zev_sales_zip$number_of_vehicles)

### Zip to City ----------------
ccc_zip_simple_map <- readRDS(file = "./04_Outputs/rds/ccc_zip_code_map.rds") %>% 
  select("zip"       ,       "lat",              "lng"     ,         "city") %>% 
  mutate(zip = as.integer(zip))

ZEV_sales_by_city <- left_join(ccc_zip_simple_map, zev_sales_zip , by = "zip") %>% 
  select( -data_year) %>%
  mutate(city = tolower(city))


ZEV_sales_by_city_clean_uni_ccc <- clean_city_names_uni_ccc(ZEV_sales_by_city) 

ZEV_sales_city <- ZEV_sales_by_city_clean_uni_ccc %>% 
  select(-zip, -lat, -lng)  %>%
  group_by(city, fuel_type) %>%
  summarize(total_vehicles = sum(number_of_vehicles))

### Standardize ----------------

# input number of cars-------------------
num_vehicles <- readRDS(file = "./04_Outputs/rds/full_ccc_census.rds") %>% 
  clean_names() %>% 
  select(city, total_vehicle) %>% 
  mutate(city = if_else(city == "Uni_CCC", "Uni. CCC", city)) 
  

#standardize ----------------
ZEV_sales_city_standardized <- full_join(num_vehicles, ZEV_sales_city, by = "city") %>% 
  mutate(total_vehicle_per_zev = (total_vehicle/total_vehicles)) %>% 
  mutate(zev_per_total_vehicle = (total_vehicles/total_vehicle))
### Bar------------------------
#Prep-----------

#totals----------------
# Create a ggplot object with the ZEV_sales_city_standardized dataframe
p <- ggplot(ZEV_sales_city_standardized, aes(x = city, y = total_vehicle_per_zev, fill = fuel_type)) + 
  geom_col(position = "dodge") +
  labs(title = "Total Vehicle per ZEV by Fuel Type", y = "Total Vehicle per ZEV")

# Convert the ggplot object to a plotly object
ggplotly(p)

### max 100 Rankings ---------------
ZEV_sales_city_standardized_elect <- ZEV_sales_city_standardized %>% 
  filter(fuel_type == "Electric") %>% 
  mutate(ev_per_total_vehicle_scaled = 100 * zev_per_total_vehicle / max(zev_per_total_vehicle))

ZEV_sales_city_standardized_phev <- ZEV_sales_city_standardized %>% 
  filter(fuel_type == "PHEV")%>% 
  mutate(phev_per_total_vehicle_scaled = 100 * zev_per_total_vehicle / max(zev_per_total_vehicle))

### Saving RDS---------------
saveRDS(ZEV_sales_city_standardized_elect, file = "./06_Reports_Rmd/ZEV_sales_city_standardized_elect.rds")

# Create a ggplot object with the ZEV_sales_city_standardized dataframe
# plotly__obj <- ggplot(ZEV_sales_city_standardized_elect, aes(x = city, y = ev_per_total_vehicle_scaled, fill = fuel_type)) + 
#   geom_col(position = "dodge", color = "black") +
#   labs(title = "Ranked EV Sales", y = "EV Ranking") +
#   theme(axis.title.x = element_text(hjust = 1),
#         axis.title.y = element_text(hjust = 1),
#         panel.grid.major.y = element_line(color = "gray"),
#         panel.background = element_rect(fill = "white"),
#         axis.text.x = element_text(angle = 45, hjust = 1)) 

### with filter
# Convert the ggplot object to a plotly object
plotly__obj <- ggplotly(plotly__obj)

fig_multi <- plot_ly(ZEV_sales_city_standardized_elect, x = ~city, y = ~ev_per_total_vehicle_scaled, name = "EV Score", type = "bar", showlegend = FALSE, marker = list(line = list(color = "black", width = 1))) %>%
  add_trace(y = ~total_vehicles, name = "Total EV Sold", type = "bar", visible = FALSE) %>%
  layout( 
    updatemenus = list(
      list(
        type = "buttons",
        direction = "down",
        showactive = TRUE,
        buttons = list(
          list(method = "update",
               args = list(list(visible = c(TRUE, FALSE))),
               label = "EV Score"),
          list(method = "update",
               args = list(list(visible = c(FALSE, TRUE))),
               label = "Total EV Sold"
          )
        ),
        pad = list(r = 15, t = 0, b = 0, l = 0)
      )
    ),
    xaxis = list(title = "City", tickfont = list(size = 14), tickangle = 45),
    yaxis = list(title = "", tickfont = list(size = 14)),
    margin = list(l = 60, r = 20, t = 40, b = 40),
    font = list(family = "Arial", size = 14)
  )


# save the Plotly object to an RDS file
saveRDS(fig_multi, file = "./06_Reports_Rmd/EV_Score_and_totals.rds")

