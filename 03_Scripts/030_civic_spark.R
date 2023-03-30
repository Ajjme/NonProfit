#Civic Spark

# I am just going to count and work off our old data
source("./03_Scripts/000_init.R")
### Inputs------------------
#may have to change downloaded name
civic_data <- read_xlsx("./02_inputs/ContraCosta CivicSpark Projects 2022.xlsx") %>% 
  clean_names()

# need to match anf clean city names 
# probably best to do that by hand


# Scoring 50 points for having prior 
# 50 points for having this year

