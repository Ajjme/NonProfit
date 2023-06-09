source("./03_Scripts/000_init.R")

source("./03_Scripts/020_MCE_processing.R")

### Full-----------------

# Prepare the data
data <- full_mce %>%
  select(community, co2_reduced) %>%
  mutate(co2_reduced = as.numeric(co2_reduced)) %>%
  na.omit()

### need to clean by per capita and years in the program

ggplot(data, aes(x = reorder(community, -co2_reduced), y = co2_reduced)) +
  geom_bar(stat = "identity", fill = "#2ca25f") +
  coord_flip() +
  #theme_tufte(base_family = "Helvetica") +
  my_theme() +
  ggtitle("CO2 Reduction by City in California") +
  xlab("City") +
  ylab("CO2 Reduction (metric tons per capita)") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))


### CCC --------------------

ccc_mce_df <-ccc_mce_df  %>%
  select(community, co2_reduced) %>%
  mutate(co2_reduced = as.numeric(co2_reduced)) %>%
  na.omit()

p <- ggplot(ccc_mce_df, aes(x = reorder(community, -co2_reduced), y = co2_reduced), type = "bar",showlegend = FALSE, marker = list(line = list(color = "black", width = 1))) +
  geom_bar(stat = "identity", fill = "#2ca25f") +
  coord_flip() +
  #theme_tufte(base_family = "Helvetica") +
  #my_theme() +
  ggtitle("CO2 Reduction by City in California") +
  xlab("City") +
  ylab("CO2 Reduction (metric tons per capita)") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

ggplotly(p)


# Create the heat map
# ggplot(data, aes(x = community, y = co2_reduced, fill = co2_reduced)) +
#   geom_bar() +
#   #scale_fill_gradient(low = "#7fbf7b", high = "#d6604d", na.value = "#d9d9d9") +
#   my_theme() +
#   ggtitle("CO2 Reduction by City in California") +
#   xlab("City") +
#   ylab("CO2 Reduction (metric tons per capita)") +
#   theme(axis.text.x = element_text(angle = 90, hjust = 1))