

source("./03_Scripts/000_init.R")

#Stacked bargraph with Juristiction and type of waste - Filter for county then graph by Juris year is all 2022
total_tonnage_Jurisdiction_disposal <- read_xlsx("./02_inputs/Waste/Jurisdiction/OverallJurisdictionTonsForDisposal use.xlsx") %>% 
  clean_names() %>% 
  filter(county == "Contra Costa") %>%
  select(-year, -county) %>%
  group_by(jurisdiction)  %>% 
  mutate(total_waste = rowSums(across(where(is.numeric)), na.rm = TRUE)) %>% 
  select(jurisdiction, total_waste) %>% 
  mutate(jurisdiction = case_when(jurisdiction == "West Contra Costa Integrated Waste Management Authority" ~ "WCCIWMA",
                                  jurisdiction == "Central Contra Costa Solid Waste Authority (CCCSWA)" ~ "CCCSWA",
                                  #jurisdiction == "Contra Costa/Ironhouse/Oakley Regional Agency" ~ "Oakley",
                                  jurisdiction == "Contra Costa-Unincorporated" ~ "Unincorporated CCC",
                                  TRUE ~ jurisdiction))


total_tonnage <- ggplotly(
  ggplot(total_tonnage_Jurisdiction_disposal, aes(x = jurisdiction, y = total_waste)) +
    geom_bar(stat = "identity", fill = "tan", color = "black") +
    labs( x = "Jurisdiction", y = "Landfill Tonnage") +
    theme(legend.position = "bottom", axis.text.x = element_text(angle = 45, hjust = 1), panel.background = element_blank())
)
total_tonnage
saveRDS(total_tonnage, file = "./06_Reports_Rmd/total_tonnage.rds")





#Disposal rate in other script

# #Need Weighting values
# population <- readRDS(file = "./04_Outputs/rds/full_ccc_census.rds") %>% 
#   clean_names() %>% 
#   select(city, total_pop) %>% 
#   mutate(city = if_else(city == "Uni_CCC", "Uni. CCC", city)) 
# 
# 
# #standardize ----------------
# solar_city_standardized <- full_join(population, city_totals_solar_uni_ccc, by = "city") %>% 
#   mutate(solar_per_pop= (total_size_ac/total_pop)) %>% 
#   mutate(solar_per_pop_scaled = 100 * solar_per_pop / max(solar_per_pop))
# 
# 
# saveRDS(solar_city_standardized, file = "./06_Reports_Rmd/solar_city_standardized.rds")