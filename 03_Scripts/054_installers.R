simple_PGE_solar_data <- readRDS(file = "./04_Outputs/rds/simple_PGE_solar_data.rds")

### Costs--------------------------------------------------------
installer_name_system <- simple_PGE_solar_data %>% 
  select(app_approved_date, service_city, service_zip, service_county, installer_name, contains_2022) %>% 
  filter(service_county == "CONTRA COSTA")%>% 
  filter(contains_2022 == TRUE) 

## We need to clean installer name

# Count the number of installations completed by each installer name in each service city
installer_counts <- installer_name_system %>%
  group_by(installer_name, service_city) %>%
  count() %>%
  ungroup() %>%
  arrange(desc(n)) %>%
  group_by(service_city) %>%
  top_n(5, n)  # Keep only the top five installers based on number of installations

# Create an interactive bar chart of installer counts by service city

#Make this into a bubble chart
#Maybe just do for the whole county
plot <- plot_ly(installer_counts, x = ~service_city, y = ~n, color = ~installer_name, type = "bar")

# Set plot title and axis labels
plot <- plot %>% layout(title = "Number of Installations by Installer and Service City",
                        xaxis = list(title = "Service City"),
                        yaxis = list(title = "Number of Installations"))

plot <- plot %>% layout(
  updatemenus = list(
    list(
      active = 0,
      buttons = lapply(unique(installer_counts$service_city), function(city){
        list(
          label = city,
          method = "update",
          args = list(list(x = list(~service_city == city)))
        )
      })
    )
  )
)
# Show 
plot




