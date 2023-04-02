###heating
#occupany
#Renters
#value

#https://www.census.gov/acs/www/about/why-we-ask-each-question/heating/
 
  #Just going to download by hand
  
  # https://data.census.gov/table?g=040XX00US06_160XX00US0668378&tid=ACSDP5Y2021.DP04&moe=false
#https://data.census.gov/table?g=040XX00US06,06$8600000_160XX00US0668378&tid=ACSDP5Y2021.DP04&moe=false

home_characteristics_data <- read.csv("./02_inputs/ACSDP5Y2021_Housing_zip_code.csv", skip = 1) %>% 
  clean_names()

saveRDS(home_characteristics_data, file = "./04_Outputs/rds/home_characteristics_data.rds")