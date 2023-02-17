#################################################### Script for ARG Genomic Change Map  ########################################################

#creates map and plots lat/lon coordinates for studies that observed genomic change on coral reefs
#outputted figure annotated by hand to add fish/coral clipart & legend

#################################################################################################################################################

######## Set-up ########

remove(list = ls())

#load libraries
library(maps)
library(mapdata)
library(tidyverse)
library(ggthemes)

#pull world map data
world_map <- map_data("world") %>% 
  filter(! long > 180)

#################################################################################################################################################

######## Create map ########

#### create dataframe with lat/lon coordinates ####

lat <- c(-13.99999, 24.82097, 32.18943, 34.32141, 19.4293, -18.5692, 
         25.2258, 21.27436, 18.46695, 23.0627, 18.8425) #lat coordinates from 11 examples (pulled from papers)
lon <- c(121.83333, -81.29057, 129.9633, 139.2051, -76.48578, 146.495, 
         -77.86836, -157.7173, -77.40827, -161.921, -72.933) #lon coordinates from 11 examples (pulled from papers)
latlon_df <- as.data.frame(cbind(lat, lon)) #merge togther

#### Plot coordinates ####

#subset to cutoff map edges
world_map <- map_data("world") %>% 
  filter(! long > 180)

#create map
globalchange_plot <- world_map %>% 
  ggplot(aes(map_id = region)) +
  geom_map(map = world_map) +
  expand_limits(x = world_map$long, y = world_map$lat) + 
  geom_point(data = latlon_df, aes(x = lon, y = lat), size = 12, inherit.aes = FALSE) + 
  theme_map()
globalchange_plot
