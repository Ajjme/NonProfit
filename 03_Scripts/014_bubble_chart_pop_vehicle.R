
library(readxl)
ev_sales_county <- read_excel("./02_inputs/New_ZEV_Sales_Last_updated_01-18-2023.xlsx", sheet = "County") %>% 
  clean_names() %>% 
  filter(data_year == "2022")

### still need to standardize ----------

### County model Totals --------------
ev_model <- ev_sales_county %>%
  group_by(county) %>%
  filter(county == "Contra Costa") %>% 
  ungroup() %>% 
  group_by(model) %>%
  mutate(total_sales_model = sum(number_of_vehicles))%>% 
  # Create new column with top 5 makes
  group_by(make) %>%
  summarize(total_sales_make = sum(total_sales_model)) %>%
  ungroup() %>%
  top_n(5, total_sales_make) %>%
  inner_join(ev_model, by = "make")


# Create the bubble chart
scat_zev <- plot_ly(data = ev_model, x = ~model, y = ~total_sales_model, type = "scatter", color = ~make,
        mode = "markers", marker = list(size = sqrt(ev_model$total_sales_model), sizemode = "diameter")) %>%
  # Set chart title and axis labels
  layout(title = "Total ZEV Sales by Model in Contra Costa County",
         xaxis = list(title = "", showticklabels = FALSE, showgrid = FALSE),
         yaxis = list(title = "Total Sales Model", showgrid = FALSE))


saveRDS(scat_zev, file = "./06_Reports_Rmd/scat_zev.rds")


