
source("./03_Scripts/000_init.R")
### Inputs------------------
#may have to change downloaded name
buses_ccc <- read_xlsx("./02_inputs/School_Bus_and_School_Bus_Charger_Last_updated_01-30-2023.xlsx", sheet= "School Bus and Charger") %>% 
  clean_names() %>% 
  filter(county == "Contra Costa")
### adding missing cities -----------
cities <- c("Antioch", "Brentwood", "Clayton", "Concord", "Danville", "El Cerrito", "Hercules", "Lafayette", "Martinez", "Moraga", "Oakley", "Orinda", "Pinole", "Pittsburg", "Pleasant Hill", "Richmond", "San Pablo", "San Ramon", "Walnut Creek", "Uni. CCC")

# Create a data frame with the cities, funding amount, and number of buses
df <- data.frame(city = cities, funding_amount = 0, number_of_buses = 0)

buses_ccc <- bind_rows(buses_ccc, df)
saveRDS(buses_ccc, file = "./06_Reports_Rmd/buses_ccc.rds")
### Plot one layer-----------------
plotly_obj_buses <- ggplot(buses_ccc, aes(x = city, y = number_of_buses, fill = infrastructure_funding_amount)) +
  geom_col(position = "dodge", color = "black") +
  labs(title = "Electric Buses from CEC School Bus Replacement Program ", y = "Number of Buses", fill = "Funding Amount") +
  theme(axis.title.x = element_text(hjust = 1),
        axis.title.y = element_text(hjust = 1),
        panel.grid.major.y = element_line(color = "gray"),
        panel.background = element_rect(fill = "white"),
        axis.text.x = element_text(angle = 45, hjust = 1))

saveRDS(plotly_obj_buses, file = "./06_Reports_Rmd/plotly_obj_buses.rds")