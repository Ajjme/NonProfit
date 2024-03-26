simple_PGE_solar_data <- readRDS(file = "./04_Outputs/rds/simple_PGE_solar_data.rds")


### 3rd party ----------------------
three_rd_party <- simple_PGE_solar_data %>% 
  select(app_approved_date, city=service_city, service_zip, service_county,
         third_party_owned, third_party_name, total_system_cost) %>% 
  filter(third_party_owned == "Yes",
         service_county == "CONTRA COSTA")
  

# Count the total system cost by third party name and service city
third_party_costs <- three_rd_party %>%
  group_by(city, third_party_name) %>%
  summarize(total_cost = sum(total_system_cost)) %>%
  ungroup()
### Third party cleaning function ----------
third_party_costs_clean <- third_party_costs %>% 
  mutate(third_party_name = str_to_lower(third_party_name)) %>% 
  mutate(third_party_name =
         case_when(
           str_detect(third_party_name, "sunr") ~ "SunRun Inc",
           str_detect(third_party_name, "surn") ~ "SunRun Inc",
           str_detect(third_party_name, "sun r") ~ "SunRun Inc",
           str_detect(third_party_name, "vivin") ~ "Vivint Solar Developer",
           str_detect(third_party_name, "tesla") ~ "Tesla Energy Operations",
           str_detect(third_party_name, "solar star") ~ "Solar Star Co",
           str_detect(third_party_name, "sunp") ~ "SunPower",
           str_detect(third_party_name, "lenn") ~ "Lennar Homes",
           str_detect(third_party_name, "sunn") ~ "Sunnova",
           str_detect(third_party_name, "kuu") ~ "Kuubix Global",
           str_detect(third_party_name, "ever") ~ "Everbright",
           str_detect(third_party_name, "v3") ~ "V3 Electric",
           str_detect(third_party_name, "powur") ~ "Puwur PBC",
         TRUE ~ third_party_name)) %>% 
  mutate(third_party_name = str_to_title(third_party_name))
# Keep only the top five third party names based on total system cost in each service city
top_third_parties <- third_party_costs_clean %>%
  filter(total_cost != 0) %>% 
  group_by(city, third_party_name) %>%
  summarise(third_party_own_total = sum(total_cost)) %>% # I want to change to counts
  top_n(3, third_party_own_total) 

# Create an interactive bar chart of total system cost by third party name and service city
plot_third <-
  plot_ly(
    top_third_parties,
    x = ~ city,
    y = ~ third_party_own_total,
    color = ~ third_party_name,
    type = "bar"
  )

# Set plot title and axis labels
plot_third <- plot_third %>% layout(title = "",
                        xaxis = list(title = "Third Party Name"),
                        yaxis = list(title = "Total System Cost ($)"))
# Move the legend to the bottom
plot_third <- plot_third %>% layout(legend = list(orientation = "h", x = 0, y = -0.5))
  

# Add dropdown menu to filter by service city

# Show plot
plot_third


saveRDS(plot_third, file = "./06_Reports_Rmd/plot_third.rds")
