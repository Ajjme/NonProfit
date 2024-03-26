


source("./03_Scripts/000_init.R")

#What Type of waste is beneficial reuse in each landfill
#filter by landfill, sum up tonnage by waste typeall year 2022 ignore quarter can focus on must CCC Landfills
type_of_waste <- read_xlsx("./02_inputs/Waste/LandfillsBeneficialReuseTons map names.xlsx") %>% 
  clean_names() %>% 
  group_by(reporting_entity, beneficial_reuse_category) %>% 
  summarise(tons_used = sum(tons_used)) 

my_list <- list("Acme Landfill", "Foothill Sanitary Landfill",
"Forward Landfill",
"Keller Canyon Landfill",
"L and D Landfill Limited Partnership" ,
"North County Recycling Center & Sanitary Landfill",
"Potrero Hills Landfill, Inc.",
"Recology Hay Road",
"Redwood Landfill") 

### need to verify
type_of_waste_ccc <- type_of_waste %>% 
  filter(reporting_entity %in% my_list) %>% 
  rename(`Beneficial Reuse Category` = beneficial_reuse_category)

#need to know which landfills are in Contra costa


plot_reuse <- 
  ggplot(type_of_waste_ccc, aes(x = reporting_entity, y = tons_used, fill = `Beneficial Reuse Category`, text = paste("Reuse Material: ", `Beneficial Reuse Category`, "<br>Tons Used: ", tons_used))) +
  geom_bar(stat = "identity") +
  labs(title = "Beneficial Reuse", x = "Reporting Entity", y = "Tons Used") +
  theme(axis.title.y = element_text(hjust = 1),
        panel.grid.major.y = element_line(color = "gray"),
        panel.background = element_rect(fill = "white"),
        axis.text.x = element_text(angle = 45, hjust = 0.5))


plot_reuse

saveRDS(plot_reuse, file = "./06_Reports_Rmd/plot_reuse.rds")

