
source("./03_Scripts/000_init.R")
### Inputs------------------
#may have to change downloaded name
electrification_data <- read.csv("./02_inputs/Total_Scores_Data_2023.csv") %>% 
  clean_names() %>% 
  select(city, "electrification_preliminary" ,"electrification_score") %>% 
  mutate(city = str_to_lower(city)) %>% 
  clean_city_names_uni_ccc() %>% 
  mutate(electrification_score = ifelse(city == "San Pablo", 100, electrification_score),
         electrification_score = ifelse(city == "Lafayette", 25, electrification_score))

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

