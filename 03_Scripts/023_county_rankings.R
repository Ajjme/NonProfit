ccc_mce_df <- readRDS( file = "./04_Outputs/rds/ccc_mce_df.rds") %>% 
  mutate(County = "Contra Costa")
marin_mce_df <- readRDS( file = "./04_Outputs/rds/marin_mce_df.rds")%>% 
  mutate(County = "Marin")
napa_mce_df <- readRDS( file = "./04_Outputs/rds/napa_mce_df.rds")%>% 
  mutate(County = "Napa")
solano_mce_df <- readRDS( file = "./04_Outputs/rds/solano_mce_df.rds")%>% 
  mutate(County = "Solano")

full_mce_county <- bind_rows(ccc_mce_df, marin_mce_df, napa_mce_df, solano_mce_df)
full_mce_county$participation_rate <- as.numeric(gsub("[ %]", "", full_mce_county$participation_rate))
full_mce_county$deep_green_rate <- as.numeric(gsub("[ %]", "", full_mce_county$deep_green_rate))

full_mce_county_sum <- full_mce_county %>% 
  group_by(County) %>% 
  summarise(average_participation = mean(participation_rate),
            average_deep_green = mean(deep_green_rate))

fig_multi <- plot_ly(full_mce_county_sum, x = ~County, y = ~average_participation, name = "Participation Rate", type = "bar", showlegend = FALSE, marker =   list(line = list(color = "black", width = 1))) %>%

  layout( 
    xaxis = list(title = "City", tickfont = list(size = 14), tickangle = 45),
    yaxis = list(title = "Average Participation Rate", tickfont = list(size = 14)),
    margin = list(l = 60, r = 20, t = 40, b = 40),
    font = list(family = "Arial", size = 14)
  )


# save the Plotly object to an RDS file
saveRDS(fig_multi, file = "./06_Reports_Rmd/023_county_part_averages.rds")

fig_multi_deep <- plot_ly(full_mce_county_sum, x = ~County, y = ~average_deep_green, name = "Participation Rate", type = "bar", showlegend = FALSE, marker = list(color = "forestgreen",line = list(color = "black", width = 1))) %>%
  
  layout( 
    xaxis = list(title = "City", tickfont = list(size = 14), tickangle = 45),
    yaxis = list(title = "Average Deep Green Rate", tickfont = list(size = 14)),
    margin = list(l = 60, r = 20, t = 40, b = 40),
    font = list(family = "Arial", size = 14)
  )
saveRDS(fig_multi_deep, file = "./06_Reports_Rmd/023_county_deep_averages.rds")
