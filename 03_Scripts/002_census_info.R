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

### Looking at options -------------
#all_apis <- listCensusApis()
head(all_apis)

# Variables and geography levels available in ACS 5-yr subject dataset as of 2021
#full_options <- listCensusMetadata(name = "acs/acs1", vintage = 2021, type = "variables")

## Get selected broadband variable
acs_general_pct <- getCensus(name = "acs/acs1", vintage = 2021,
                               vars = c("B01001_001E", "B24134_241E", "B08201_003E" ,"B08201_004E", "B08201_005E", "B08201_006E", "B24116_450E"), # Selected broadband variables
                               region = "place:*", # '*' mean all counties
                               regionin = "state:06") # 06 is california state FIPS code

acs_general_pct <- acs_general_pct %>% 
  mutate_at(c('place'), as.character)%>% 
  mutate(place_FIPS = paste0(state, place)) %>% 
  rename(car_washes = B24134_241E,
         one_vehicles_available = B08201_003E,
         two_vehicles_available = B08201_004E,
         three_vehicles_available = B08201_005E,
         four_or_more_vehicles_available = B08201_006E,
         heavy_vehicles_available = B24116_450E) 


#this is wrong
# Load the place hierarchy file for California
#place_hier_ca <- read.csv("https://www2.census.gov/geo/docs/reference/codes/files/st06_ca_places.txt", sep="|", header=FALSE)
place_hier_ca <- read.csv("https://www2.census.gov/geo/docs/reference/codes/PLACElist.txt", sep="|", header=TRUE) %>% 
  clean_names() %>% 
  filter(state == "CA") %>% 
  mutate_at(c('placefp'), as.character)


#https://www2.census.gov/geo/docs/reference/codes/PLACElist.txt
# Merge the place hierarchy file with the ACS data

### lets do QC by comparing total population stats

acs_general_pct_ca_city <- left_join(acs_general_pct, place_hier_ca,
                                   by = c("place"= "placefp"))

saveRDS(acs_general_pct_ca_city, file = "./04_Outputs/rds/acs_general_pct_ca_city.rds")

### pull out home heating

### Archive --------------------
### Demographic---------------
## Educational Attainment, Age, and Unemployment from the ACS 2021 ##
acs_demo <- getCensus(name = "acs/acs5/profile", vintage = 2021,
                      vars = c("DP02_0066PE","DP02_0064PE","DP02_0065PE", # Education
                               "DP03_0009PE", # Unployment
                               "DP05_0007PE","DP05_0008PE", # GenZ
                               "DP05_0009PE","DP05_0010PE", # Millennials
                               "DP05_0011PE","DP05_0012PE", # GenX
                               "DP05_0013PE","DP05_0014PE","DP05_0015PE"), # Boomers
                      region = "county:*",
                      regionin = "state:48") 

acs_demo <- acs_demo %>% 
  mutate(county_FIPS = paste0(state, county)) 
## Inspect the datafr
head(acs_demo)

acs_merged <- left_join(acs_demo, acs_broadband_pct, by = "county_FIPS")
