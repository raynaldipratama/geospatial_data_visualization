# ACKNOWLEDGEMENT ----
# The codes written below were forked from Automating GIS-processes 2020
# open course provided by Henrikki Tenkanen & Vuokko Heikinheimo,
# Department of Geosciences and Geography, University of Helsinki.

# 1.0 Get the network ----

import osmnx as ox
import networkx as nx
import geopandas as gpd
import pandas as pd
from pyproj import CRS

place_name = "Abando, Bilbao, Spain"

graph = ox.graph_from_place(place_name, network_type="drive")

fig, ax = ox.plot_graph(graph)

# Retrieve only edges from the graph
edges = ox.graph_to_gdfs(graph, nodes=False, edges=True)

# Check columns
edges.columns

# Check CRS
edges.crs

edges.head()

edges["highway"].value_counts()

# Project the data
graph_proj = ox.project_graph(graph)

# Get Edges and Nodes
nodes_proj, edges_proj = ox.graph_to_gdfs(
    graph_proj, nodes=True, edges=True
)

print("Coordinate system:", edges_proj.crs)

edges_proj.head()

CRS(edges_proj.crs).to_epsg()

# 2.0 Analyzing the network properties ----

# Calculate network statistics
stats = ox.basic_stats(graph_proj, circuity_dist="euclidean")
stats

# Get the Convex Hull of the network
convex_hull = edges_proj.unary_union.convex_hull

# Show output
convex_hull

# Calculate the area
area = convex_hull.area

# Calculate statistics with density information
stats = ox.basic_stats(graph_proj, area=area)

extended_stats = ox.extended_stats(graph_proj, ecc=True, cc=True)

# Add extened statistics to the basic statistics
for key, value in extended_stats.items():
    stats[key] = value

# Convert the dictionary to a Pandas series for a nicer output
pd.Series(stats)

# 3.0 Shortest path analysis ----

## Origin and destination points

# Set place name
place = "Edificio Euskalduna"

# Geocode the place name
geocoded_place = ox.geocode_to_gdf(place)

# Check the result
geocoded_place

# Re-project
geocoded_place.to_crs(CRS(edges_proj.crs), inplace=True)

# Get centroid as shapely point
origin = geocoded_place["geometry"].centroid.values[0]

print(origin)

nodes_proj.head()

# Retrieve the maximum x value (i.e. the most eastern)
maxx = nodes_proj["x"].max()

# Easternmost point
destination = nodes_proj.loc[nodes_proj["x"] == maxx, "geometry"].values[0]

print(destination)

## Nearest node

# Get origin x and y coordinates
orig_xy = (origin.y, origin.x)

# Get target x and y coordinates
target_xy = (destination.y, destination.x)

# Find the node in the graph that is closest to the origin point
# (here, we want to get the node id)
orig_node_id = ox.get_nearest_node(graph_proj, orig_xy, method="euclidean")
orig_node_id

# Find the node in the graph that is closest to the target point
# (here, we want to get the node id)
target_node_id = ox.get_nearest_node(graph_proj, target_xy, method="euclidean")
target_node_id

# Retrieve the rows from the nodes GeoDataFrame based on the node id
# (node id is the index label)
orig_node = nodes_proj.loc[orig_node_id]
target_node = nodes_proj.loc[target_node_id]

# Create a GeoDataFrame from the origin and target points
od_nodes = gpd.GeoDataFrame(
    [orig_node, target_node], geometry="geometry", crs=nodes_proj.crs
)

od_nodes.head()

## Routing

# Calculate the shortest path
route = nx.shortest_path(
    G=graph_proj, source=orig_node_id,
    target=target_node_id, weight="length"
)

# Show what we have
print(route)

# Plot the shortest path
fig, ax = ox.plot_graph_route(graph_proj, route)
