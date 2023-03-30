
source("./03_Scripts/000_init.R")
### Inputs------------------
#may have to change downloaded name
zev_sales_county <- read_xlsx("./02_inputs/New_ZEV_Sales_Last_updated_01-18-2023.xlsx", sheet = "County")

zev_sales_zip <- read_xlsx("./02_inputs/New_ZEV_Sales_Last_updated_01-18-2023.xlsx", sheet = "ZIP")
