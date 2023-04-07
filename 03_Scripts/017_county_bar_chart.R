### County -----------------

library(readxl)
zev_sales_county <- read_excel("./02_inputs/New_ZEV_Sales_Last_updated_01-18-2023.xlsx", sheet = "County") %>% 
  clean_names()

### still need to stanardize ----------

### County bar graph------------- Totals --------------
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
