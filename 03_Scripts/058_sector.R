

simple_PGE_solar_data <- readRDS(file = "./06_Reports_Rmd/city_solar_data_standardized.rds")
### pulling out Res
sector_solar_non_res <- simple_PGE_solar_data %>% 
  select(app_approved_date, city, service_zip, service_county, technology_type,
         customer_sector) %>% 
  filter(technology_type == "Solar PV",
         customer_sector != "Residential") %>% 
  rename(`Customer Segement` = customer_sector,
         City = city)


non_res_solar_sectors <- ggplot(sector_solar_non_res, aes(x = City, fill = `Customer Segement`)) + 
  geom_bar() + 
  labs(title = "", 
       x = "Service City", 
       y = "Count") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(panel.grid = element_blank())

# Convert the ggplot2 chart to an interactive plotly chart
non_res_solar_sectors <- ggplotly(non_res_solar_sectors)
saveRDS(non_res_solar_sectors, file = "./06_Reports_Rmd/058_non_res_solar_sectors.rds")

### Archive

# 
# ### sector ----------------------
# 
# ## Storage ----------------------------------------
# sector_storage <- simple_PGE_solar_data %>%
#   select(app_approved_date, service_city, service_zip, service_county, technology_type,
#          customer_sector, storage_capacity_k_wh, contains_2022) %>%
#   mutate(storage_capacity_k_wh = as.numeric(storage_capacity_k_wh)) %>%
#   filter(service_county == "CONTRA COSTA") %>%
#   filter(contains_2022 == TRUE,
#          str_detect(technology_type, "torage")) # technology can be for multiple
# 
# # Create a bar chart using ggplot2
# ### Data incomplete
# 
# fig_multi <-
#   plot_ly(
#     sector_storage,
#     x = ~ service_city,
#     y = ~  storage_capacity_k_wh,
#     name = "Storage Sector",
#     type = "bar",
#     showlegend = FALSE,
#     marker = list(line = list(
#       color = "black", width = 1
#     ))
#   )  %>% layout(
#     xaxis = list(title = "City",
#                  tickfont = list(size = 14),
#                  tickangle = 45),
#     yaxis = list(title = "", tickfont = list(size = 14)),
#     margin = list(l = 60,
#                   r = 20,
#                   t = 40,
#                   b = 40),
#     font = list(family = "Arial", size = 14)
#   )
# 
# ### Solar------------------------
# sector_solar <- simple_PGE_solar_data %>%
#   select(app_approved_date, service_city, service_zip, service_county, technology_type,
#          customer_sector, contains_2022) %>%
#   filter(service_county == "CONTRA COSTA") %>%
#   filter(contains_2022 == TRUE,
#          technology_type == "Solar PV")
# 
# ggplot(sector_solar, aes(x = service_city, fill = customer_sector)) +
#   geom_bar() +
#   labs(title = "Entries by Customer Sector in Each Service City",
#        x = "Service City",
#        y = "Count") +
#   theme_bw() +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1))
# 
# # Convert the ggplot2 chart to an interactive plotly chart
# ggplotly()
