

source("./03_Scripts/000_init.R")

source("./03_Scripts/020_MCE_processing.R")
# Full score needs to be added

ccc_mce_df_score <- readRDS( file = "./04_Outputs/rds/026_ccc_mce_df_score.rds")
#multi layer MCE plot COntra Costa
fig_multi <- plot_ly(ccc_mce_df_score, x = ~city, y = ~mce_score, name = "MCE Score", type = "bar", showlegend = FALSE, marker = list(line = list(color = "black", width = 1))) %>%
  add_trace(y = ~participation_rate, name = "Participation Rate", type = "bar", visible = FALSE) %>%
  add_trace(y = ~deep_green_rate, name = "Deep Green Rate", type = "bar", visible = FALSE) %>%
  layout( 
    updatemenus = list(
      list(
        type = "buttons",
        direction = "down",
        showactive = TRUE,
        buttons = list(
          list(method = "update",
               args = list(list(visible = c(TRUE, FALSE, FALSE))),
               label = "MCE Score"),
          list(method = "update",
               args = list(list(visible = c(FALSE, TRUE, FALSE))),
               label = "Participation Rate"
          ),
          list(method = "update",
               args = list(list(visible = c(FALSE, FALSE, TRUE))),
               label = "Deep Green Rate"
          )
        ),
        pad = list(r = 15, t = 0, b = 0, l = 0)
      )
    ),
    xaxis = list(title = "City", tickfont = list(size = 14), tickangle = 45),
    yaxis = list(title = "", tickfont = list(size = 14)),
    margin = list(l = 60, r = 20, t = 40, b = 40),
    font = list(family = "Arial", size = 14)
  )


# save the Plotly object to an RDS file
saveRDS(fig_multi, file = "./06_Reports_Rmd/021_MCE_score.rds")



# Define the list of data frames
df_list <- list(marin_mce_df, napa_mce_df, ccc_mce_df, solano_mce_df)

# Define the colors
colors <- c("#3498db", "#2ecc71")

# Loop through each data frame and create a plot
save_plots_to_rds <- function(df_list) {
  # Iterate over the data frames in df_list
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
    
    # Generate the file name based on the community name
    file_name <- paste0("plot_", gsub(" ", "_", df$community[1]), ".rds")
    
    # Save the plot as an RDS file
    saveRDS(plot, file_name)
  }
}

# Create a list of data frames
df_list <- list(marin_mce_df, napa_mce_df, ccc_mce_df, solano_mce_df) 

# Call the function to save plots as RDS files
save_plots_to_rds(df_list)


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