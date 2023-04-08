library(plotly)
library(htmlwidgets) # to use the 'onRender' function


dat <- iris[1:2, ]
urls <- c("http://google.com", "https://stackoverflow.com")

# Create the plotly bar chart and make the bars clickable
p <- plot_ly(dat, x = ~Species, y = ~Sepal.Length, type = "bar", 
             customdata = urls, hovertemplate = "<a href='%{customdata}'>%{y}</a>")

js <- "
function(el, x) {
  el.on('plotly_click', function(d) {
    var point = d.points[0];
    var url = point.data.customdata[point.pointIndex];
    window.open(url);
  });
}"

p %>% onRender(js)