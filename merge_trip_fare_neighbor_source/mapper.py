#!/usr/bin/python
import os
import sys
sys.path.append('.')
import matplotlib
matplotlib.use('Agg')
from matplotlib.path import Path
from rtree import index as rtree
import numpy,shapefile, time
import taxi_zones


yellowindex = [ 'medallion', 'hack_license', 'vendor_id', 'pickup_datetime']

yellowvalues = [ 'rate_code', 'store_and_fwd_flag','dropoff_datetime', \
'passenger_count','trip_time_in_secs','trip_distance','pickup_longitude', \
'pickup_latitude','dropoff_longitude','dropoff_latitude', 'payment_type', \
'fare_amount','surcharge','mta_tax','tip_amount','tolls_amount','total_amount' ]

yellowvars = yellowindex + yellowvalues

greenvars = ['pickup_datetime','dropoff_datetime', 'store_and_fwd_flag'	, \
'rate_code', 'pickup_longitude', 'pickup_latitude', 'dropoff_longitude',  \
'dropoff_latitude', 'passenger_count',	'trip_distance','fare_amount', \
'surcharge','mta_tax','tip_amount','tolls_amount','total_amount','payment_type']

vars_join = ['pickup_datetime','dropoff_datetime', 'store_and_fwd_flag'	, \
'rate_code', 'pickup_longitude', 'pickup_latitude', 'dropoff_longitude',  \
'dropoff_latitude', 'passenger_count',	'trip_distance','fare_amount', \
'surcharge','mta_tax','tip_amount','tolls_amount','total_amount','payment_type','pickup_borough','pickup_neighbor','dropoff_borough','dropoff_neighbor','pickup_zone','dropoff_zone','pickup_is_border','dropoff_is_border', 'color']


def findNeighborhood(location, index, neighborhoods):
    match = index.intersection((location[0], location[1], location[0], location[1]))
    for a in match:
        if any(map(lambda x: x.contains_point(location), neighborhoods[a][1])):
            return a
    return -1

def readNeighborhood(shapeFilename, index, neighborhoods):
    sf = shapefile.Reader(shapeFilename)
    for sr in sf.shapeRecords():
        if sr.record[1] not in ['New York', 'Kings', 'Queens', 'Bronx']: continue
        paths = map(Path, numpy.split(sr.shape.points, sr.shape.parts[1:]))
        bbox = paths[0].get_extents()
        map(bbox.update_from_path, paths[1:])
        index.insert(len(neighborhoods), list(bbox.get_points()[0])+list(bbox.get_points()[1]))
        neighborhoods.append((sr.record[1]+'_'+sr.record[3], paths))
    neighborhoods.append(('UNKNOWN_UNKNOWN', None))

index = rtree.Index()
neighborhoods = []
readNeighborhood('ZillowNeighborhoods-NY.shp', index, neighborhoods)



# input comes from STDIN (stream data that goes to the program)
for line in sys.stdin:

    #yellow path
    #if False:
    if 'yellow' in str(os.environ['mapreduce_map_input_file']):
        source = 'Y'
        full = line.strip().split(',')

        if full[0][0] == 'm':
            pass
        else:
            try:
                line = [full[yellowvars.index(i)] for i in greenvars]
                pickup_location = (float(line[4]), float(line[5]))
                dropoff_location = (float(line[6]), float(line[7]))
                pickup_location = neighborhoods[findNeighborhood(pickup_location, index, neighborhoods)][0].split('_')
                dropoff_location = neighborhoods[findNeighborhood(dropoff_location, index, neighborhoods)][0].split('_')
                pickup_zones = taxi_zones.taxi_zone_color(pickup_location[1], pickup_location[0])
                dropoff_zones = taxi_zones.taxi_zone_color(dropoff_location[1], dropoff_location[0])
                pickup_is_border = taxi_zones.is_green_taxi_neighborhood(pickup_location[1], pickup_location[0])
                dropoff_is_border = taxi_zones.is_green_taxi_neighborhood(dropoff_location[1], dropoff_location[0])
                output_list = line + pickup_location+dropoff_location + [pickup_zones, dropoff_zones, pickup_is_border, dropoff_is_border, source]
                print ','.join(map(str,  output_list))
            except:
                continue

    #green path
    else:
        source = 'G'
        full = line.strip().split(",")
        if full[0] == 'pickup_datetime':
            pass
        else:
            try:
                pickup_location = (float(full[4]), float(full[5]))
                dropoff_location = (float(full[6]), float(full[7]))
                pickup_location = neighborhoods[findNeighborhood(pickup_location, index, neighborhoods)][0].split('_')
                dropoff_location = neighborhoods[findNeighborhood(dropoff_location, index, neighborhoods)][0].split('_')
                pickup_zones = taxi_zones.taxi_zone_color(pickup_location[1], pickup_location[0])
                dropoff_zones = taxi_zones.taxi_zone_color(dropoff_location[1], dropoff_location[0])
                pickup_is_border = taxi_zones.is_green_taxi_neighborhood(pickup_location[1], pickup_location[0])
                dropoff_is_border = taxi_zones.is_green_taxi_neighborhood(dropoff_location[1], dropoff_location[0])
                output_list = line + pickup_location+dropoff_location + [pickup_zones, dropoff_zones, pickup_is_border, dropoff_is_border, source]
                print ','.join(map(str,  output_list))
            except:
                continue





