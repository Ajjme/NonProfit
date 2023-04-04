#individual bar graphs
Total_Scores_Data <- read.csv("Total_Scores_Data.csv", skip = 1, header = T)

Total_Scores <- Total_Scores_Data %>% select(Climate.action.plan.Score, City, Green.House.Gas.Inventory.Score , Climate.Emergency.Score 
                                             , General.Plan.with.Climate.Element.Score, Solar.MW.Installed.Score , EV.Charging.Stations.Score 
                                             , MCE.Score, Electrification.Score, Green.Business.Score)
Scores_list <- list("Climate.action.plan.Score", "City", "Green.House.Gas.Inventory.Score" , "Climate.Emergency.Score" 
                , "General.Plan.with.Climate.Element.Score", "Solar.MW.Installed.Score" , "EV.Charging.Stations.Score" 
                , "MCE.Score", "Electrification.Score", "Green.Business.Score")

fig <- plot_ly(type = 'bar'#,
  #                hoverinfo = 'x+y')%>%
  # layout(title = NULL,
  #        # xaxis = list(title ="", type = 'categorical', nticks = 10, categoryorder = 'trace'),
  #        # yaxis = list(title = ""),
  #        # barmode = 'stack',
  #        # paper_bgcolor = white,
  #        # plot_bgcolor = white,
  #        # font = font_regular,
  #        margin = list(b = 100),
  #        showlegend = TRUE
  )

for (i in 1:10){
  client <- Scores_list[i]
  fig <- plot_ly(Total_Scores,
    x = ~City,
    y =  ~client,
    name = client,
    type = "bar"
  )
}


fig

chart <- plot_ly(type = 'bar',
                 hoverinfo = 'x+y')%>%
  layout(title = NULL,
         xaxis = list(title ="", type = 'categorical', nticks = 10, categoryorder = 'trace'),
         yaxis = list(title = ""),
         barmode = 'stack',
         # paper_bgcolor = white,
         # plot_bgcolor = white,
         # font = font_regular,
         margin = list(b = 100),
         showlegend = TRUE)

#then use the loop to add traces.
for (i in 1:10){
  client <- Scores_list[i,]
  chart <- add_trace(chart,
                     x = ~Total_Scores$City,
                     y = ~Total_Scores[[client]],
                     name = paste0("",
                                     sum(data[[client]]), ' (', round(((100/total)*sum(data[[client]])), 1),'%): ', gsub("_", " ", client)), marker = list(color = pal[i]))
}

return(chart)