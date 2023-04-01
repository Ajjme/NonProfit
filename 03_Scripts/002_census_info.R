# Install the necessary packages
# install.packages("httr")
# install.packages("jsonlite")

# Load the necessary packages
library(httr)
library(jsonlite)
#install.packages("censusapi")
library(censusapi)

# Add key to .Renviron
Sys.setenv(CENSUS_KEY="8d7ce08aa5bccac368193a934c445f798cd3a888")
# Reload .Renviron
readRenviron("~/.Renviron")
# Check to see that the expected key is output in your R console
Sys.getenv("CENSUS_KEY")

#install.packages("tidycensus")
library(tidycensus)

# Set the Census API key (you must obtain this from the Census Bureau's website)
census_api_key("8d7ce08aa5bccac368193a934c445f798cd3a888")

# Set the geographic parameters for the API request
geo <- get_acs(geography = "tract", 
               variables = c("NAME", "B01001_001E", "B19013_001E"),
               state = "CA",
               county = "Contra Costa County",
               geometry = TRUE)

variables <- load_variables(2022, "acs5")

# View the variable names and labels in a data frame
variables_df <- as.data.frame(variables)
View(variables_df)

### need to select and rename variables

acs_general_pct <- acs_general_pct %>%
  mutate_at(c('place'), as.character)%>%
  mutate(place_FIPS = paste0(state, place)) %>%
  rename(car_washes = B24134_241E,
         one_vehicles_available = B08201_003E,
         two_vehicles_available = B08201_004E,
         three_vehicles_available = B08201_005E,
         four_or_more_vehicles_available = B08201_006E,
         heavy_vehicles_available = B24116_450E)
# 
# #this is wrong
# # Load the place hierarchy file for California
# #place_hier_ca <- read.csv("https://www2.census.gov/geo/docs/reference/codes/files/st06_ca_places.txt", sep="|", header=FALSE)
# place_hier_ca <- read.csv("https://www2.census.gov/geo/docs/reference/codes/PLACElist.txt", sep="|", header=TRUE) %>% 
#   clean_names() %>% 
#   filter(state == "CA") %>% 
#   mutate_at(c('placefp'), as.character)
# 









### Looking at options -------------
#all_apis <- listCensusApis()
# head(all_apis)
# 
# #here we are pulling from a new data set with tracts that we can convert later.
# 
# acs_general_pct <- getCensus(name = "pdb/tract", vintage = 2022,
#                              vars = c("Tot_Housing_Units_ACS_16_20", "tract"), # Selected broadband variables
#                              region = "tract:*", # '*' mean all counties
#                              regionin = "state:06") # 06 is california state FIPS code
# 
# # Variables and geography levels available in ACS 5-yr subject dataset as of 2021
# #full_options <- listCensusMetadata(name = "acs/acs1", vintage = 2021, type = "variables")
# 
# ## Get selected broadband variable
#https://api.census.gov/data/2019/acs/acs5/variables.html
acs_general_pct <- getCensus(name = "acs/acs5", vintage = 2021,
                               vars = c("B01001_001E", "B01001_001E", "B24114_454E", "B08014_003E", "B08014_004E",
                                        "B08014_005E","B08014_006E", "B08014_007E","B08014_001E", "B08134_071E", "B08134_061E",
                                        "B08134_031E", "B08134_021E", "B08132_061E", "B24114_407E", "B24124_407E"), # Selected broadband variables
                               region = "place:*", # '*' mean all counties
                               regionin = "state:06") # 06 is california state FIPS code

acs_general_pct_named <- acs_general_pct %>%
  mutate_at(c('place'), as.character)%>%
  rename(total_pop = B01001_001E,
         heat_cool_ref_installers = B24114_454E,
         one_vehicle = B08014_003E,
         two_vehicle = B08014_004E,
         three_vehicle = B08014_005E,
         four_vehicle = B08014_006E,
         five_vehicle = B08014_007E,
         total_vehicle = B08014_001E,
         public_trans_bus = B08134_071E,
         public_trans = B08134_061E,
         carpool = B08134_031E,
         drove_alone = B08134_021E,
         walked_to_work = B08132_061E,
         electrician = B24114_407E,
         elect_2 = B24124_407E) %>% 
  mutate(place_FIPS = paste0(state, place)) 
#add vehicles 
# travel tiem 
# heating

#%>%
#   rename(car_washes = B24134_241E,
#          one_vehicles_available = B08201_003E,s
#          two_vehicles_available = B08201_004E,
#          three_vehicles_available = B08201_005E,
#          four_or_more_vehicles_available = B08201_006E,
#          heavy_vehicles_available = B24116_450E)
# 
# 
# ### Place is only those with a population over 65000 so we need to pull old data-------------------
# 
# acs_general_pct <- acs_general_pct %>% 
#   mutate_at(c('place'), as.character)%>% 
#   mutate(place_FIPS = paste0(state, place)) %>% 
#   rename(car_washes = B24134_241E,
#          one_vehicles_available = B08201_003E,
#          two_vehicles_available = B08201_004E,
#          three_vehicles_available = B08201_005E,
#          four_or_more_vehicles_available = B08201_006E,
#          heavy_vehicles_available = B24116_450E) 
# 
# #this is wrong
# # Load the place hierarchy file for California
#place_hier_ca <- read.csv("https://www2.census.gov/geo/docs/reference/codes/files/st06_ca_places.txt", sep="|", header=FALSE)
place_hier_ca <- read.csv("https://www2.census.gov/geo/docs/reference/codes/PLACElist.txt", sep="|", header=TRUE) %>%
  clean_names() %>%
  filter(state == "CA") %>%
  mutate_at(c('placefp'), as.character)
# 
# 
# #https://www2.census.gov/geo/docs/reference/codes/PLACElist.txt
# # Merge the place hierarchy file with the ACS data
# 
# ### lets do QC by comparing total population stats
# 
acs_general_pct_ca_city <- left_join(acs_general_pct_named, place_hier_ca,
                                   by = c("place"= "placefp"))
# 
saveRDS(acs_general_pct_ca_city, file = "./04_Outputs/rds/acs_general_pct_ca_city.rds")
# 
# ### pull out home heating
# 
# ### Archive --------------------
# ### Demographic---------------
# ## Educational Attainment, Age, and Unemployment from the ACS 2021 ##
# acs_demo <- getCensus(name = "acs/acs5/profile", vintage = 2021,
#                       vars = c("DP02_0066PE","DP02_0064PE","DP02_0065PE", # Education
#                                "DP03_0009PE", # Unployment
#                                "DP05_0007PE","DP05_0008PE", # GenZ
#                                "DP05_0009PE","DP05_0010PE", # Millennials
#                                "DP05_0011PE","DP05_0012PE", # GenX
#                                "DP05_0013PE","DP05_0014PE","DP05_0015PE"), # Boomers
#                       region = "county:*",
#                       regionin = "state:48") 
# 
# acs_demo <- acs_demo %>% 
#   mutate(county_FIPS = paste0(state, county)) 
# ## Inspect the datafr
# head(acs_demo)
# 
# acs_merged <- left_join(acs_demo, acs_broadband_pct, by = "county_FIPS")
