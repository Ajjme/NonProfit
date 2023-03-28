#Run this script first
#source("./03_Scripts/023_Shiny_prep.R")

# Load required packages
library(shiny)
library(leaflet)


# Define UI for application
ui <- fluidPage(
  titlePanel("CO2 Reduction by City"),
  sidebarLayout(
    sidebarPanel(
      helpText("Select a city to view CO2 reduction data"),
      selectInput("city", "City:", choices = unique(full_df$city))
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
    full_df %>%
      filter(city == input$city)
  })
  
  # Generate map
  output$map <- renderLeaflet({
    leaflet(city_data()) %>%
      addTiles() %>%
      setView(lng = -98, lat = 39, zoom = 4) %>%
      addMarkers(lng = ~lon, lat = ~lat, popup = ~paste0("<b>City:</b> ", city, "<br><b>CO2 Reduced:</b> ", co2_reduced, " metric tons"))
  })
}

# Run the application
shinyApp(ui = ui, server = server)
