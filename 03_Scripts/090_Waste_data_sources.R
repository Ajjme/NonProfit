# # Programs
# # https://www2.calrecycle.ca.gov/LGCentral/DiversionProgram/ProgramCountSummary
# 
# #rates multiple files
# https://www2.calrecycle.ca.gov/LGCentral/DiversionProgram/JurisdictionDiversionPost2006
# 
# #reporting 
# https://www2.calrecycle.ca.gov/RecyclingDisposalReporting/Reports
# 
# #individual land fills
# https://www2.calrecycle.ca.gov/RecyclingDisposalReporting/Reports/DisposalFacilitesAllocationTons
# 
# #business related break down!
# https://www2.calrecycle.ca.gov/WasteCharacterization/BusinessGroupStreams?lg=1007&cy=7

# [1] "Antioch"                                                
# [2] "Brentwood"                                              
# [3] "Central Contra Costa Solid Waste Authority (CCCSWA)"    
# [4] "Clayton"                                                
# [5] "Concord"                                                
# [6] "Contra Costa-Unincorporated"                            
# [7] "Martinez"                                               
# [8] "Pittsburg"                                              
# [9] "Pleasant Hill"                                          
# [10] "San Ramon"                                              
# [11] "West Contra Costa Integrated Waste Management Authority"
# [12] "Oakley"  


source("./03_Scripts/000_init.R")


# by land fill how much waste sent by Juristiction
#where the waste goes 2022 year filter county stacked bar or map (size/piechart) of total waste at each landfill by juristiction
total_tonnage_jurisdiction <- read_xlsx("./02_inputs/Waste/Jurisdiction/JurisdictionDisposalAndBeneficial use.xlsx") %>% 
  clean_names() 

#Stacked bargraph with Juristiction and type of waste - Filter for county then graph by Juris year is all 2022
total_tonnage_Jurisdiction_disposal <- read_xlsx("./02_inputs/Waste/Jurisdiction/OverallJurisdictionTonsForDisposal use.xlsx") %>% 
  clean_names() 

#What Type of waste is beneficial reuse in each landfill
#filter by landfill, sum up tonnage by waste typeall year 2022 ignore quarter can focus on must CCC Landfills
type_of_waste <- read_xlsx("./02_inputs/Waste/Jurisdiction/LandfillsBeneficialReuseTons map names.xlsx") %>% 
  clean_names() 

#Sheet 2
#Stacked or Pie chart of business groups use tonnage percents are within each
business_groups <- read_xlsx("./02_inputs/Waste/BusinessGroupsForAMaterial use.xlsx", sheet = "Data-Commercial Business Groups") %>% 
  clean_names() 



# enforcement make count table by year and then make line graph of number of enforcements by CARecycle
enforcement_data <- list.files(path = "./02_inputs/Waste/Enforcement",     
                       pattern = "*.xlsx", 
                       full.names = TRUE) %>%  
  lapply(read_excel) %>%                                            
  bind_rows

#diversion summaries 
#some data only to 2008
diversion_summaries <- list.files(path = "./02_inputs/Waste/Diversion_Summary",     
                               pattern = "*.xlsx", 
                               full.names = TRUE) %>%  
  lapply(read_excel) %>%                                            
  bind_rows



#complicated
distance_travelled_jurisdiction <- read_xlsx("./02_inputs/Waste/Jurisdiction/TotalJurisdictionDisposalTransferProcessor (Use).xlsx") %>% 
  clean_names() 
