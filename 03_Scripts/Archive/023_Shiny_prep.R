source("./03_Scripts/000_init.R")

source("./03_Scripts/020_MCE_processing.R")

# Load data
co2_data <- full_mce %>%
  select(community, co2_reduced) %>%
  rename(city = community) %>% 
  mutate(co2_reduced = as.numeric(co2_reduced)) %>%
  na.omit()

cities_ls <- full_mce %>% 
  select(community)

coords <- readRDS(file = "./04_Outputs/rds/coords.rds") %>% 
  mutate_at(vars(city), str_to_title)

#need to fix the matching here
full_df <- full_join(co2_data, coords, by= "city") %>% 
  na.omit(city, lon)

#for now just dropping
#also need to make sure pulling the right city
