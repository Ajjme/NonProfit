#https://data.census.gov/table?q=6355:+Electricians&g=040XX00US06$1600000_160XX00US0602252,0608142,0616000,0668378&tid=ACSEEO5Y2018.EEOALL1R&moe=false

### needed to edit the csv

employment_place_data <- read.csv("./02_inputs/ACSEEO5Y2018.EEOALL1R-place.csv") %>% 
  clean_names() %>% 
  select(contains("group"),contains("total"))%>% 
  rename_all(~str_remove(., "(?i)city.*")) %>% 
  rename_all(~str_remove(.,"_$")) %>%
  filter(!str_detect(label_grouping, "eft"))

saveRDS(employment_place_data, file = "./04_Outputs/rds/employment_place_data.rds")

employment_county_data <- read.csv("./02_inputs/ACSEEO5Y2018.EEOALL_county_Electric.csv") %>% 
  clean_names()%>% 
  select(contains("group"),contains("total"))%>% 
  rename_all(~str_remove(., "(?i)county.*")) %>% 
  rename_all(~str_remove(.,"_$"))%>%
  filter(!str_detect(label_grouping, "eft")) %>% 
  slice(-1)

saveRDS(employment_county_data, file = "./04_Outputs/rds/employment_county_data.rds")
