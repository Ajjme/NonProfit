library(readxl)
f150 <- read_excel("./02_inputs/f150.xlsx") %>% 
  clean_names() 
data_t <- t(f150)
colnames(data_t) <- as.character(data_t[1,])
data_t <- as.data.frame(data_t[-1,]) 


data_t <- data_t %>% 
  rename(year_col = Year) %>%
  mutate(year = as.numeric(year_col),
         `F150 EV` = as.numeric(`F150 EV`),
        `F150 ICE` = as.numeric(`F150 ICE`))

# Create a line graph using Plotly
line_graph <- plot_ly(data_t, x = ~year) %>%
  add_lines(y = ~`F150 ICE`, name = "F150 ICE") %>%
  add_lines(y = ~`F150 EV`, name = "F150 EV") %>%
  layout(title = "Cost of Ownership F150",
         xaxis = list(title = "Year", 
                      tickmode = "array",
                      tickfont = list(size = 14),
                      tickvals = unique(data_t$year),
                      showgrid = FALSE),
         yaxis = list(title = "Cost of Ownership",
                      tickfont = list(size = 14),
                      tickformat = "$,.0f"),
         margin = list(l = 60, r = 20, t = 40, b = 40),
         font = list(family = "Arial", size = 14),
         legend = list(x = 0, y = -0.2, 
                      orientation = "h",
                      font = list(size = 14)))

line_graph



saveRDS(line_graph, file = "./06_Reports_Rmd/line_graph.rds")
