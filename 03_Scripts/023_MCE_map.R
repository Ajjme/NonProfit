
# source("./03_Scripts/000_init.R")
# 
# source("./03_Scripts/020_MCE_processing.R")


# Import the data
glimpse(full_mce)

# Load required packages
library(shiny)
library(leaflet)

# Load data
co2_data <- full_mce %>%
  select(community, co2_reduced) %>%
  rename(city = community) %>% 
  mutate(co2_reduced = as.numeric(co2_reduced)) %>%
  na.omit()

# Define UI for application
ui <- fluidPage(
  titlePanel("CO2 Reduction by City"),
  sidebarLayout(
    sidebarPanel(
      helpText("Select a city to view CO2 reduction data"),
      selectInput("city", "City:", choices = unique(co2_data$City))
    ),
    mainPanel(
      leafletOutput("map")
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  # Filter data based on selected city
  city_data <- reactive({
    co2_data %>%
      filter(city == input$city)
  })
  
  # Generate map
  output$map <- renderLeaflet({
    leaflet(city_data()) %>%
      addTiles() %>%
      setView(lng = -98, lat = 39, zoom = 4) %>%
      addMarkers(lng = ~Longitude, lat = ~Latitude, popup = ~paste0("<b>City:</b> ", city, "<br><b>CO2 Reduced:</b> ", co2_reduced, " metric tons"))
  })
}

# Run the application
shinyApp(ui = ui, server = server)
