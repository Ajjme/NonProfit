#https://data.census.gov/table?q=6355:+Electricians&g=040XX00US06$1600000_160XX00US0602252,0608142,0616000,0668378&tid=ACSEEO5Y2018.EEOALL1R&moe=false

### needed to edit the csv

employment_place_data <- read.csv("./02_inputs/ACSEEO5Y2018.EEOALL1R-place.csv") %>% 
  clean_names() %>% 
  select(contains("group"),contains("total"))%>% 
  rename_all(~str_remove(., "(?i)city.*")) %>% 
  rename_all(~str_remove(.,"_$")) %>%
  filter(!str_detect(label_grouping, "eft"))

saveRDS(employment_place_data, file = "./04_Outputs/rds/employment_place_data.rds")

library(plotly)
library(rjson)

url <- 'https://raw.githubusercontent.com/plotly/datasets/master/geojson-counties-fips.json'
counties <- rjson::fromJSON(file=url)

### add fips to data

urlmap <- "https://raw.githubusercontent.com/kjhealy/fips-codes/master/state_and_county_fips_master.csv"



county_fips_map <- read.csv(urlmap, colClasses=c(fips="character")) %>%
  filter(state == "CA") %>% 
  rename(county = name) %>% 
  mutate(county = ifelse(str_detect(county, " County"), str_replace(county, " County", ""), county))

employment_county_data <- read.csv("./02_inputs/ACSEEO5Y2018.EEOALL_county_Electric.csv") %>% 
  clean_names()%>% 
  select(contains("group"),contains("total"))%>% 
  rename_all(~str_remove(., "(?i)county.*")) %>% 
  rename_all(~str_remove(.,"_$"))%>%
  filter(!str_detect(label_grouping, "eft")) %>% 
  slice(-1)

saveRDS(employment_county_data, file = "./04_Outputs/rds/employment_county_data.rds")

employment_county_data_long <- tidyr::pivot_longer(employment_county_data, cols = -label_grouping, names_to = "county") %>% 
  filter(!str_detect(label_grouping, "ercent"),
         !str_detect(label_grouping, "otal"))
#for Pie Chart--------------------------
saveRDS(employment_county_data_long, file = "./04_Outputs/rds/employment_county_data_gendar.rds")

employment_county_data_long_total <- tidyr::pivot_longer(employment_county_data, cols = -label_grouping, names_to = "county") %>% 
  filter(str_detect(label_grouping, "otal"))

employment_county_data_long_clean <- employment_county_data_long_total %>% 
  mutate(county = str_replace_all(county, "_", " ")) %>% 
  mutate(county = str_to_title(county))


join_county_fips <- left_join(employment_county_data_long_clean, county_fips_map, by= "county") %>% 
  #drop_na(fips) %>% #out of state
  mutate_at(vars(value), as.numeric) %>% 
  #this was really annoying 
  mutate(fips = stringr::str_pad(fips, width = 5, pad = "0")) %>% 
  mutate_at(vars(fips), as.character) %>% 
  mutate_all(~ifelse(is.na(.), 0, .))


acs_general_pct_named_county <- readRDS(file = "./04_Outputs/rds/acs_general_pct_named_county.rds") %>% 
  select(county, total_pop) %>% 
  rename(fips = county) %>% 
  mutate_at(vars(fips), as.character)

join_county_fips_electricians <- left_join(join_county_fips, acs_general_pct_named_county, by="fips")

standardized_county_electricians <- join_county_fips_electricians %>% 
  mutate(standardized_electricians_per_ten_thousand = round(10000 *  value/total_pop)) %>% 
  mutate(county_electricians_per_ten_thousand = paste(county, standardized_electricians_per_ten_thousand, sep = " "))

saveRDS(standardized_county_electricians, file = "./04_Outputs/rds/employment_county_data_map.rds")
