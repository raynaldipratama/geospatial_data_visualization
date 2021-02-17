# ACKNOWLEDGEMENT ----
# The codes written below were forked from SpatialThoughts' course
# by Ujaval Gandhi: Python Foundation for Spatial Analysis.

# 1.0 Reading CSV files ----

# * Load the data ----

import csv

import os

data_pkg_path = "00_data"

filename = "worldcities.csv"

path = os.path.join(data_pkg_path, filename)

f = open(path, "r")

csv_reader = csv.DictReader(f, delimiter=",", quotechar='"')

print(csv_reader)

f.close()

# * FIltering rows ----

home_country = "Spain"

num_cities = 0

with open(path, "r", encoding="utf-8") as f:
    csv_reader = csv.DictReader(f)

    for row in csv_reader:
        if row["country"] == home_country:
            num_cities += 1

print(num_cities)

# 2.0 Calculating distance ----

# * Get the coordinates ----

home_city = "Bilbao"

home_city_coordinates = ()

with open(path, "r", encoding="utf-8") as f:
    csv_reader = csv.DictReader(f)

    for row in csv_reader:
        if row["city_ascii"] == home_city:
            lat = row["lat"]
            lng = row["lng"]
            home_city_coordinates = (lat, lng)
            break

print(home_city_coordinates)

# * Calculate the distance ----

from geopy import distance

counter = 0

with open(path, "r", encoding="utf-8") as f:
    csv_reader = csv.DictReader(f)

    for row in csv_reader:
        if (row["country"] == home_country and
                row["city_ascii"] != home_city):
            city_coordinates = (row["lat"], row["lng"])
            city_distance = distance.geodesic(
                city_coordinates, home_city_coordinates).km
            print(row["city_ascii"], city_distance)
            counter += 1

        if counter == 5:
            break

# 3.0 Writing files ----

# * Specify the output directory ----

output_dir = "00_output"

if not os.path.exists(output_dir):
    os.mkdir(output_dir)

# * Write the file ----

output_filename = "cities_distance.csv"

output_path = os.path.join(output_dir, output_filename)

with open(output_path, mode="w", encoding="utf-8") as output_file:
    fieldnames = ["city", "distance_from_home"]
    csv_writer = csv.DictWriter(output_file, fieldnames=fieldnames)
    csv_writer.writeheader()

    # Now we read the input file, calculate distance and
    # write a row to the output
    with open(path, "r", encoding="utf-8") as f:
        csv_reader = csv.DictReader(f)
        for row in csv_reader:
            if (row["country"] == home_country and
                    row["city_ascii"] != home_city):
                city_coordinates = (row["lat"], row["lng"])
                city_distance = distance.geodesic(
                    city_coordinates, home_city_coordinates).km
                csv_writer.writerow(
                    {"city": row["city_ascii"],
                     "distance_from_home": city_distance}
                )

# * Automate the process ----

# The function below works for writing files (for multiple cities) to automate
# the process without changing home_city, home_country and output_filename


def write_distance_file(home_city, home_country, output_filename):
    data_pkg_path = "00_data"
    input_filename = "worldcities.csv"
    input_path = os.path.join(data_pkg_path, input_filename)
    output_dir = "00_output"
    output_path = os.path.join(output_dir, output_filename)

    with open(input_path, "r", encoding="utf-8") as input_file:
        csv_reader = csv.DictReader(input_file)
        for row in csv_reader:
            if row["city_ascii"] == home_city:
                home_city_coordinates = (row["lat"], row["lng"])
                break

    with open(output_path, mode="w") as output_file:
        fieldnames = ["city", "distance_from_home"]
        csv_writer = csv.DictWriter(output_file, fieldnames=fieldnames)
        csv_writer.writeheader()

        with open(input_path, "r", encoding="utf-8") as input_file:
            csv_reader = csv.DictReader(input_file)
            for row in csv_reader:
                if (row["country"] == home_country and
                        row["city_ascii"] != home_city):
                    city_coordinates = (row["lat"], row["lng"])
                    city_distance = distance.geodesic(
                        city_coordinates, home_city_coordinates).km
                    csv_writer.writerow(
                        {"city": row["city_ascii"],
                         "distance_from_home": city_distance}
                    )

    print("Successfully written output file at {}".format(output_path))

write_distance_file("Copenhagen", "Denmark", "copenhagen_distance.csv")

write_distance_file("Helsinki", "Finland", "helsinki_distance.csv")
