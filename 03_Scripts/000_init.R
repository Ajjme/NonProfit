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

library(dplyr)
library(htmlwidgets)
library(jsonlite)
library(leaflet)
library(janitor)
library(ggthemes)
library(readxl)
library(xlsx)
library(lubridate)
#Colors

#Be sure to set the entire column to lower case first
#Clean names Function
#function only works if you have a column named city
clean_city_names <- function(x){
  xx <- x %>% 
    mutate(city =
             case_when(
               str_detect(city, "anti") ~ "Antioch",
               str_detect(city, "brent") ~ "Brentwood",
               str_detect(city, "clay") ~ "Clayton",
               str_detect(city, "conc") ~ "Concord",
               str_detect(city, "danv") ~ "Danville",
               str_detect(city, "cerr") ~ "El Cerrito",
               str_detect(city, "herc") ~ "Hercules",
               str_detect(city, "lafa") ~ "Lafayette",
               str_detect(city, "mart") ~ "Martinez",
               str_detect(city, "mora") ~ "Moraga",
               str_detect(city, "oakl") ~ "Oakley",
               str_detect(city, "orin") ~ "Orinda",
               str_detect(city, "pino") ~ "Pinole",
               str_detect(city, "pitt") ~ "Pittsburg",
               str_detect(city, "pleas") ~ "Pleasant Hill",
               str_detect(city, "rich") ~ "Richmond",
               str_detect(city, "pablo") ~ "San Pablo",
               str_detect(city, "ramo") ~ "San Ramon",
               str_detect(city, "waln") ~ "Walnut Creek",
               str_detect(city, "uni") ~ "Uni. CCC",
               TRUE ~ city ))
}

clean_city_names_uni_ccc <- function(x){
  xx <- x %>% 
    mutate(city =
             case_when(
               str_detect(city, "anti") ~ "Antioch",
               str_detect(city, "brent") ~ "Brentwood",
               str_detect(city, "clay") ~ "Clayton",
               str_detect(city, "conc") ~ "Concord",
               str_detect(city, "danv") ~ "Danville",
               str_detect(city, "cerr") ~ "El Cerrito",
               str_detect(city, "herc") ~ "Hercules",
               str_detect(city, "lafa") ~ "Lafayette",
               str_detect(city, "mart") ~ "Martinez",
               str_detect(city, "mora") ~ "Moraga",
               str_detect(city, "oakl") ~ "Oakley",
               str_detect(city, "orin") ~ "Orinda",
               str_detect(city, "pino") ~ "Pinole",
               str_detect(city, "pitt") ~ "Pittsburg",
               str_detect(city, "pleas") ~ "Pleasant Hill",
               str_detect(city, "rich") ~ "Richmond",
               str_detect(city, "pablo") ~ "San Pablo",
               str_detect(city, "ramo") ~ "San Ramon",
               str_detect(city, "waln") ~ "Walnut Creek",
               str_detect(city, "uni") ~ "Uni. CCC",
               TRUE ~ "Uni. CCC" ))
}

my_future_theme <- function() {
  theme_minimal(base_size = 14) +
    theme(
      panel.grid.major = element_line(color = "#ECECEC"),
      panel.grid.minor = element_blank(),
      panel.border = element_blank(),
      legend.background = element_rect(fill = "transparent", color = NA),
      legend.position = c(0.85, 0.15),
      legend.text = element_text(size = 12),
      plot.title = element_text(size = 24, hjust = 0.5, face = "bold"),
      axis.title = element_text(size = 16),
      axis.text = element_text(size = 14, color = "#666666"),
      plot.background = element_rect(fill = "#F9F9F9"),
      panel.background = element_rect(fill = "white"),
      plot.margin = unit(c(1,1,1,1), "cm")
    )
}
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
