# Load necessary libraries
library(tidyverse)
library(plotly)

# Load data from California Energy Commission's website
url <- "https://www.energy.ca.gov/data-reports/energy-almanac/california-electricity-data/electricity-consumption-data"
energy_data <- read_csv(url)

# Filter data for California cities only
ca_energy_data <- energy_data %>% 
  filter(State == "CA")

# Group data by city and calculate total consumption
city_energy_data <- ca_energy_data %>% 
  group_by(City) %>% 
  summarise(Total_Consumption = sum(Consumption))

# Create interactive bar chart using Plotly
plot_ly(city_energy_data, x = ~Total_Consumption, y = ~City, type = "bar",
        orientation = 'h', text = ~paste("Total Consumption: ", 
                                         scales::comma(Total_Consumption), "MWh"),
        hovertemplate = "%{y}: %{x:.2f} MWh<br>%{text}") %>%
  layout(title = "Energy Consumption by City in California",
         xaxis = list(title = "Total Energy Consumption (MWh)"),
         yaxis = list(title = "City"))