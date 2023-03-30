#initialization
#Install packages

# install.packages("tidyverse", type = "source")
# #install.packages("plotly", type = "source")
# #install.packages("rjson", type = "source")
# install.packages("ggplot2", type = "source")
# install.packages("dplyr", type = "source")
# #install.packages("geojsonio", type = "source")
# ##install.packages("leaflet")
# install.packages("leaflet")
#install.packages("janitor")
#install.packages("xlsx")


#Load Packages
library(tidyverse)
library(ggplot2)
library(plotly)
#library(rjson)
library(dplyr)
library(htmlwidgets)
library(jsonlite)
library(leaflet)
library(janitor)
library(ggthemes)
library(xlsx)

my_theme <- function(){
  theme_bw(base_size = 12) +
    theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold", color = "black"),
          axis.title.x = element_text(size = 12, color = "black"),
          axis.title.y = element_text(size = 12, color = "black"),
          axis.text.x = element_text(size = 10, color = "black"),
          axis.text.y = element_text(size = 10, color = "black"),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.border = element_blank(),
          panel.background = element_blank(),
          legend.position = "bottom",
          legend.title = element_blank(),
          legend.text = element_text(size = 10),
          legend.key.width = unit(1, "cm"),
          legend.key.height = unit(0.5, "cm"),
          legend.background = element_rect(fill = "white", size = 0.5, linetype = "solid", colour = "black"))
}