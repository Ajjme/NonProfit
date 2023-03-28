

source("./03_Scripts/000_init.R")

source("./03_Scripts/020_MCE_processing.R")


# Define the list of data frames
df_list <- list(marin_mce_df, napa_mce_df, ccc_mce_df, solano_mce_df)

# Define the colors
colors <- c("#3498db", "#2ecc71")

# Loop through each data frame and create a plot
for (df in df_list) {
  plot <- plot_ly(df, x = ~community, y = ~participation_rate, type = 'bar', name = 'Participation Rate',
                  marker = list(color = colors[1])) %>% 
    add_trace(y = ~deep_green_rate, name = 'Deep Green Rate', marker = list(color = colors[2])) %>% 
    layout(title = 'Community Participation and Deep Green Rates',
           xaxis = list(title = 'Community', showgrid = FALSE, showline = FALSE),
           yaxis = list(title = 'Rate (%)', showgrid = FALSE, showline = FALSE, 
                        tickmode = 'linear', dtick = 5)) %>% 
    layout(legend = list(x = 0.5, y = -0.2, orientation = 'h', bgcolor = '#f5f5f5'),
           plot_bgcolor = '#fff',
           paper_bgcolor = '#fff',
           bargap = 0.2)
  
#puts it in your main directory I cant fix it
  
  # Save the plot as an HTML file with the file path and name of the data frame
  htmlwidgets::saveWidget(ggplotly(plot), paste0("plot_", df$community[1], ".html"))
}




### Archive -------------
# Set custom color palette
# colors <- c("#3498db", "#2ecc71")
# 
# 
# plot2 <- plot_ly(ccc_mce_df, x = ~community, y = ~participation_rate, type = 'bar', name = 'Participation Rate',
#                  marker = list(color = colors[1])) %>% 
#   add_trace(y = ~deep_green_rate, name = 'Deep Green Rate', marker = list(color = colors[2])) %>% 
#   layout(title = 'Community Participation and Deep Green Rates',
#          xaxis = list(title = 'Community', showgrid = FALSE, showline = FALSE),
#          yaxis = list(title = list(text='Rate (%)', standoff = 25), showgrid = FALSE, showline = FALSE, tickmode = 'linear', dtick = 5)) %>% 
#   layout(legend = list(x = 0.3, y = -0.4, orientation = 'h', bgcolor = '#f5f5f5'),
#          plot_bgcolor = '#fff',
#          paper_bgcolor = '#fff',
#          bargap = 0.2)
# 
# ggplotly(plot2)