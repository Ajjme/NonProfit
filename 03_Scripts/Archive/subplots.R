Total_Scores_Data <- read.csv("Total_Scores_Data.csv", skip = 1, header = T)

Total_Scores <- Total_Scores_Data %>% select(Climate.action.plan.Score, City, Green.House.Gas.Inventory.Score , Climate.Emergency.Score 
                                             , General.Plan.with.Climate.Element.Score, Solar.MW.Installed.Score , EV.Charging.Stations.Score 
                                             , MCE.Score, Electrification.Score, Green.Business.Score)


fig1 <- plot_ly(Total_Scores, x = ~City, y = ~Climate.action.plan.Score, type = 'bar') 
fig2 <- plot_ly(Total_Scores, x = ~City, y = ~Green.House.Gas.Inventory.Score, type = 'bar') 
fig3 <- plot_ly(Total_Scores, x = ~City, y = ~Climate.Emergency.Score, type = 'bar') 
fig4 <- plot_ly(Total_Scores, x = ~City, y = ~General.Plan.with.Climate.Element.Score, type = 'bar')
fig5 <- plot_ly(Total_Scores, x = ~City, y = ~Solar.MW.Installed.Score, type = 'bar')
fig6 <- plot_ly(Total_Scores, x = ~City, y = ~EV.Charging.Stations.Score, type = 'bar')
fig <- subplot(fig1, fig2, fig3, fig4, fig5, fig6, nrows = 3) %>% 
  layout(title = list(text = "Breakout"),
         plot_bgcolor='#e5ecf6', 
         xaxis = list( 
           zerolinecolor = '#ffff', 
           zerolinewidth = 2, 
           gridcolor = 'ffff'), 
         yaxis = list( 
           zerolinecolor = '#ffff', 
           zerolinewidth = 2, 
           gridcolor = 'ffff')) 
fig