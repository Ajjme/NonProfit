
source("./03_Scripts/000_init.R")


diversion_summaries <- list.files(path = "./02_inputs/Waste/Diversion_Summary",     
                                  pattern = "*.xlsx", 
                                  full.names = TRUE) %>%  
  lapply(read_excel) %>%                                            
  bind_rows

diversion_summaries_filtered <- diversion_summaries %>% 
  clean_names() %>% 
  group_by(jurisdiction) %>%
  filter(report_year == max(report_year)) %>% 
  filter(report_year == "2022")

#plot programs
diversion_summaries_programs <- diversion_summaries_filtered %>% 
  mutate(number_of_programs_implemented = as.numeric(number_of_programs_implemented)) %>% 
  arrange(-number_of_programs_implemented) %>% 
  filter(report_year == "2022")
s
# diversion_summaries_programs_plot <- ggplotly(
#   ggplot(diversion_summaries_programs, aes(x = jurisdiction, y = number_of_programs_implemented)) +
#     geom_bar(stat = "identity", fill = "black", color = "green") +
#     labs(title = "Tonnage of Waste Produced per Business Group", x = "Business Group", y = "Landfill Tonnage") +
#     theme(legend.position = "bottom", axis.text.x = element_text(angle = 45, hjust = 1), panel.background = element_blank())
# )
# diversion_summaries_programs_plot
# 
# saveRDS(diversion_summaries_programs_plot, file = "./06_Reports_Rmd/diversion_summaries_programs_plot.rds")
#Stacked bargraph with Juristiction and type of waste - Filter for county then graph by Juris year is all 2022

#bring in total tonnage
total_tonnage_Jurisdiction_disposal <- read_xlsx("./02_inputs/Waste/Jurisdiction/OverallJurisdictionTonsForDisposal use.xlsx") %>% 
  clean_names() %>% 
  filter(county == "Contra Costa") %>%
  select(-year, -county) %>%
  group_by(jurisdiction)  %>% 
  mutate(total_waste = rowSums(across(where(is.numeric)), na.rm = TRUE)) %>% 
  select(jurisdiction, total_waste) %>% 
  mutate(jurisdiction = case_when(jurisdiction == "West Contra Costa Integrated Waste Management Authority" ~ "WCCIWMA",
                                  jurisdiction == "Central Contra Costa Solid Waste Authority (CCCSWA)" ~ "CCCSWA",
                                  #jurisdiction == "Contra Costa/Ironhouse/Oakley Regional Agency" ~ "Oakley",
                                  jurisdiction == "Contra Costa-Unincorporated" ~ "Unincorporated CCC",
                                  TRUE ~ jurisdiction)) %>% 
  filter(jurisdiction != "Martinez",
        # jurisdiction != "Pittsburg",
         jurisdiction != "Pleasant Hill")


#plot
diversion_summaries_disposal <- diversion_summaries_filtered %>% 
  arrange(annual_per_capita_disposal_rate_ppd_per_resident) %>% 
  mutate(jurisdiction = case_when(jurisdiction == "West Contra Costa Integrated Waste Management Authority" ~ "WCCIWMA",
                                  jurisdiction == "Central Contra Costa Solid Waste Authority (CCCSWA)" ~ "CCCSWA",
                                  #jurisdiction == "Contra Costa/Ironhouse/Oakley Regional Agency" ~ "Oakley",
                                  jurisdiction == "Contra Costa-Unincorporated" ~ "Unicorporated CCC",
                                  TRUE ~ jurisdiction)) %>% 
  filter(jurisdiction !="Contra Costa/Ironhouse/Oakley Regional Agency")

full_diversion_summaries_disposal <- full_join(diversion_summaries_disposal, total_tonnage_Jurisdiction_disposal, by="jurisdiction") %>% 
  mutate(number_of_programs_implemented = case_when(jurisdiction == "Pittsburg" ~ as.numeric("51"),
                                                    TRUE ~ number_of_programs_implemented),
         annual_per_capita_disposal_rate_ppd_per_resident = case_when(jurisdiction == "Pittsburg" ~ as.numeric("6.1"),
                                                                      TRUE ~ annual_per_capita_disposal_rate_ppd_per_resident)) %>% 
  mutate(jurisdiction = case_when(jurisdiction == "Unincorporated CCC" ~ "Unicorporated CCC",
                                  TRUE ~ jurisdiction))
#mixed

fig_multi <- plot_ly(full_diversion_summaries_disposal, x = ~jurisdiction, y = ~number_of_programs_implemented, name = "Programs", type = "bar", showlegend = FALSE, marker = list(line = list(color = "black", width = 1))) %>%
  add_trace(y = ~annual_per_capita_disposal_rate_ppd_per_resident, name = "Per Capita Disposal Rate", type = "bar", visible = FALSE) %>%
  add_trace(y = ~total_waste, name = "Total Waste", type = "bar", visible = FALSE) %>%
  layout( 
    updatemenus = list(
      list(
        type = "buttons",
        direction = "down",
        showactive = TRUE,
        buttons = list(
          list(method = "update",
               args = list(list(visible = c(TRUE, FALSE, FALSE))),
               label = "Programs"),
          list(method = "update",
               args = list(list(visible = c(FALSE, TRUE, FALSE))),
               label = "Disposal Rates"
          )
          ,
          list(method = "update",
               args = list(list(visible = c(FALSE, FALSE, TRUE))),
               label = "Total Waste"
          )
        ),
        pad = list(r = 15, t = 0, b = 0, l = 0)
      )
    ),
    xaxis = list(title = "Jurisdiction", tickfont = list(size = 14), tickangle = 45),
    yaxis = list(title = "", tickfont = list(size = 14)),
    margin = list(l = 60, r = 20, t = 40, b = 40),
    font = list(family = "Arial", size = 14)
  )

fig_multi

# save the Plotly object to an RDS file
saveRDS(fig_multi, file = "./06_Reports_Rmd/waste_main.rds")

saveWidget(widget = fig_multi, file = "waste_main.html")


### total scores------------------------
all_cities_score <- full_diversion_summaries_disposal %>% 
  mutate(program_score = (100*as.numeric(number_of_programs_implemented)/52),
         disposal_score = 100 *  2.1/annual_per_capita_disposal_rate_ppd_per_resident ,
         total_score   = (program_score + disposal_score)/2) 

### Expanding dataframe -----------
df <- tibble(
  ID = 1:7,
  jurisdiction = rep("long_cities", 7),
  program_score = rep(82.7, 7),
  disposal_score = rep(60, 7),
  total_score = rep(71.34, 7),
  long_cities = rep("CCCSWA", 7)
)

# Print dataframe
df_cccswa <- df %>% 
  mutate(jurisdiction = case_when(ID == "1" ~ "Danville",
                          ID == "2" ~ "Lafayette",
                          ID == "3" ~ "Martinez",
                          ID == "4" ~ "Moraga",
                          ID == "5" ~ "Orinda",
                          ID == "6" ~ "Pleasant Hill",
                          #ID == "7" ~ "San Ramon",
                          ID == "7" ~ "Walnut Creek"))
df_west <- tibble(
  ID = 1:5,
  jurisdiction = rep("long_cities", 5),
  program_score = rep(92.3, 5),
  disposal_score = rep(50, 5),
  total_score = rep(71.15, 5),
  long_cities = rep("WCCIWMA", 5)
)
# df_pitt <- tibble(
#   ID = 1,
#   jurisdiction = rep("Pittsburg", 1),
#   program_score = rep(98.1, 1), #51 program 
#   disposal_score = rep(34.4, 1), #6.2 
#   total_score = rep(46.32, 1),
#   long_cities = rep("hand", 1)
#)
# Print dataframe
df_WCCIWMA <- df_west %>% 
  mutate(jurisdiction = case_when(ID == 1 ~ "El Cerrito",
                          ID == 2 ~ "Richmond",
                          ID == 3 ~ "San Pablo",
                          ID == 4 ~ "Pinole",
                          ID == 5 ~ "Hercules"))

all_cities_score_2 <- all_cities_score %>% 
  bind_rows(df_WCCIWMA) %>% 
  bind_rows(df_cccswa) %>%
  #bind_rows(df_pitt) %>%
  filter(jurisdiction != "CCCSWA",
         jurisdiction != "WCCIWMA")
all_cities_score_2

saveRDS(all_cities_score_2, file = "./06_Reports_Rmd/waste_scores_all_cities.rds")
### Graph -----------

fig_multi_waste <- plot_ly(all_cities_score_2, x = ~jurisdiction, y = ~total_score, name = "Total Score", type = "bar", showlegend = FALSE, marker = list(line = list(color = "black", width = 1))) %>%
  add_trace(y = ~program_score, name = "Program Score", type = "bar", visible = FALSE) %>%
  add_trace(y = ~disposal_score, name = "Disposal Rate Score", type = "bar", visible = FALSE) %>%
  layout( 
    updatemenus = list(
      list(
        type = "buttons",
        direction = "down",
        showactive = TRUE,
        buttons = list(
          list(method = "update",
               args = list(list(visible = c(TRUE, FALSE, FALSE))),
               label = "Total Score"),
          list(method = "update",
               args = list(list(visible = c(FALSE, TRUE, FALSE))),
               label = "Program Score"
          )
          ,
          list(method = "update",
               args = list(list(visible = c(FALSE, FALSE, TRUE))),
               label = "Disposal Score"
          )
        ),
        pad = list(r = 15, t = 0, b = 0, l = 0)
      )
    ),
    xaxis = list(title = "Jurisdiction", tickfont = list(size = 14), tickangle = 45),
    yaxis = list(title = "", tickfont = list(size = 14)),
    margin = list(l = 60, r = 20, t = 40, b = 40),
    font = list(family = "Arial", size = 14)
  )

fig_multi_waste

# save the Plotly object to an RDS file
saveRDS(fig_multi_waste, file = "./06_Reports_Rmd/waste_score.rds")

saveWidget(widget = fig_multi_waste, file = "waste_score.html")

















#for total Roll up Stacked bar graph

diversion_summaries <- diversion_summaries_programs %>% 
  plot_ly(x = ~jurisdiction, type = "bar", y = ~number_of_programs_implemented, name = "Number of Programs", 
          marker = list(color = "C19A6B",line = list(color = "black", width = 1))) %>% 
  add_trace(y = ~annual_per_capita_disposal_rate_ppd_per_resident, name = "Per Capita Disposal Rate", 
            marker = list(color = "darkgreen",line = list(color = "black", width = 1))) %>% 
  #removed for now
  # add_trace(y = ~bus_scaled, name = "Electric of Buses, Bonus", 
  #           marker = list(line = list(color = "black", width = 1))) %>% 
  layout(title = "Waste in Contra Costa County",
         xaxis = list(title = "Jurisdiction", tickangle = 45, categoryorder = "total descending"),
         yaxis = list(title = "Score"),
         barmode = "stack",
         legend = list(x = 0.5, y = -0.2, orientation = "h", traceorder = "normal", font = list(size = 12),
                       xanchor = "center", yanchor = "top", itemwidth = 10, itemsizing = "constant"))

# Display interactive graph
diversion_summaries