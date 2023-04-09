library(shiny)
library(plotly)

ui <- fluidPage(
  selectInput("var", "Select a variable:",
              choices = c("Total_Sales", "Electric_Nissan_Leaf", "Electric_Lucid_Air", "PHEV_BMW_X5")),
  plotlyOutput("plot")
)

server <- function(input, output) {
  var_sel <- reactive({
    switch(input$var,
           "Total_Sales" = join_county_fips$Total_Sales,
           "Electric_Nissan_Leaf" = join_county_fips$Electric_Nissan_Leaf,
           "Electric_Lucid_Air" = join_county_fips$Electric_Lucid_Air,
           "PHEV_BMW_X5" = join_county_fips$PHEV_BMW_X5)
  })
  
  output$plot <- renderPlotly({
    plot_ly(type = "choropleth",
            geojson = counties,
            locations = join_county_fips$fips,
            z = var_sel(),
            colorscale = "Blues",
            marker = list(line = list(width = 0))) %>%
      colorbar(title = "Total EV and PHEV Sales") %>%
      layout(title = "Total EV and PHEV Sales by County",
             geo = list(fitbounds = "locations", visible = FALSE))
  })
}

shinyApp(ui, server)