

source("./03_Scripts/000_init.R")

#Sheet 2
#Stacked or Pie chart of business groups use tonnage percents are within each
business_groups <- read_xlsx("./02_inputs/Waste/BusinessGroupsForAMaterial use.xlsx", sheet = "Data-Commercial Business Groups") %>% 
  clean_names() 


# #Individual stacked bar graphs of the percentage?
# business_groups_plot <- ggplotly(
#   ggplot(business_groups, aes(x = tons_disposed, y = business_group)) +
#     geom_bar(stat = "identity", fill = "black", color = "brown") +
#     labs(title = "Tonnage of Waste Produced per Business Group", x = "Business Group", y = "Landfill Tonnage") +
#     theme(legend.position = "bottom", axis.text.x = element_text(angle = 45, hjust = 1), panel.background = element_blank())
# )

### pivoting main so see totals

business_groups_pivot <- business_groups %>% 
  select(-"jurisdiction_s" ,             
         -"material_type"   ,             -"employee_count",              
         -"occupied_multifamily_units",   -contains("tpepy"), -contains("percent"), -contains("total")) %>% 
  rename_all(~ stringr::str_replace(., regex("tons_", ignore_case = TRUE), "")) %>% 
  rename_all(~ stringr::str_replace(., regex("_", ignore_case = TRUE), " ")) %>% 
  rename_all(~str_to_title(.)) %>% 
  pivot_longer(   cols = !`Business Group`,
                  names_to = "Type",
              values_to = "total") %>% 
  mutate(total = round(total)) %>% 
  rename(`Waste Total` = total) 


business_groups_plot_stacked <- ggplotly(
  ggplot(business_groups_pivot, aes(x = `Waste Total`, y = `Business Group`,  fill = Type)) +
    geom_bar(stat = "identity") +
    labs( x = "Landfill Tonnage", y = "Business Group") +
    theme(legend.position = "bottom",
          axis.text.x = element_text(angle = 45, hjust = 1),
          panel.background = element_blank())
) %>% layout(legend = list(x = -0.5, y = -5))


business_groups_plot_stacked
saveRDS(business_groups_plot_stacked, file = "./06_Reports_Rmd/plot_business_groups.rds")





# 
# 
# 
# q4_2019 <- dat %>% filter(QuarterYear == "Q4 2019") %>%
#   group_by(Grade) %>% 
#   arrange(Grade) %>%
#   plot_ly(
#     x = ~Type, 
#     y = ~value, 
#     color= ~Grade,
#     colors = 'Reds',
#     type = 'bar', 
#     legendgroup=~Grade) %>% 
#   layout(xaxis = list(title = "Q4 2019"))
# 
# q1_2020 <- dat %>% filter(QuarterYear == "Q1 2020") %>%
#   group_by(Grade) %>% 
#   arrange(Grade) %>%
#   plot_ly(
#     x = ~Type, 
#     y = ~value, 
#     color= ~Grade,
#     colors = 'Reds',
#     type = 'bar', 
#     legendgroup=~Grade, 
#     showlegend = FALSE) %>% 
#   layout(xaxis = list(title = "Q1 2020"))
# 
# 
# q2_2020 <- dat %>% filter(QuarterYear == "Q2 2020") %>%
#   group_by(Grade) %>% 
#   arrange(Grade) %>%
#   plot_ly(
#     x = ~Type, 
#     y = ~value, 
#     color= ~Grade,
#     colors = 'Reds',
#     type = 'bar', 
#     legendgroup=~Grade, 
#     showlegend = FALSE) %>% 
#   layout(xaxis = list(title = "Q2 2020"))
# 
# q3_2020 <- dat %>% filter(QuarterYear == "Q3 2020") %>%
#   group_by(Grade) %>% 
#   arrange(Grade) %>%
#   plot_ly(
#     x = ~Type, 
#     y = ~value, 
#     color= ~Grade,
#     colors = 'Reds',
#     type = 'bar',
#     legendgroup =~Grade,
#     showlegend = FALSE) %>% 
#   layout(xaxis = list(title = "Q3 2020"))
# 
# subplot(q4_2019, q1_2020, q2_2020, q3_2020, titleX = TRUE, shareY = T) %>%
#   layout(barmode = 'stack', showlegend = TRUE)

saveRDS(plot_business_groups, file = "./06_Reports_Rmd/plot_business_groups.rds")

