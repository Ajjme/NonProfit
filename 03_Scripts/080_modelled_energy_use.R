source("./03_Scripts/000_init.R")
#source
#https://openei.org/wiki/StateAndLocalEnergyProfiles
## full data set "./02_inputs/2019cityandcountyenergyprofiles.xlsb"
modelled_energy <- read_csv("./02_inputs/2019_city_and_county_modelled_energy_profiles.csv") %>% 
  clean_names() 
