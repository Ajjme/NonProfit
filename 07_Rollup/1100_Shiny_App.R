# Load required packages
library(shiny)
library(leaflet)
# Define UI for application
ui <- fluidPage(
  titlePanel("City Electrification Update"),
  mainPanel(
    leafletOutput("map")
  )
)

# Define server logic
server <- function(input, output) {
  
  # Filter data based on selected city
  city_data <- reactive({
    full_df
  })
  
  # Generate color scale based on CO2 reduced values
  observe({
    color_scale <<- colorNumeric(palette = "YlGnBu", domain = city_data()$co2_reduced)
  })
  
  # Generate map
  output$map <- renderLeaflet({
    leaflet(city_data()) %>%
      addTiles(urlTemplate = "https://stamen-tiles-{s}.a.ssl.fastly.net/toner-lite/{z}/{x}/{y}{r}.png",
               attribution = 'Map tiles by <a href="https://stamen.com/">Stamen Design</a>, under <a href="https://creativecommons.org/licenses/by/3.0/">CC BY 3.0</a>. Data by <a href="https://openstreetmap.org">OpenStreetMap</a>, under <a href="https://creativecommons.org/licenses/by-sa/3.0/">CC BY SA</a>.') %>%
      setView(lng = -98, lat = 39, zoom = 4) %>%
      addCircleMarkers(lng = ~lon, lat = ~lat, radius = 6, fillColor = ~color_scale(co2_reduced),
                       color = "#000000", weight = 1, opacity = 1, fillOpacity = 0.8,
                       popup = ~paste0("<b>City:</b> ", city, "<br><b>CO2 Reduced:</b> ", co2_reduced, " metric tons"))
  })
}

# Run the application
shinyApp(ui = ui, server = server)