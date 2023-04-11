#INputs-------------

simple_PGE_solar_data <- readRDS(file = "./04_Outputs/rds/simple_PGE_solar_data.rds")


### Storage ----------------------
storage_ac <- simple_PGE_solar_data %>% 
  select(app_approved_date, service_city, service_zip, service_county,
         storage_capacity_k_wh, storage_size_k_w_ac) %>% 
  filter(service_county == "CONTRA COSTA")%>% 
  filter(year(app_approved_date) == 2022)

# ranking of total install in 2022 by city
# Group by city and sum the system size by city
city_totals_storage <- storage_ac %>%
  group_by(service_city) %>%
  summarise(total_storage_capacity_k_wh = sum(storage_capacity_k_wh)) %>% 
  rename(city = service_city) %>% 
  mutate(city = str_to_lower(city)) %>% 
  drop_na() ### check if UNi_ccc is small

city_totals_storage_uni_ccc <- clean_city_names_uni_ccc(city_totals_storage) %>%
  group_by(city) %>%
  summarise(total_capacity_k_wh = sum(total_storage_capacity_k_wh))
### Standardize by population -----------------
# input number of cars-------------------
population <- readRDS(file = "./04_Outputs/rds/full_ccc_census.rds") %>% 
  clean_names() %>% 
  select(city, total_pop) %>% 
  mutate(city = if_else(city == "Uni_CCC", "Uni. CCC", city)) 


storage_city_standardized <- full_join(population, city_totals_storage_uni_ccc, by = "city") %>% 
  mutate(storage_per_pop= (total_capacity_k_wh/total_pop)) %>% 
  mutate(storage_per_pop_scaled = 100 * storage_per_pop / max(storage_per_pop))

###plots
saveRDS(storage_city_standardized, file = "./06_Reports_Rmd/storage_city_standardized.rds")

fig_storage <- plot_ly(storage_city_standardized, x = ~city, y = ~storage_per_pop_scaled, name = "Storage Score", type = "bar", showlegend = FALSE, marker = list(line = list(color = "black", width = 1))) %>%
  add_trace(y = ~total_capacity_k_wh, name = "Total Storage kWh", type = "bar", visible = FALSE) %>%
  layout( 
    updatemenus = list(
      list(
        type = "buttons",
        direction = "down",
        showactive = TRUE,
        buttons = list(
          list(method = "update",
               args = list(list(visible = c(TRUE, FALSE))),
               label = "Storage Score"),
          list(method = "update",
               args = list(list(visible = c(FALSE, TRUE))),
               label = "Total Storage kWh"
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
saveRDS(fig_storage, file = "./06_Reports_Rmd/fig_storage.rds")





















# Create plotly plot
plot_storage <- plot_ly(city_totals_storage, x = ~service_city, y = ~total_size, type = "bar")

# Set plot title and axis labels
plot_storage <- plot_storage %>% layout(title = "Total Storage Size by City",
                                        xaxis = list(title = "City"),
                                        yaxis = list(title = "Total Storage Size (AC) kW"))

# Show plot
plot_storage