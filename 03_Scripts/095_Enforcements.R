
source("./03_Scripts/000_init.R")

# enforcement make count table by year and then make line graph of number of enforcements by CARecycle
enforcement_data <- list.files(path = "./02_inputs/Waste/Enforcement",     
                               pattern = "*.xlsx", 
                               full.names = TRUE) %>%  
  lapply(read_excel) %>%                                            
  bind_rows

enforcement_data_date <- enforcement_data %>% 
  clean_names() %>% 
  mutate(castedDate = lubridate::ymd(order_date),
         year = year(castedDate))

count_enforcement <- enforcement_data_date %>% 
  group_by(year) %>% 
  summarise(number_of_enforcements = n())


fig <- plot_ly(count_enforcement, x = ~year, y = ~number_of_enforcements, type = 'scatter', mode = 'lines', marker = list(symbol = 'circle', size = 10)) %>% 
  layout(
    xaxis = list(title = 'Year'),
    yaxis = list(title = 'Number of Enforcements')
  )

fig
saveRDS(fig, file = "./06_Reports_Rmd/enforcement.rds")


