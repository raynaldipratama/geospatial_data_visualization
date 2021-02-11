# ACKNOWLEDGEMENT ----
# The codes written below were forked from Introduction to GIS available on
# https://atlan.com/courses/introduction-to-gis-r/

# LIBRARIES ----

# Spatial analysis
library(sf)
library(raster)
library(spData)

# Additional packages
library(tmap)
library(grid)

# 1.0 Basic map of NZ ----

basic_map_nz <- tm_shape(nz) +
  tm_fill(
    col = "Land_area",
    title = expression("Area (km sq)"),
    n = 10, palette = "YlGnBu"
  ) +
  tm_borders(lwd = 0.5) +
  tm_style("grey") +
  tm_layout(
    main.title = "Land Area of New Zealand",
    main.title.position = c("left"),
    main.title.size = 1,
    legend.position = c("left", "top"),
    legend.width = 0.5
  ) +
  tm_credits(
    "Source: Geocomputation in R",
    position = c("right", "bottom")
  )

basic_map_nz

# 2.0 Population and sex ratio in NZ ----

population_nz <- tm_shape(nz) +
  tm_fill(
    col = "Population",
    title = "No. Population",
    n = 10, palette = "YlOrBr"
  ) +
  tm_borders(lwd = 0.5) +
  tm_style("grey") +
  tm_layout(
    main.title = "Population in New Zealand",
    main.title.position = c("left"),
    main.title.size = 1,
    legend.position = c("left", "top"),
    legend.width = 0.5
  ) +
  tm_credits(
    "Source: Geocomputation in R",
    position = c("right", "bottom")
  )

population_nz

sex_ratio_nz <- tm_shape(nz) +
  tm_fill(
    col = "Sex_ratio",
    title = "Sex Ratio",
    palette = "OrRd"
  ) +
  tm_borders(lwd = 0.5) +
  tm_style("grey") +
  tm_layout(
    main.title = "Sex Ratio in New Zealand",
    main.title.position = c("left"),
    main.title.size = 1,
    legend.position = c("left", "top"),
    legend.width = 0.5
  ) +
  tm_credits(
    "Source: Geocomputation in R",
    position = c("right", "bottom")
  )

sex_ratio_nz

tmap_arrange(population_nz, sex_ratio_nz)

# 3.0 Median income in the Southern NZ ----

south_median_income <- nz %>%
  filter(Island == "South") %>%
  tm_shape() +
  tm_fill(
    col = "Median_income",
    title = "Median Income (NZD)",
    n = 10, palette = "Reds"
  ) +
  tm_borders(lwd = 0.5) +
  tm_text("Name", size = 0.5) +
  tm_layout(
    main.title = "Median Income in the Southern NZ",
    main.title.position = c("left"),
    main.title.size = 1,
    legend.position = c("left", "top"),
    legend.width = 0.5
  ) +
  tm_credits(
    "Source: Geocomputation in R",
    position = c("right", "bottom")
  )

inset <- nz %>%
  group_by(Island) %>%
  mutate(Southern_NZ = ifelse(Island == "South", TRUE, FALSE)) %>%
  tm_shape() +
  tm_fill(col = "Southern_NZ", palette = c("grey", "red")) +
  tm_style("cobalt") +
  tm_legend(show = FALSE)

south_median_income

print(inset, vp = viewport(0.65, 0.25, width = 0.25, height = 0.35))

# 4.0 Animated and interactive map ----

# * Animated map ----

nz_animation <- tm_shape(nz) +
  tm_fill(
    col = "Median_income",
    title = "Median Income (NZD)",
    palette = "OrRd"
  ) +
  tm_credits(
    "Source: Geocomputation in R",
    position = c("right", "bottom")
  ) +
  tm_facets(along = "Name", free.coords = FALSE)

tmap_animation(nz_animation, filename = "nz_animation.gif", delay = 100)

# * Zoomable map ----

tmap_mode(mode = "plot") # mode = "view" for interactive map

basic_map_nz
