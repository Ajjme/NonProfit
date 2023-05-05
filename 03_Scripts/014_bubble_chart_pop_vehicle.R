
library(readxl)
ev_sales_county <- read_excel("./02_inputs/New_ZEV_Sales_Last_updated_01-18-2023.xlsx", sheet = "County") %>% 
  clean_names() %>% 
  filter(data_year == "2022")

### still need to standardize ----------


ev_model_full <- ev_sales_county %>%
  group_by(county) %>%
  filter(county == "Contra Costa") %>% 
  ungroup() %>% 
  group_by(model) %>%
  mutate(total_sales_model = sum(number_of_vehicles))%>% 
  group_by(make) %>%
  summarize(total_sales_make = sum(total_sales_model)) %>%
  ungroup() %>%
  arrange(desc(total_sales_make)) %>%
  mutate(make_top5 = ifelse(row_number() <= 5, as.character(make), "Other")) %>%
  group_by(make_top5) %>%
  summarize(total_sales_top5 = sum(total_sales_make)) %>%
  ungroup()

# Select the top 5 makes
top_makes <- ev_model_full %>% filter(make_top5 != "Other")

# Select the rest of the makes not in the top 5
other_makes <- ev_model_full %>% filter(make_top5 == "Other") %>% select(-make_top5)

# Combine the top 5 makes and the rest of the makes
ev_model_full <- bind_rows(top_makes, anti_join(other_makes, top_makes, by = "total_sales_top5"))
ev_model_full %>% mutate(make_top5 = if_else(is.na(make_top5), "all_other", make_top5,  "all_other"))
# View the makes and their total sales
ev_model_full
### County model Totals --------------


# Create the bubble chart
scat_zev <- plot_ly(data = ev_model_full, x = ~make_top5, y = ~total_sales_top5, type = "scatter", color = ~make_top5,
        mode = "markers", marker = list(size = sqrt(ev_model$total_sales_model), sizemode = "diameter")) %>%
  # Set chart title and axis labels
  layout(title = "Total ZEV Sales by Model in Contra Costa County",
         xaxis = list(title = "Model", showticklabels = FALSE, showgrid = FALSE),
         yaxis = list(title = "Total Sales Model", showgrid = FALSE))

saveRDS(scat_zev, file = "./06_Reports_Rmd/scat_zev_v2.rds")

#saveRDS(scat_zev, file = "./06_Reports_Rmd/scat_zev.rds")




### Archive -----------------
ev_model <- ev_sales_county %>%
  group_by(county) %>%
  filter(county == "Contra Costa") %>% 
  ungroup() %>% 
  group_by(model) %>%
  mutate(total_sales_model = sum(number_of_vehicles))

ev_model_full_all <- ev_sales_county %>%
  group_by(county) %>%
  filter(county == "Contra Costa") %>% 
  ungroup() %>% 
  group_by(model) %>%
  mutate(total_sales_model = sum(number_of_vehicles))%>% 
  # Create new column with top 5 makes
  group_by(make) %>%
  summarize(total_sales_make = sum(total_sales_model)) %>%
  ungroup()%>%
  inner_join(ev_model, by = "make")

ev_model_full <- ev_sales_county %>%
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
###
ev_model_other <- anti_join(ev_model_full_all, ev_model_full_all)

ev_model_full <- ev_sales_county %>%
  group_by(county) %>%
  filter(county == "Contra Costa") %>% 
  ungroup() %>% 
  group_by(model) %>%
  mutate(total_sales_model = sum(number_of_vehicles))%>% 
  group_by(make) %>%
  summarize(total_sales_make = sum(total_sales_model)) %>%
  ungroup() %>%
  arrange(desc(total_sales_make)) %>%
  mutate(make_top5 = ifelse(row_number() <= 5, as.character(make), "Other")) %>%
  group_by(make_top5) %>%
  summarize(total_sales_top5 = sum(total_sales_make)) %>%
  ungroup()

# Select the top 5 makes
top_makes <- ev_model_full %>% filter(make_top5 != "Other")

# Select the rest of the makes not in the top 5
other_makes <- ev_model_full %>% filter(make_top5 == "Other") %>% select(-make_top5)

# Combine the top 5 makes and the rest of the makes
ev_model_full <- bind_rows(top_makes, anti_join(other_makes, top_makes, by = "total_sales_top5"))
ev_model_full %>% mutate(make_top5 = if_else(is.na(make_top5), "all_other", make_top5,  "all_other"))
# View the makes and their total sales
ev_model_full