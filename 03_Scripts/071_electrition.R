elect_place <- readRDS(file = "./04_Outputs/rds/employment_place_data.rds") 
elect_place <- elect_place %>% 
  mutate_all(~ gsub("%", "", .)) %>% mutate_at(vars(-label_grouping), as.numeric) 
elect_place_long <- tidyr::pivot_longer(elect_place, cols = -label_grouping, names_to = "place") %>% 
  filter(!str_detect(label_grouping, "ercent"),
         !str_detect(label_grouping, "otal"))

p <- ggplot(elect_place_long, aes(x = place, y = value, fill = label_grouping, text = paste("Number of Electricians: ", value))) +
  geom_col(position = "stack") +
  scale_fill_manual(values = c("#1F78B4", "#33A02C")) +
  theme_minimal() +
  xlab("City") +
  ylab("number of Electricians") +
  ggtitle("Male and Female Electricians by Local Place") +
  theme(axis.title.x = element_text(hjust = 1),
        axis.title.y = element_text(hjust = 1),
        panel.background = element_rect(fill = "white"),
        axis.text.x = element_text(angle = 45, hjust = 0.5))+
  guides(fill = "none")

# make the plot interactive
plot_place_elect <- ggplotly(p, tooltip = "text", hoverinfo = "text")


saveRDS(plot_place_elect, file = "./06_Reports_Rmd/plot_place_elect.rds")



### County ---------------
elect_county <- readRDS( file = "./04_Outputs/rds/employment_county_data.rds") %>% 
  slice(-1:-2) %>% 
  slice(-2) %>% 
  mutate_all(~ gsub("%", "", .)) %>% mutate_at(vars(-label_grouping), as.numeric)

elect_county_num <- readRDS( file = "./04_Outputs/rds/employment_county_data.rds") %>% 
  slice(-1)  %>% 
  slice(-2)  %>%
  slice(-3)  %>% 
   mutate_at(vars(-label_grouping), as.numeric)

elect_county_long <- tidyr::pivot_longer(elect_county_num, cols = -label_grouping, names_to = "County")


p <- ggplot(elect_county_long, aes(x = County, y = value, fill = label_grouping)) +
  geom_col(position = "stack") +
  scale_fill_manual(values = c("#1F78B4", "#33A02C")) +
  theme_minimal() +
  xlab("County") +
  ylab("number of Electricians") +
  ggtitle("Male and Female Percentages by County") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# make the plot interactive
ggplotly(p)

