### County -----------------

library(readxl)
zev_sales_county <- read_excel("./02_inputs/New_ZEV_Sales_Last_updated_01-18-2023.xlsx", sheet = "County") %>% 
  clean_names()

### still need to standardize ----------
### do by population so we can copy it over to the electricians 


### County bar graph------------- Totals --------------
zev_sales_county <- zev_sales_county %>%
  group_by(county) %>%
  summarise(total_sales = sum(number_of_vehicles))
zev_plot <- plot_ly(zev_sales_county, x = ~county, y = ~total_sales, type = "bar",
          marker = list(color = "#636EFA")) %>%
  layout(xaxis = list(title = "County", showgrid = FALSE),
         yaxis = list(title = "Total Number of Vehicles", showgrid = FALSE),
         title = "Total Zero-Emission Vehicle Sales by County",
         margin = list(l = 100, r = 100, t = 100, b = 100),
         plot_bgcolor = "#FFFFFF",
         paper_bgcolor = "#FFFFFF",
         font = list(family = "Helvetica Neue"))

zev_plot
saveRDS(zev_plot, file = "./06_Reports_Rmd/zev_plot.rds")

