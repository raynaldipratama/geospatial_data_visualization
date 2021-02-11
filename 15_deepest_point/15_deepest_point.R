# LIBRARIES ----

# World map data from Natural Earth
library(rnaturalearth)
library(rnaturalearthdata)

# Data visualization
library(ggplot2)
library(ggspatial)

# Raster data
library(rgdal)

# Bathymetry data
library(marmap)

# 1.0 World map spatial data ----

# * Get the world map spatial data from Natural Earth ----

spdf_world <- ne_countries(scale = "medium", returnclass = "sf")

sldf_world <- ne_coastline(scale = "medium", returnclass = "sf")

# * Plot the world map ----

theme_set(theme_bw())

ggplot() +
  geom_sf(data = spdf_world, aes(fill = continent)) +
  xlab("Longitude") +
  ylab("Latitude") +
  ggtitle("World Map")

# 2.0 Plot the AOI: Bay of Biscay ----

# * Assign x-axis and y-axis limits ----

ggplot() +
  geom_sf(data = spdf_world) +
  geom_sf(data = sldf_world, size = 0.75) +
  coord_sf(xlim = c(-12, 2), ylim = c(40, 50), expand = FALSE)

# * Add map features ----

ggplot() +
  geom_sf(data = spdf_world) +
  geom_sf(data = sldf_world, size = 0.75) +
  annotation_scale(width_hint = 0.5, location = "bl") +
  annotation_north_arrow(
    location = "tl",
    height = unit(1.5, "cm"),
    width = unit(1.5, "cm"),
    pad_x = unit(0.25, "cm"),
    pad_y = unit(0.25, "cm"),
    style = north_arrow_fancy_orienteering
  ) +
  coord_sf(xlim = c(-12, 2), ylim = c(40, 50), expand = FALSE)

# * Final map ----

ggplot() +
  geom_sf(data = spdf_world) +
  geom_sf(data = sldf_world, size = 0.75) +
  annotation_scale(width_hint = 0.5, location = "bl") +
  annotation_north_arrow(
    location = "tl",
    height = unit(1.5, "cm"),
    width = unit(1.5, "cm"),
    pad_x = unit(0.25, "cm"),
    pad_y = unit(0.25, "cm"),
    style = north_arrow_fancy_orienteering
  ) +
  annotate(
    geom = "text",
    x = -6,
    y = 46,
    label = "Bay of Biscay",
    fontface = "italic",
    color = "darkblue",
    size = 4
  ) +
  coord_sf(xlim = c(-12, 2), ylim = c(40, 50), expand = FALSE) +
  theme(
    panel.grid.major = element_line(
      color = gray(0.5), linetype = "dashed", size = 0.5
    ),
    panel.background = element_rect(fill = "aliceblue")
  ) +
  xlab("Longitude") +
  ylab("Latitude") +
  ggtitle("Bay of Biscay")

# 3.0 The deepest point ----

# * Load the data ----

raster_data <- readGDAL("00_data/DEM_geotiff/alwdgg.tif")

raster_data_tf <- spTransform(
  raster_data,
  CRSobj = "+proj=longlat +ellps=WGS84"
)

class(raster_data_tf)

# * Extract depths and coordinates ----

depths <- slot(raster_data_tf, "data")

coords <- slot(raster_data_tf, "coords")

database <- cbind(coords, depths)

# * Specify the map coordinates limitation ----

lonmin <- -9

lonmax <- 0

latmin <- 42

latmax <- 48

BOB_area <- database[
  database[, 1] >= lonmin & database[, 1] <= lonmax &
    database[, 2] >= latmin & database[, 2] <= latmax,
]

deepest_point <- min(BOB_area[, 3])

deepest_point

deepest_point_row <- which.min(BOB_area[, 3])

deepest_point_lat <- BOB_area[deepest_point_row, 2]

deepest_point_lat

deepest_point_lon <- BOB_area[deepest_point_row, 1]

deepest_point_lon

# * Plot the deepest point ----

ggplot() +
  geom_sf(data = spdf_world) +
  geom_sf(data = sldf_world, size = 0.75) +
  annotation_scale(width_hint = 0.5, location = "bl") +
  annotation_north_arrow(
    location = "tl",
    height = unit(1.5, "cm"),
    width = unit(1.5, "cm"),
    pad_x = unit(0.25, "cm"),
    pad_y = unit(0.25, "cm"),
    style = north_arrow_fancy_orienteering
  ) +
  annotate(
    geom = "text",
    x = -6,
    y = 46,
    label = "Bay of Biscay",
    fontface = "italic",
    color = "darkblue",
    size = 4
  ) +
  annotate(
    geom = "point",
    x = deepest_point_lon,
    y = deepest_point_lat,
    colour = "red",
    size = 2
  ) +
  annotate(
    geom = "text",
    x = deepest_point_lon,
    y = 44.65,
    label = "Deepest point: -5036 m",
    size = 3
  ) +
  coord_sf(xlim = c(-12, 2), ylim = c(40, 50), expand = FALSE) +
  theme(
    panel.grid.major = element_line(
      color = gray(0.5), linetype = "dashed", size = 0.5
    ),
    panel.background = element_rect(fill = "aliceblue")
  ) +
  xlab("Longitude") +
  ylab("Latitude") +
  ggtitle("Bay of Biscay")

# * Plot the zonal and meridional transects ----

BOB_bathy <- as.bathy(BOB_area)

transect_zonal <- get.transect(
  BOB_bathy, -1, deepest_point_lat, -7, deepest_point_lat,
  distance = TRUE
)

plotProfile(transect_zonal, main = "Zonal Transect of the Deepest Point")

transect_meridional <- get.transect(
  BOB_bathy, deepest_point_lon, 43, deepest_point_lon, 47,
  distance = TRUE
)

plotProfile(
  transect_meridional,
  main = "Meridional Transect of the Deepest Point"
)
