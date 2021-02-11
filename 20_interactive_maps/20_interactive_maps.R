# ACKNOWLEDGEMENT ----
# The codes written below were forked from Building Interactive Maps with Leaflet
# by Teja Kodali in R bloggers.

# Data wrangling
library(dplyr)

# Interactive web maps
library(leaflet)

# Additional package
library(magrittr)

# 1.0 Basic map of Boston ----

map_boston <- leaflet() %>%
  addProviderTiles(providers$Stamen.Toner) %>%
  setView(-71.038887, 42.364506, zoom = 13) %>%
  addMarkers(-71.05775, 42.3605, popup = "Boston City Hall")

map_boston

# 2.0 Load the data ----

data_boston <- read.csv("00_data/Charging_Stations.csv")

table(data_boston$EV_Connector_Types)

data_charging_stations <- data_boston %>%
  filter(data_boston$EV_Connector_Types == "J1772" |
    data_boston$EV_Connector_Types == "TESLA")

# 3.0 Plot all selected charging stations on the map ----

map_boston <- leaflet() %>%
  addProviderTiles(providers$Stamen.Toner) %>%
  setView(-71.038887, 42.364506, zoom = 12) %>%
  addMarkers(
    data = data_charging_stations,
    lng = data_charging_stations$Longitude,
    lat = data_charging_stations$Latitude,
    popup = data_charging_stations$Station_Name
  )

map_boston

# 4.0 Cluster the markers ----

map_boston <- leaflet() %>%
  addProviderTiles(providers$Stamen.Toner) %>%
  setView(-71.038887, 42.364506, zoom = 12) %>%
  addCircleMarkers(
    data = data_charging_stations,
    lng = data_charging_stations$Longitude,
    lat = data_charging_stations$Latitude,
    radius = 3,
    color = ifelse(
      data_charging_stations$EV_Connector_Types == "J1772", "red", "blue"
    ),
    clusterOptions = markerClusterOptions(),
    popup = data_charging_stations$Station_Name
  )

map_boston
