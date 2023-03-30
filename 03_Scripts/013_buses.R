
source("./03_Scripts/000_init.R")
### Inputs------------------
#may have to change downloaded name
buses <- read_xlsx("./02_inputs/School_Bus_and_School_Bus_Charger_Last_updated_01-30-2023.xlsx", sheet= "School Bus and Charger")

# California Energy Commission School Bus Replacement Program to replace California's
# oldest diesel buses with all-new battery electric buses and install supporting charging 
# infrastructure. This dashboard will be updated quarterly to display the progress in delivering
# CEC awarded electric school buses and installing charging infrastructure throughout California.
# The California Air Resources Board (CARB) also funds electric school buses and supports the transition
# to a zero-emission school bus fleet.