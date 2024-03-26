#Solar
simple_PGE_solar_data <- readRDS(file = "./04_Outputs/rds/simple_PGE_solar_data.rds")

### Solar -----------------
solar_ac <- simple_PGE_solar_data %>% 
  select(app_approved_date, service_city, service_zip, service_county, system_size_ac) %>% 
  filter(service_county == "CONTRA COSTA")%>% 
  filter(year(app_approved_date) == 2023) 

# ranking of total install in 2022 by city
# Group by city and sum the system size by city
city_totals_solar <- solar_ac %>%
  group_by(service_city) %>%
  summarise(total_size_ac = sum(system_size_ac)) %>% 
  rename(city = service_city) %>% 
  mutate(city = str_to_lower(city)) %>% 
  drop_na() ### check if UNi_ccc is small

city_totals_solar_uni_ccc <- clean_city_names_uni_ccc(city_totals_solar) %>%
  group_by(city) %>%
  summarise(total_size_ac = sum(total_size_ac))
### Standardize by population -----------------
# input number of cars-------------------
population <- readRDS(file = "./04_Outputs/rds/full_ccc_census.rds") %>% 
  clean_names() %>% 
  select(city, total_pop) %>% 
  mutate(city = if_else(city == "Uni_CCC", "Uni. CCC", city)) 


#standardize ----------------
solar_city_standardized <- full_join(population, city_totals_solar_uni_ccc, by = "city") %>% 
  mutate(solar_per_pop= (total_size_ac/total_pop)) %>% 
  mutate(solar_per_pop_scaled = 100 * solar_per_pop / max(solar_per_pop))


saveRDS(solar_city_standardized, file = "./06_Reports_Rmd/solar_city_standardized.rds")

fig_multi <- plot_ly(solar_city_standardized, x = ~city, y = ~solar_per_pop_scaled, name = "Solar Score", type = "bar", showlegend = FALSE, marker = list(line = list(color = "black", width = 1))) %>%
  add_trace(y = ~total_size_ac, name = "Total Solar AC", type = "bar", visible = FALSE) %>%
  add_trace(y = ~total_pop, name = "Total Population", type = "bar", visible = FALSE) %>%
  layout( 
    updatemenus = list(
      list(
        type = "buttons",
        direction = "down",
        showactive = TRUE,
        buttons = list(
          list(method = "update",
               args = list(list(visible = c(TRUE, FALSE, FALSE))),
               label = "Stations per Vehicle"),
          list(method = "update",
               args = list(list(visible = c(FALSE, TRUE, FALSE))),
               label = "Total Stations"
          ),
          list(method = "update",
               args = list(list(visible = c(FALSE, FALSE, TRUE))),
               label = "Total Vehicles"
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
saveRDS(fig_multi, file = "./06_Reports_Rmd/fig_multi.rds")

saveWidget(widget = fig_multi, file = "test.html")








# Create plotly plot
plot_solar <- plot_ly(city_totals_solar, x = ~service_city, y = ~total_size, type = "bar")

# Set plot title and axis labels
plot_solar <- plot_solar %>% layout(title = "Total System Size by City",
                                    xaxis = list(title = "City"),
                                    yaxis = list(title = "Total System Size (AC) kW"))

# Show plot
plot_solar






## Calendar Heat map-------------

solar_ac_all_years <- simple_PGE_solar_data %>% 
  select(app_approved_date, service_city, service_zip, service_county, system_size_ac) %>% 
  filter(service_county == "CONTRA COSTA") 
# Group the data by year and month and calculate the total system size for each month
monthly_totals <- solar_ac_all_years %>%
  group_by(year = year(app_approved_date), month = month(app_approved_date)) %>%
  summarise(total_size = sum(system_size_ac))

# Create plotly plot
heat_map_plot <- plot_ly(monthly_totals, x = ~month, y = ~year, z = ~total_size, type = "heatmap")

# Set plot title and axis labels
heat_map_plot <- heat_map_plot %>% layout(title = "Total System Size by Time of Year",
                                          xaxis = list(title = "Month"),
                                          yaxis = list(title = "Year"))
# Show plot
heat_map_plot
# there doesn't appear to be any time of year pattern
