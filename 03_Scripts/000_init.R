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
install.packages("xlsx")


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
#library(xlsx)
library(lubridate)
#Colors

#Clean names Function



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

my_enviro_theme <- function() {
  theme_bw(base_size = 12) +
    theme(
      plot.title = element_text(hjust = 0.5, size = 17, face = "bold", color = "black"),
      axis.title.x = element_text(size = 12, color = "black"),
      axis.title.y = element_text(size = 12, color = "black"),
      axis.text.x = element_text(size = 10, color = "black"),
      axis.text.y = element_text(size = 10, color = "black"),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      #panel.border = element_blank(),
      panel.background = element_blank(),
      legend.position = "bottom",
      legend.title = element_blank(),
      legend.text = element_text(size = 8, color = "black"),
      legend.key.width = unit(1, "cm"),
      legend.key.height = unit(0.5, "cm"),
      legend.background = element_rect(fill = "white", size = 0.5, linetype = "solid", colour = "black"),
      plot.background = element_rect(fill = "#F5F5F5"),
      panel.grid.major.y = element_line(colour = "#C8C8C8"),
      panel.grid.minor.y = element_line(colour = "#E5E5E5"),
      panel.grid.major.x = element_blank(),
      panel.grid.minor.x = element_blank(),
      axis.line = element_line(colour = "#008000"),
      axis.ticks = element_line(colour = "#008000"),
      axis.ticks.length = unit(0.3, "cm")
    )
}


my_Formal_theme <-  function() {
  theme_minimal(base_size = 12) +
    theme(plot.title = element_text(hjust = 0.5, size = 18, face = "bold", color = "#3e6b3b"),
          axis.title.x = element_text(size = 14, color = "#3e6b3b"),
          axis.title.y = element_text(size = 14, color = "#3e6b3b"),
          axis.text.x = element_text(size = 12, color = "#3e6b3b"),
          axis.text.y = element_text(size = 12, color = "#3e6b3b"),
          panel.grid.major = element_line(color = "#c2c2c2"),
          panel.grid.minor = element_line(color = "#c2c2c2", linetype = "dashed"),
          panel.border = element_blank(),
          panel.background = element_rect(fill = "#f4f4f4", color = "#c2c2c2"),
          legend.position = "bottom",
          legend.title = element_blank(),
          legend.text = element_text(size = 12, color = "#3e6b3b"),
          legend.key.width = unit(1, "cm"),
          legend.key.height = unit(0.5, "cm"),
          legend.background = element_rect(fill = "#f4f4f4", size = 0.5, linetype = "solid", colour = "#c2c2c2"))
}
