
source("./03_Scripts/000_init.R")
#impact report 
#https://www.mcecleanenergy.org/wp-content/uploads/2023/01/MCE-Impact-Report-2022_01092023.pdf
#impact report for images
#https://www.mcecleanenergy.org/wp-content/uploads/2020/07/About-MCE-Leave-Behind.pdf

ccc_mce_df <- read.csv("./02_inputs/Contra_Costa_MCE_Data.csv", skip = 3, header = T) %>% 
  clean_names() %>% 
  mutate_at(c('deep_green_a2', 'mt_c_oa_reduced_a1'), as.numeric) %>% 
  rename(co2_reduced = mt_c_oa_reduced_a1,
         join_deep_green = deep_green_a2)

marin_mce_df <- read.csv("./02_inputs/marin_county_mce_data.csv", skip = 3, header = T) %>% 
  clean_names() %>% 
  mutate_at(c('deep_green_a2', 'mt_c_oa_reduced_a1'), as.numeric) %>% 
  rename(co2_reduced = mt_c_oa_reduced_a1,
         join_deep_green = deep_green_a2)

napa_mce_df <- read.csv("./02_inputs/napa_county_mce_data.csv", skip = 3, header = T) %>% 
  clean_names()%>% 
  mutate_at(c('deep_green_a2', 'mt_c_oa_reduced_a1'), as.numeric) %>% 
  rename(co2_reduced = mt_c_oa_reduced_a1,
         join_deep_green = deep_green_a2)

solano_mce_df <- read.csv("./02_inputs/solano_county_mce_data.csv", skip = 3, header = T) %>% 
  clean_names()%>% 
  mutate_at(c('deep_green_a2', 'mt_c_oa_reduced_a1'), as.numeric)%>% 
  rename(co2_reduced = mt_c_oa_reduced_a1,
         join_deep_green = deep_green_a2)

full_mce <- bind_rows(ccc_mce_df, marin_mce_df, napa_mce_df, solano_mce_df) 
