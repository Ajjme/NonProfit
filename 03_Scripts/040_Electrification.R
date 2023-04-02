
source("./03_Scripts/000_init.R")
### Inputs------------------
#may have to change downloaded name
electrification_data <- read.csv("./02_inputs/2022_sum_data.csv", skip = 1) %>% 
  clean_names() %>% 
  select(city, "electrification_preliminary" ,"electrification_score")

saveRDS(electrification_data, file = "./04_Outputs/rds/electrification_data.rds")
#need to set up the city pin and proper city names

### Email ---------------
# Okay, it looks like a wrap!
#   
#   Passed the list  by quite a few folks,
# 
# including the Building Electrification team at 350, and I’d say it’s a go:
#   The Electrification stats we will use are:
#   Yes, in New Construction:
#   Unincorporated CCC (working on a roadmap for existing buildings)
# Richmond
# 
# Hercules
# 
# Martinez
# 
# In progress:
# 
#   El Cerrito (has electrification for new construction in the San Pablo Ave Specific Plan zone already)
# 
# Lafayette

