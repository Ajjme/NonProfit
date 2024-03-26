
source("./03_Scripts/000_init.R")


diversion_summaries <- list.files(path = "./02_inputs/Waste/Diversion_Summary",     
                                  pattern = "*.xlsx", 
                                  full.names = TRUE) %>%  
  lapply(read_excel) %>%                                            
  bind_rows

diversion_summaries_filtered <- diversion_summaries %>% 
  clean_names() %>% 
  group_by(jurisdiction) %>%
  filter(report_year == max(report_year)) 

#plot programs
diversion_summaries_programs <- diversion_summaries_filtered %>% 
  mutate(number_of_programs_implemented = as.numeric(number_of_programs_implemented)) %>% 
  arrange(-number_of_programs_implemented)

# diversion_summaries_programs_plot <- ggplotly(
#   ggplot(diversion_summaries_programs, aes(x = jurisdiction, y = number_of_programs_implemented)) +
#     geom_bar(stat = "identity", fill = "black", color = "green") +
#     labs(title = "Tonnage of Waste Produced per Business Group", x = "Business Group", y = "Landfill Tonnage") +
#     theme(legend.position = "bottom", axis.text.x = element_text(angle = 45, hjust = 1), panel.background = element_blank())
# )
# diversion_summaries_programs_plot
# 
# saveRDS(diversion_summaries_programs_plot, file = "./06_Reports_Rmd/diversion_summaries_programs_plot.rds")


#plot
diversion_summaries_disposal <- diversion_summaries_filtered %>% 
  arrange(annual_per_capita_disposal_rate_ppd_per_resident) %>% 
  mutate(jurisdiction = case_when(jurisdiction == "West Contra Costa Integrated Waste Management Authority" ~ "WCCIWMA",
                                  jurisdiction == "Central Contra Costa Solid Waste Authority (CCCSWA)" ~ "CCCSWA",
                                  #jurisdiction == "Contra Costa/Ironhouse/Oakley Regional Agency" ~ "Oakley",
                                  jurisdiction == "Contra Costa-Unincorporated" ~ "Unincorporated CCC",
                                  TRUE ~ jurisdiction)) %>% 
  filter(jurisdiction !="Contra Costa/Ironhouse/Oakley Regional Agency")


#mixed


fig_multi <- plot_ly(diversion_summaries_disposal, x = ~jurisdiction, y = ~number_of_programs_implemented, name = "Programs", type = "bar", showlegend = FALSE, marker = list(line = list(color = "black", width = 1))) %>%
  add_trace(y = ~annual_per_capita_disposal_rate_ppd_per_resident, name = "Per Capita Disposal Rate", type = "bar", visible = FALSE) %>%
  #add_trace(y = ~total_pop, name = "Total Population", type = "bar", visible = FALSE) %>%
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
          # ,
          # list(method = "update",
          #      args = list(list(visible = c(FALSE, FALSE, TRUE))),
          #      label = "Total Vehicles"
          # )
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