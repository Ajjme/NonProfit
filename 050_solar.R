
source("./03_Scripts/000_init.R")
### Inputs------------------
#may have to change downloaded name
PGE_solar_data <- read_csv("../Drawdown/PGE_Interconnected_Project_Sites_2023-02-28.csv") %>% 
  clean_names()
