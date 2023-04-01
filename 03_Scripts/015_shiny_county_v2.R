## it works!

# Define UI ----
ui <- fluidPage(
  
  titlePanel("EV and PHEV Sales by County"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("var_select", "Select a variable:",
                  choices = names(join_county_fips)[-c(1:3)], selected = "Total_Sales")
    ),
    mainPanel(
      plotlyOutput("map")
    )
  )
)

# Define server ----
server <- function(input, output) {
  
  output$map <- renderPlotly({
    
    # Create a new variable for the selected column
    sel_var <- input$var_select
    
    # Create the map with the selected variable
    fig <- plot_ly()
    fig <- fig %>% add_trace(
      type = "choropleth",
      geojson = counties,
      locations = join_county_fips$fips,
      z = join_county_fips[[sel_var]],
      colorscale = "Blues",
      marker = list(line = list(width = 0))
    )
    fig <- fig %>% colorbar(title = sel_var)
    fig <- fig %>% layout(
      title = paste("EV and PHEV Sales by County -", sel_var),
      geo = list(fitbounds = "locations", visible = FALSE)
    )
    
    fig
  })
  
}

# Run the app ----
shinyApp(ui = ui, server = server)