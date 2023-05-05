
source("./03_Scripts/000_init.R")

###Inputs---------------------
Total_Scores_Data <- read.csv("./02_inputs/Total_Scores_Data - Sheet1.csv", skip = 1, header = T) 

Total_Scores <- Total_Scores_Data %>% select( City, MCE.Score, Electrification.Score, CivicSpark.Score, Climate.Emergency.Score) 
### Bar graph ------------------

Stacked_bar_graph <- plot_ly(Total_Scores, x = ~City, y = ~CivicSpark.Score, type = 'bar', name = 'Civic Spark',marker = list(color = 'grey')) %>%
  # add_trace(y = ~Green.House.Gas.Inventory.Score, name = 'Green House Gas Inventory') %>%
  # add_trace(y = ~Climate.Emergency.Score , name = 'Climate Emergency') %>%
  # add_trace(y = ~General.Plan.with.Climate.Element.Score, name = 'General Plan with Climate Element') %>%
  add_trace(y = ~Solar.MW.Installed.Score, name = 'Solar MW Installed',marker = list(color = 'lightgrey')) %>%
  add_trace(y = ~EV.Charging.Stations.Score, name = 'EV Charging Stations',marker = list(color = 'green')) %>%
  add_trace(y = ~MCE.Score, name = 'MCE',marker = list(color = 'darkgreen')) %>%
  add_trace(y = ~Climate.Emergency.Score, name = 'Climate Emergency Passed', marker = list(color = 'yellowgreen'))%>%
  add_trace(y = ~Electrification.Score, name = 'Electrification',marker = list(color = 'yellow')) %>%
  #add_trace(y = ~Climate.Emergency.Score, name = 'Climate Emergency Passed', marker = list(color = 'lightblue')) %>%
  layout(xaxis = list(categoryorder = "total descending"))%>%
           layout(yaxis = list(title = 'Score'), barmode = 'stack', legend = list(orientation = 'h', yanchor = "center", y = 1.2))



#Output-----------------------------
Stacked_bar_graph
library(htmlwidgets)
saveWidget(Stacked_bar_graph, file="Stacked_bar_graph_Ordered_Led_Top.html")
