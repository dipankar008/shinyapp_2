counties <- readRDS("counties.rds")
library(ggplot2)

counties_map <- map_data("county")

counties_map$name <- paste(counties_map$region,counties_map$subregion, sep = ",")

library(dplyr)

a <- full_join(counties_map,counties)
"Percent White"= counties$white, 
"Percent Black " = counties$black, 
" Percent Latino" = counties$hispanic, 
"Percent Asian" = counties$asian