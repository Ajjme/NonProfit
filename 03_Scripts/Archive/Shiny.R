#SHiny
# install.packages("shiny")
# install.packages("RColorBrewer")
library(shiny)
library(leaflet)
library(RColorBrewer)

ui <- bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("map", width = "100%", height = "100%"),
  absolutePanel(top = 10, right = 10,
                sliderInput("range", "Magnitudes", min(EV_stations$Total_stations), max(EV_stations$Total_stations),
                            value = range(EV_stations$Total_stations), step = 0.1
                ),
                selectInput("colors", "Color Scheme",
                            rownames(subset(brewer.pal.info, category %in% c("seq", "div")))
                ),
                checkboxInput("legend", "Show legend", TRUE)
  )
)

server <- function(input, output, session) {
  
  # Reactive expression for the data subsetted to what the user selected
  filteredData <- reactive({
    EV_stations[EV_stations$Total_stations >= input$range[1] & EV_stations$Total_stations <= input$range[2],]
  })
  
  # This reactive expression represents the palette function,
  # which changes as the user makes selections in UI.
  colorpal <- reactive({
    colorNumeric(input$colors, EV_stations$Total_stations)
  })
  
  output$map <- renderLeaflet({
    # Use leaflet() here, and only include aspects of the map that
    # won't need to change dynamically (at least, not unless the
    # entire map is being torn down and recreated).
    leaflet(EV_stations) %>% addTiles() #%>%
    #fitBounds(~(-140), ~(35), ~(-120), ~(38))
    #fitBounds(~min(long), ~min(lat), ~max(long), ~max(lat))
  })
  # 
  # Incremental changes to the map (in this case, replacing the
  # circles when a new color is chosen) should be performed in
  # an observer. Each independent set of things that can change
  # should be managed in its own observer.
  observe({
    pal <- colorpal()
    
    leafletProxy("map", data = filteredData()) %>%
      clearShapes() %>%
      addCircles(radius = ~10^Total_stations/10, weight = 1, color = "#777777",
                 fillColor = ~pal(Total_stations), fillopacity = 0.7, popup = ~paste(Total_stations)
      )
  })
  
  # Use a separate observer to recreate the legend as needed.
  observe({
    proxy <- leafletProxy("map", data = EV_stations)
    
    # Remove any existing legend, and only if the legend is
    # enabled, create a new one.
    proxy %>% clearControls()
    if (input$legend) {
      pal <- colorpal()
      proxy %>% addLegend(position = "bottomright",
                          pal = pal, values = ~Total_stations
      )
    }
  })
}

shinyApp(ui, server)