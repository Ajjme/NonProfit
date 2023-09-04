
source("./03_Scripts/000_init.R")

###Inputs---------------------
#EVs
scores_ev <- readRDS( file = "./06_Reports_Rmd/scores_ev.rds")
#Solar
solar_city_standardized <- readRDS( file = "./06_Reports_Rmd/solar_city_standardized.rds")
#MCE_CCC
ccc_mce_df_score <- readRDS(file = "./04_Outputs/rds/ccc_mce_df_score.rds") 
# Civic Spark
civic_data <- readRDS(file = "./04_Outputs/rds/civic_data.rds")
# Electrification
electrification_data <- readRDS(file = "./04_Outputs/rds/electrification_data.rds")
#Climate Emergency 
Total_Scores_Data <- read.csv("./02_inputs/Total_Scores_Data_2023.csv") %>% 
  clean_names() %>% 
  mutate(city = str_to_lower(city)) %>% 
  clean_city_names_uni_ccc() %>% 
  select(city, climate_emergency_score)

### Joining----------------------
ev_and_solar <- full_join(scores_ev, solar_city_standardized, by ="city")
ev_and_solar_and_mce  <- full_join(ccc_mce_df_score, ev_and_solar, by ="city")
ev_and_solar_and_mce_and_civic  <- full_join(ev_and_solar_and_mce, civic_data , by ="city")
ev_and_solar_and_mce_and_civic_electrification  <- full_join(ev_and_solar_and_mce_and_civic, electrification_data , by ="city")
all_scores <-  full_join(ev_and_solar_and_mce_and_civic_electrification, Total_Scores_Data, by ="city") %>% 
  select(city, matches("(scaled|score)")) %>% 
  mutate_if(is.numeric, round, digits = 0)

df_city_lat_long <- readRDS( file = "./04_Outputs/rds/df_city_lat_long.rds") %>% 
  clean_names()

all_scores_geo <- full_join(df_city_lat_long, all_scores, by ="city")
saveRDS(all_scores_geo, file = "./04_Outputs/rds/all_scores_geo.rds")
### Lat and log ------------------


#Output-----------------------------

library(htmlwidgets)
#saveWidget(plotly_obj_roll_up, file="Stacked_bar_graph_2023.html")

# load necessary packages
library(ggplot2)
library(plotly)

# set font styles
font_main <- "Oxygen"
font_title <- "Lato"
font_secondary <- "Averia Serif Libre"

# set theme options
my_theme <- theme(
  plot.title = element_text(family = font_main, size = 24, color = "black", face = "bold"),
  axis.title = element_text(family = font_title, size = 18, color = "black", face = "bold"),
  axis.text = element_text(family = font_secondary, size = 14, color = "black"),
  legend.text = element_text(family = font_secondary, size = 16, color = "black", face = "bold"),
  legend.title = element_blank(),
  legend.position = "bottom",
  panel.grid.minor = element_blank(),
  panel.grid.major = element_blank(),
  panel.background = element_blank(),
  plot.background = element_blank()
)


generateHoverTemplate <- function(name) {
  paste0("<b>", name, "</b><br><b>%{y}</b><extra></extra><br><b>%{x}</b><extra></extra>")
}

# Update the plotly code
plotly_obj_roll_up_final <- all_scores %>%
  plot_ly(x = ~city, type = "bar", y = ~chargers_per_total_vehicle_scaled, name = "Chargers per Vehicle",
            marker = list(color = "khaki", line = list(color = "black", width = 1)),
            hovertemplate = generateHoverTemplate("Chargers per Vehicle Score")) %>%
  add_trace(y = ~solar_per_pop_scaled, name = "Solar MW Installed",
            marker = list(color = "yellow", line = list(color = "black", width = 1)),
            hovertemplate = generateHoverTemplate("Solar MW Installed Score")) %>%
  add_trace(y = ~civic_score, name = "Civic Spark",
            marker = list(color = "grey", line = list(color = "black", width = 1)),
            hovertemplate = generateHoverTemplate("Civic Spark Score")) %>%
  add_trace(y = ~electrification_score, name = "Electrification Ordinance",
            marker = list(color = "yellowgreen", line = list(color = "black", width = 1)),
            hovertemplate = generateHoverTemplate("Electrification Ordinance Score")) %>%
  add_trace(y = ~climate_emergency_score, name = "Declaration of Climate Emergency",
            marker = list(color = "008000", line = list(color = "black", width = 1)),
            hovertemplate = generateHoverTemplate("Declaration of Climate Emergency Score")) %>%
  add_trace(y = ~mce_score, name = "MCE Participation",
            marker = list(color = "006400", line = list(color = "black", width = 1)),
            hovertemplate = generateHoverTemplate("MCE Participation Score")) %>%
  layout(title = list(text = "Scores in Contra Costa County",
                      font = list(family = "Arial", size = 22, color = "black", face = "bold")),
         xaxis = list(title = list(text = "City",
                                   font = list(family = "Arial", size = 20, color = "black", face = "bold"),
                                   y = 0.8
                                   ),
                      tickangle = 45, categoryorder = "total descending"),
         yaxis = list(title = list(text = "Score",
                                   font = list(family = "Arial", size = 20, color = "black", face = "bold"))),
         barmode = "stack",
         #my_theme,
         legend = list(x = 0.5, y = -1, orientation = "h", traceorder = "normal",
                       font = list(family = "Arial", size = 20, face = "bold"),
                       xanchor = "center", itemwidth = 10, itemsizing = "constant"),
          margin = list(l = 50, r = 50, t = 80, b = 50)) 

plotly_obj_roll_up_final <- all_scores %>%
  plot_ly(x = ~city, type = "bar", y = ~chargers_per_total_vehicle_scaled, name = "Chargers per Vehicle",
          marker = list(color = "khaki", line = list(color = "black", width = 1)),
          hovertemplate = generateHoverTemplate("Chargers per Vehicle Score")) %>%
  add_trace(y = ~solar_per_pop_scaled, name = "Solar MW Installed",
            marker = list(color = "yellow", line = list(color = "black", width = 1)),
            hovertemplate = generateHoverTemplate("Solar MW Installed Score")) %>%
  add_trace(y = ~civic_score, name = "Civic Spark",
            marker = list(color = "grey", line = list(color = "black", width = 1)),
            hovertemplate = generateHoverTemplate("Civic Spark Score")) %>%
  add_trace(y = ~electrification_score, name = "Electrification Ordinance",
            marker = list(color = "yellowgreen", line = list(color = "black", width = 1)),
            hovertemplate = generateHoverTemplate("Electrification Ordinance Score")) %>%
  add_trace(y = ~climate_emergency_score, name = "Declaration of Climate Emergency",
            marker = list(color = "008000", line = list(color = "black", width = 1)),
            hovertemplate = generateHoverTemplate("Declaration of Climate Emergency Score")) %>%
  add_trace(y = ~mce_score, name = "MCE Participation",
            marker = list(color = "006400", line = list(color = "black", width = 1)),
            hovertemplate = generateHoverTemplate("MCE Participation Score")) %>%
  layout(title = list(text = "Scores in Contra Costa County",
                      font = list(family = "Arial", size = 22, color = "black", face = "bold")),
         xaxis = list(
           title = list(
             text = "City",
             font = list(
               family = "Arial",
               size = 20,
               color = "black",
               face = "bold"
             ),
             y = 0.8
           ),
           tickangle = 45,
           categoryorder = "total descending",
           tickfont = list(
             size = 14  # Adjust the font size for mobile devices
           ),
           automargin = TRUE  # Enable automatic margin adjustment for responsiveness
         ),
         yaxis = list(title = list(text = "Score",
                                   font = list(family = "Arial", size = 20, color = "black", face = "bold"))),
         barmode = "stack",
         #my_theme,
         legend = list(x = 0.5, y = -1, orientation = "h", traceorder = "normal",
                       font = list(family = "Arial", size = 20, face = "bold"),
                       xanchor = "center", itemwidth = 10, itemsizing = "constant"),
         margin = list(l = 50, r = 50, t = 80, b = 50)) 



p <- plotly_obj_roll_up_final  %>% layout(
  autosize = TRUE,
  height = NULL,
  width = NULL,
  margin = list(
    l = 50,
    r = 50,
    b = 50,
    t = 50,
    pad = 4
  ),
  responsive = TRUE
)
plotly_obj_roll_up_final
saveWidget(p, file="07_Rollup/Stacked_bar_graph_2023_final_V9.html")
#Archive ------------------
# Stacked_bar_graph <- plot_ly(Total_Scores, x = ~City, y = ~CivicSpark.Score, type = 'bar', name = 'Civic Spark',marker = list(color = 'grey')) %>%
#   # add_trace(y = ~Green.House.Gas.Inventory.Score, name = 'Green House Gas Inventory') %>%
#   # add_trace(y = ~Climate.Emergency.Score , name = 'Climate Emergency') %>%
#   # add_trace(y = ~General.Plan.with.Climate.Element.Score, name = 'General Plan with Climate Element') %>%
#   add_trace(y = ~Solar.MW.Installed.Score, name = 'Solar MW Installed',marker = list(color = 'lightgrey')) %>%
#   add_trace(y = ~EV.Charging.Stations.Score, name = 'EV Charging Stations',marker = list(color = 'green')) %>%
#   add_trace(y = ~MCE.Score, name = 'MCE',marker = list(color = 'darkgreen')) %>%
#   add_trace(y = ~Climate.Emergency.Score, name = 'Climate Emergency Passed', marker = list(color = 'yellowgreen'))%>%
#   add_trace(y = ~Electrification.Score, name = 'Electrification',marker = list(color = 'yellow')) %>%
#   #add_trace(y = ~Climate.Emergency.Score, name = 'Climate Emergency Passed', marker = list(color = 'lightblue')) %>%
#   layout(xaxis = list(categoryorder = "total descending"))%>%
#   layout(yaxis = list(title = 'Score'), barmode = 'stack', legend = list(orientation = 'h', yanchor = "center", y = 1.2))


# # create plotly object with theme options
# plotly_obj_roll_up_envi <- all_scores %>% 
#   plot_ly(x = ~city, type = "bar", y = ~mce_score, name = "MCE Participation Score", 
#           marker = list(color = "darkgreen",line = list(color = "black", width = 1)))  %>% 
#   add_trace(y = ~chargers_per_total_vehicle_scaled, name = "Chargers per Vehicle Score", 
#             marker = list(color = "green",line = list(color = "black", width = 1))) %>% 
#   add_trace(y = ~civic_score, name = "Civic Spark Score", 
#             marker = list(color = "yellowgreen",line = list(color = "black", width = 1))) %>% 
#   add_trace(y = ~solar_per_pop_scaled, name = "Solar MW Installed Score", 
#             marker = list(color = "khaki",line = list(color = "black", width = 1))) %>%
#   add_trace(y = ~electrification_score, name = "Electrification Ordinance Score", 
#             marker = list(color = "darkgrey",line = list(color = "black", width = 1))) %>% 
#   add_trace(y = ~climate_emergency_score, name = "Declaration of Climate Emergency Score", 
#             marker = list(color = "lightgrey",line = list(color = "black", width = 1))) %>% 
#   layout(title = list(text = "Electrification Scores by City in Contra Costa County", 
#                       font = list(family = font_title, size = 18, color = "black", face = "bold")),
#          xaxis = list(title = list(text = "City", font = list(family = font_secondary, size = 16, color = "black", face = "bold")), 
#                       tickangle = 45, categoryorder = "total descending"),
#          yaxis = list(title = list(text = "Score", font = list(family = font_secondary, size = 16, color = "black", face = "bold"))),
#          barmode = "stack",
#          my_theme,
#          legend = list(x = 0.5, y = -0.2, orientation = "h", traceorder = "normal", font = list(family = font_secondary, size = 14),
#                        xanchor = "center", yanchor = "top", itemwidth = 10, itemsizing = "constant"))
# 
# saveWidget(plotly_obj_roll_up, file="07_Rollup/Stacked_bar_graph_2023.html")
# saveWidget(plotly_obj_roll_up_grey, file="07_Rollup/Stacked_bar_graph_2023_grey.html")
# saveWidget(plotly_obj_roll_up_green, file="07_Rollup/Stacked_bar_graph_2023_green.html")
# plotly_obj_roll_up <- all_scores %>% 
#   plot_ly(x = ~city, type = "bar", y = ~mce_score, name = "MCE Participation Score", 
#           marker = list(color = "50340b",line = list(color = "black", width = 1)))  %>% 
#   add_trace(y = ~chargers_per_total_vehicle_scaled, name = "Chargers per Vehicle Score", 
#             marker = list(color = "C19A6B",line = list(color = "black", width = 1))) %>% 
#   add_trace(y = ~civic_score, name = "Civic Spark Score", 
#             marker = list(color = "khaki",line = list(color = "black", width = 1))) %>% 
#   add_trace(y = ~solar_per_pop_scaled, name = "Solar MW Installed Score", 
#             marker = list(color = "gold",line = list(color = "black", width = 1))) %>%
#   add_trace(y = ~electrification_score, name = "Electrification Ordinance Score", 
#             marker = list(color = "yellowgreen",line = list(color = "black", width = 1))) %>% 
#   add_trace(y = ~climate_emergency_score, name = "Declaration of Climate Emergency Score", 
#             marker = list(color = "21421d",line = list(color = "black", width = 1))) %>% 
#   layout(title = list(text = "Electrification Scores by City in Contra Costa County", 
#                       font = list(family = font_title, size = 18, color = "black", face = "bold")),
#          xaxis = list(title = list(text = "City", font = list(family = font_secondary, size = 16, color = "black", face = "bold")), 
#                       tickangle = 45, categoryorder = "total descending"),
#          yaxis = list(title = list(text = "Score", font = list(family = font_secondary, size = 16, color = "black", face = "bold"))),
#          barmode = "stack",
#          my_theme,
#          legend = list(x = 0.5, y = -0.2, orientation = "h", traceorder = "normal", font = list(family = font_secondary, size = 14),
#                        xanchor = "center", yanchor = "top", itemwidth = 10, itemsizing = "constant"))
# 
# plotly_obj_roll_up_green <- all_scores %>% 
#   plot_ly(x = ~city, type = "bar", y = ~mce_score, name = "MCE Participation Score", 
#           marker = list(color = "006400",line = list(color = "black", width = 1)))  %>% 
#   add_trace(y = ~chargers_per_total_vehicle_scaled, name = "Chargers per Vehicle Score", 
#             marker = list(color = "008000",line = list(color = "black", width = 1))) %>% 
#   add_trace(y = ~civic_score, name = "Civic Spark Score", 
#             marker = list(color = "yellowgreen",line = list(color = "black", width = 1))) %>% 
#   add_trace(y = ~solar_per_pop_scaled, name = "Solar MW Installed Score", 
#             marker = list(color = "90EE90",line = list(color = "black", width = 1))) %>%
#   add_trace(y = ~electrification_score, name = "Electrification Ordinance Score", 
#             marker = list(color = "D3D3D3",line = list(color = "black", width = 1))) %>% 
#   add_trace(y = ~climate_emergency_score, name = "Declaration of Climate Emergency Score", 
#             marker = list(color = "C0C0C0",line = list(color = "black", width = 1))) %>% 
#   layout(title = list(text = "Electrification Scores by City in Contra Costa County", 
#                       font = list(family = font_title, size = 18, color = "black", face = "bold")),
#          xaxis = list(title = list(text = "City", font = list(family = font_secondary, size = 16, color = "black", face = "bold")), 
#                       tickangle = 45, categoryorder = "total descending"),
#          yaxis = list(title = list(text = "Score", font = list(family = font_secondary, size = 16, color = "black", face = "bold"))),
#          barmode = "stack",
#          my_theme,
#          legend = list(x = 0.5, y = -0.2, orientation = "h", traceorder = "normal", font = list(family = font_secondary, size = 14),
#                        xanchor = "center", yanchor = "top", itemwidth = 10, itemsizing = "constant"))
# 
# plotly_obj_roll_up_grey <- all_scores %>% 
#   plot_ly(x = ~city, type = "bar", y = ~mce_score, name = "MCE Participation Score", 
#           marker = list(color = "lightgrey",line = list(color = "black", width = 1)))  %>% 
#   add_trace(y = ~chargers_per_total_vehicle_scaled, name = "Chargers per Vehicle Score", 
#             marker = list(color = "yellow",line = list(color = "black", width = 1))) %>% 
#   add_trace(y = ~civic_score, name = "Civic Spark Score", 
#             marker = list(color = "greenyellow",line = list(color = "black", width = 1))) %>% 
#   add_trace(y = ~solar_per_pop_scaled, name = "Solar MW Installed Score", 
#             marker = list(color = "90EE90",line = list(color = "black", width = 1))) %>%
#   add_trace(y = ~electrification_score, name = "Electrification Ordinance Score", 
#             marker = list(color = "green",line = list(color = "black", width = 1))) %>% 
#   add_trace(y = ~climate_emergency_score, name = "Declaration of Climate Emergency Score", 
#             marker = list(color = "darkgreen",line = list(color = "black", width = 1))) %>% 
#   layout(title = list(text = "Electrification Scores by City in Contra Costa County", 
#                       font = list(family = font_title, size = 18, color = "black", face = "bold")),
#          xaxis = list(title = list(text = "City", font = list(family = font_secondary, size = 16, color = "black", face = "bold")), 
#                       tickangle = 45, categoryorder = "total descending"),
#          yaxis = list(title = list(text = "Score", font = list(family = font_secondary, size = 16, color = "black", face = "bold"))),
#          barmode = "stack",
#          my_theme,
#          legend = list(x = 0.5, y = -0.2, orientation = "h", traceorder = "normal", font = list(family = font_secondary, size = 14),
#                        xanchor = "center", yanchor = "top", itemwidth = 10, itemsizing = "constant"))
# 
# 
# # 
# # saveWidget(plotly_obj_roll_up_green, file="07_Rollup/Stacked_bar_graph_2023_green.html")
# 
# plotly_obj_roll_up_final <- all_scores %>% 
#   plot_ly(x = ~city, type = "bar", y = ~chargers_per_total_vehicle_scaled, name = "Chargers per Vehicle", 
#           marker = list(color = "khaki",line = list(color = "black", width = 1)),hovertemplate = "<b>%{name}</b><br>%{y}<extra></extra>") %>% 
#   add_trace(y = ~solar_per_pop_scaled, name = "Solar MW Installed", 
#             marker = list(color = "yellow",line = list(color = "black", width = 1)),hovertemplate = "<b>%{name}</b><br>%{y}<extra></extra>") %>%
#   add_trace(y = ~civic_score, name = "Civic Spark", 
#             marker = list(color = "grey",line = list(color = "black", width = 1)),hovertemplate = "<b>%{name}</b><br>%{y}<extra></extra>") %>% 
#   add_trace(y = ~electrification_score, name = "Electrification Ordinance", 
#             marker = list(color = "yellowgreen",line = list(color = "black", width = 1)),hovertemplate = "<b>%{name}</b><br>%{y}<extra></extra>") %>% 
#   add_trace(y = ~climate_emergency_score, name = "Declaration of Climate Emergency", 
#             marker = list(color = "008000",line = list(color = "black", width = 1)),hovertemplate = "<b>%{name}</b><br>%{y}<extra></extra>") %>% 
#   add_trace(y = ~mce_score, name = "MCE Participation", 
#              marker = list(color = "006400",line = list(color = "black", width = 1)),hovertemplate = "<b>%{name}</b><br>%{y}<extra></extra>")  %>% 
#   layout(title = list(text = "Scores by City in Contra Costa County", 
#                       font = list(family = font_title, size = 18, color = "black", face = "bold")),
#          xaxis = list(title = list(text = "City", font = list(family = font_secondary, size = 16, color = "black", face = "bold")), 
#                       tickangle = 45, categoryorder = "total descending"),
#          yaxis = list(title = list(text = "Score", font = list(family = font_secondary, size = 16, color = "black", face = "bold"))),
#          barmode = "stack",
#          my_theme,
#          legend = list(x = 0.5, y = -0.2, orientation = "h", traceorder = "normal", font = list(family = font_secondary, size = 14),
#                        xanchor = "center", yanchor = "top",  itemwidth = 10,  itemsizing = "constant"))
# #plotly_obj_roll_up_final <- plotly_obj_roll_up_final %>%
# #  config(hoverlabel = list(font = list(family = font_secondary, size = 14, color = "black", face = "bold")))
# plotly_obj_roll_up_final
# 
# saveWidget(plotly_obj_roll_up_green_final, file="07_Rollup/Stacked_bar_graph_2023_green_final.html")


# Define a helper function to generate the hovertemplate
# Stacked_bar_graph <- plot_ly(Total_Scores, x = ~City, y = ~CivicSpark.Score, type = 'bar', name = 'Civic Spark',marker = list(color = 'grey')) %>%
#   add_trace(y = ~Solar.MW.Installed.Score, name = 'Solar MW Installed',marker = list(color = 'lightgrey')) %>%
#   add_trace(y = ~EV.Charging.Stations.Score, name = 'EV Charging Stations',marker = list(color = 'green')) %>%
#   add_trace(y = ~MCE.Score, name = 'MCE',marker = list(color = 'darkgreen')) %>%
#   add_trace(y = ~Climate.Emergency.Score, name = 'Climate Emergency Passed', marker = list(color = 'yellowgreen'))%>%
#   add_trace(y = ~Electrification.Score, name = 'Electrification',marker = list(color = 'yellow')) %>%
#   layout(xaxis = list(categoryorder = "total descending"))%>%
#   layout(yaxis = list(title = 'Score'), barmode = 'stack', legend = list(orientation = 'h', yanchor = "center", y = 1.2))
# 
# ###-------------------
# plotly_obj_roll_up <- all_scores %>% 
#   plot_ly(x = ~city, type = "bar", y = ~mce_score, name = "MCE Participation Score", 
#           marker = list(color = "50340b",line = list(color = "black", width = 1)))  %>% 
#   
#   
#   add_trace(y = ~chargers_per_total_vehicle_scaled, name = "Chargers per Vehicle Score", 
#             marker = list(color = "C19A6B",line = list(color = "black", width = 1))) %>% 
#   
#   add_trace(y = ~civic_score, name = "Civic Spark Score", 
#             marker = list(color = "khaki",line = list(color = "black", width = 1))) %>% 
#   
#   add_trace(y = ~solar_per_pop_scaled, name = "Solar MW Installed Score", 
#             marker = list(color = "gold",line = list(color = "black", width = 1))) %>%
#   
#   add_trace(y = ~electrification_score, name = "Electrification Ordinance Score", 
#             marker = list(color = "yellowgreen",line = list(color = "black", width = 1))) %>% 
#   
#   add_trace(y = ~climate_emergency_score, name = "Declaration of Climate Emergency Score", 
#             marker = list(color = "21421d",line = list(color = "black", width = 1))) %>% 
#   
#   layout(title = "Electrification Scores by City in Contra Costa County",
#          xaxis = list(title = "City", tickangle = 45, categoryorder = "total descending"),
#          yaxis = list(title = "Score"),
#          barmode = "stack",
#          legend = list(x = 0.5, y = -0.2, orientation = "h", traceorder = "normal", font = list(size = 12),
#                        xanchor = "center", yanchor = "top", itemwidth = 10, itemsizing = "constant"))
# plotly_obj_roll_up