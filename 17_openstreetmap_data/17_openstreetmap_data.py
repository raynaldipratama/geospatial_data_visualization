# ACKNOWLEDGEMENT ----
# The codes written below were forked from Automating GIS-processes 2020
# open course provided by Henrikki Tenkanen & Vuokko Heikinheimo,
# Department of Geosciences and Geography, University of Helsinki.

# 1.0 Street network ----

import osmnx as ox

import matplotlib.pyplot as plt

# Specify the name that is used to seach for the data
place_name = "Etterbeek, Brussels-Capital, 1040, Belgium"

# Fetch OSM street network from the location
graph = ox.graph_from_place(place_name)

type(graph)

fig, ax = ox.plot_graph(graph)

# 2.0 Graph to GeoDataFrame ----

# Retrieve nodes and edges
nodes, edges = ox.graph_to_gdfs(graph)

nodes.head()

edges.head()

# 3.0 Place polygon ----

# Get place boundary related to the place name as a geodataframe
area = ox.geocode_to_gdf(place_name)

# Check the data type
type(area)

# Check data values
area

# Plot the area
area.plot()

# 4.0 Building footprints ----

# List key-value pairs for tags
tags = {"building": True}

buildings = ox.geometries_from_place(place_name, tags)

len(buildings)

buildings.head()

buildings.columns

# 5.0 Points-of-interest ----

# List key-value pairs for tags
tags = {"amenity": "parking"}

# Retrieve parking (car park)
parking = ox.geometries_from_place(place_name, tags)

# How many car parks do we have?
len(parking)

# Available columns
parking.columns.values

# Select some useful cols and print
cols = ["unique_id", "access", "nodes", "parking", "geometry"]

# Print only selected cols
parking[cols].head(10)

# 6.0 Plotting the data ----

fig, ax = plt.subplots(figsize=(12, 8))

# Plot the footprint
area.plot(ax=ax, facecolor="black")

# Plot street edges
edges.plot(ax=ax, linewidth=1, edgecolor="dimgray")

# Plot buildings
buildings.plot(ax=ax, facecolor="silver", alpha=0.7)

# Plot parking
parking.plot(ax=ax, color="red", alpha=1, markersize=10)

plt.tight_layout()
