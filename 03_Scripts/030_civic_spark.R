#Civic Spark

# I am just going to count and work off our old data
source("./03_Scripts/000_init.R")
### Inputs------------------

#update by hand
civic_data <- read_xlsx("./02_inputs/ContraCosta CivicSpark Projects 2022.xlsx") %>% 
  clean_names() %>% 
  mutate(city = str_to_lower(city)) %>% 
  clean_city_names_uni_ccc() %>% 
  mutate(civic_score = final_score) %>% 
  #select(-final_score) %>% 
  distinct(city, .keep_all = TRUE) %>% 
  mutate(civic_score = case_when(str_detect(city, "Uni. CCC") ~ as.numeric("100"),
                                 TRUE ~ civic_score)) %>% 
  mutate(this_year = case_when(str_detect(civic_spark_fellow_requested_for_22_23, "Yes") ~ as.numeric("1"),
                                 TRUE ~ as.numeric("0"))) 



# Scoring 50 points for having prior 
# 50 points for having this year

saveRDS(civic_data, file = "./04_Outputs/rds/civic_data.rds")
saveRDS(civic_data, file = "./06_Reports_Rmd/civic_data.rds")
#Bar graph of number of fellows each city has had
#need to fix the colors

civic_plot <- civic_data %>%
  plot_ly(x = ~city, y = ~total_number, color = ~final_score, colors = c("#F7F7F7", "#FFD166", "#06D6A0"), 
          type = "bar") %>%
  layout(xaxis = list(title = "City", showgrid = FALSE),
         yaxis = list(title = "Total Number of Fellows", showgrid = FALSE),
         title = "CivicSpark Fellow Placement by City",
         barmode = "stack",
         margin = list(l = 100, r = 100, t = 100, b = 100),
         plot_bgcolor = "#F4F4F4",
         paper_bgcolor = "#F4F4F4",
         font = list(family = "Helvetica Neue"),
         colorbar = list(title = "Final Score", titleside = "right", 
                         tickvals = c(0, 50, 100), ticktext = c("0", "50", "100"),
                         len = 0.5, y = 0.5))

civic_plot
