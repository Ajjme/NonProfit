
source("./03_Scripts/000_init.R")

ccc_mce_df <- read.csv("./02_inputs/Contra_Costa_MCE_Data.csv", skip = 3, header = T) %>% 
  clean_names()
marin_mce_df <- read.csv("./02_inputs/marin_county_mce_data.csv", skip = 3, header = T) %>% 
  clean_names()
napa_mce_df <- read.csv("./02_inputs/napa_county_mce_data.csv.csv", skip = 3, header = T) %>% 
  clean_names()
solano_mce_df <- read.csv("./02_inputs/solano_county_mce_data.csv", skip = 3, header = T) %>% 
  clean_names()

