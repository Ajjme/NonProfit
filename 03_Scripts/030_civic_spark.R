#Civic Spark

# I am just going to count and work off our old data
source("./03_Scripts/000_init.R")
### Inputs------------------

#update by hand
civic_data <- read_xlsx("./02_inputs/ContraCosta CivicSpark Projects 2022.xlsx") %>% 
  clean_names()

# need to match and clean city names 
# probably best to do that by hand


# Scoring 50 points for having prior 
# 50 points for having this year

civic_plot <- civic_data %>%
  plot_ly(x = ~city, y = ~total_number, color = ~final_score, type = "bar") %>%
  layout(xaxis = list(title = "City", showgrid = FALSE),
         yaxis = list(title = "Total Number of Fellows", showgrid = FALSE),
         title = "CivicSpark Fellow Placement by City",
         barmode = "stack",
         legend = list(x = 0.05, y = 1.1),
         margin = list(l = 100, r = 100, t = 100, b = 100),
         plot_bgcolor = "#F4F4F4",
         paper_bgcolor = "#F4F4F4",
         font = list(family = "Helvetica Neue"))

civic_plot 

#Bar graph of number of fellows each city has had
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
