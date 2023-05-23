employment_county_data_long_gendar <- readRDS(file = "./04_Outputs/rds/employment_county_data_gendar.rds")%>% 
  mutate(county = str_replace_all(county, "_", " ")) %>% 
  mutate(county = str_to_title(county)) %>% 
  filter(county == "Contra Costa")


# Create a pie chart
fig <- plot_ly(employment_county_data_long_gendar, labels = ~label_grouping, values = ~value, type = "pie")

# Customize the pie chart layout
fig <- fig %>% layout(
  title = "Employment by Gender",
  showlegend = TRUE
)

# Display the pie chart
fig
saveRDS(fig, file = "./06_Reports_Rmd/map_Electricians_pie.rds")


# Create a pie chart
# fig <- plot_ly(employment_county_data_long_gendar, labels = ~label_grouping, values = ~value, type = "pie",
#                marker = list(colors = ifelse(label_grouping == "Female Number", "pink", "default")))
# 
# # Customize the pie chart layout
# fig <- fig %>% layout(
#   title = "Employment by Gender",
#   showlegend = TRUE
# )
# 
# # Display the pie chart
# fig