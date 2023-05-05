
source("./03_Scripts/000_init.R")
### Inputs------------------
#may have to change downloaded name

car_sales_zip <- read_csv("./02_inputs/vehicle-fuel-type-count-by-zip-code-2022.csv") %>% 
  clean_names() %>% 
  filter(model_year == "2022") %>% 
  select(-date, -make, -duty ) %>% 
  group_by(zip_code, fuel) %>% 
  summarise(new_vehicles = sum(vehicles)) %>% 
  rename(zip = zip_code)%>% 
  mutate(zip = as.integer(zip))

### Zip to City ----------------
ccc_zip_simple_map <- readRDS(file = "./04_Outputs/rds/ccc_zip_code_map.rds") %>% 
  select("zip"       ,       "lat",              "lng"     ,         "city") %>% 
  mutate(zip = as.integer(zip))

ZEV_sales_by_city <- left_join(ccc_zip_simple_map, car_sales_zip , by = "zip") %>% 
  mutate(city = tolower(city))


ZEV_sales_by_city_clean_uni_ccc <- clean_city_names_uni_ccc(ZEV_sales_by_city) 

ZEV_sales_city <- ZEV_sales_by_city_clean_uni_ccc %>% 
  select(-zip, -lat, -lng)  %>%
  group_by(city, fuel) %>%
  summarize(total_new_vehicles_by_type = sum(new_vehicles)) %>% 
  drop_na()

### Standardize ----------------

# input number of cars-------------------
num_vehicles <- ZEV_sales_city %>% 
  select(city, total_new_vehicles_by_type) %>% 
  group_by(city) %>% 
  summarize(total_new_vehicles = sum(total_new_vehicles_by_type))


#standardize ----------------
ZEV_sales_city_info <- full_join(num_vehicles, ZEV_sales_city, by = "city") %>% 
  mutate(percent_type = total_new_vehicles_by_type/total_new_vehicles)

ZEV_sales_city_standardized <- ZEV_sales_city_info %>% 
  filter(fuel == "Battery Electric") %>% 
  mutate(ev_per_new_vehicle_scaled = 100 * percent_type / max(percent_type)) %>% 
  mutate(percent_ev = 100 *percent_type)

saveRDS(ZEV_sales_city_standardized, file = "./06_Reports_Rmd/ZEV_sales_city_standardized_ev.rds")






plot_ly(ZEV_sales_city_standardized, x = ~city, y = ~percent_ev, name = "Percent EVs", type = "bar", showlegend = FALSE, marker = list(color = "darkgreen", line = list(color = "black", width = 1))) %>%
  add_trace(y = ~total_new_vehicles_by_type, name = "Total EV Sold", type = "bar", visible = FALSE) %>%
  add_trace(y = ~total_new_vehicles, name = "Total New Vehicles, 2022", type = "bar", visible = FALSE) %>%
  layout( 
    updatemenus = list(
      list(
        type = "buttons",
        direction = "down",
        showactive = TRUE,
        buttons = list(
          list(method = "update",
               args = list(list(visible = c(TRUE, FALSE, FALSE))),
               label = "Percent EVs Sold"),
          list(method = "update",
               args = list(list(visible = c(FALSE, TRUE, FALSE))),
               label = "Total EVs Sold"
          ),
          list(method = "update",
               args = list(list(visible = c(FALSE,  FALSE, TRUE))),
               label = "Total New Vehicles"
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




#totals----------------
# # Create a ggplot object with the ZEV_sales_city_standardized dataframe
# p <- ggplot(ZEV_sales_city_standardized, aes(x = city, y = ev_per_new_vehicle_scaled, fill = fuel)) + 
#   geom_col(position = "dodge") +
#   labs(title = "Total New Vehicle per EV", y = "Total New Vehicle per EV")
# 
# # Convert the ggplot object to a plotly object
# ggplotly(p)
# 
# ### max 100 Rankings ---------------
# ZEV_sales_city_standardized_elect <- ZEV_sales_city_standardized %>% 
#   filter(fuel_type == "Electric") %>% 
#   mutate(ev_per_total_vehicle_scaled = 100 * zev_per_total_vehicle / max(zev_per_total_vehicle))
# 
# ZEV_sales_city_standardized_phev <- ZEV_sales_city_standardized %>% 
#   filter(fuel_type == "PHEV")%>% 
#   mutate(phev_per_total_vehicle_scaled = 100 * zev_per_total_vehicle / max(zev_per_total_vehicle))
# 
# ### Saving RDS---------------
# saveRDS(ZEV_sales_city_standardized_elect, file = "./06_Reports_Rmd/ZEV_sales_city_standardized_elect.rds")

# 
# plot_ly(ZEV_sales_city_standardized_ev, x = ~city, y = ~ev_per_new_vehicle_scaled, name = "EV Score", type = "bar", showlegend = FALSE, marker = list(color = "darkgreen", line = list(color = "black", width = 1))) %>%
#   add_trace(y = ~total_new_vehicles_by_type, name = "Total EV Sold", type = "bar", visible = FALSE) %>%
#   layout( 
#     updatemenus = list(
#       list(
#         type = "buttons",
#         direction = "down",
#         showactive = TRUE,
#         buttons = list(
#           list(method = "update",
#                args = list(list(visible = c(TRUE, FALSE))),
#                label = "EV Score"),
#           list(method = "update",
#                args = list(list(visible = c(FALSE, TRUE))),
#                label = "Total EV Sold"
#           )
#         ),
#         pad = list(r = 15, t = 0, b = 0, l = 0)
#       )
#     ),
#     xaxis = list(title = "City", tickfont = list(size = 14), tickangle = 45),
#     yaxis = list(title = "", tickfont = list(size = 14)),
#     margin = list(l = 60, r = 20, t = 40, b = 40),
#     font = list(family = "Arial", size = 14)
#   )
