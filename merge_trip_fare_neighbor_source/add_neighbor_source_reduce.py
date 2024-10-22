#!/usr/bin/env python
import os
import sys
sys.path.append('.')
import matplotlib
matplotlib.use('Agg')
from matplotlib.path import Path
from rtree import index as rtree
import numpy,shapefile, time
import taxi_zones

vars_join = ['pickup_datetime','dropoff_datetime', 'store_and_fwd_flag'	, \
'rate_code', 'pickup_longitude', 'pickup_latitude', 'dropoff_longitude',  \
'dropoff_latitude', 'passenger_count',	'trip_distance','fare_amount', \
'surcharge','mta_tax','tip_amount','tolls_amount','total_amount','payment_type','pickup_borough','pickup_neighbor','dropoff_borough','dropoff_neighbor','zone','color']


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

#def parseInput():
#    for line in sys.stdin:
#        line = line.strip('\n')
#        values = line.split(',')
#        if len(values) > 1 and values[0] != 'medallion':
#            yield values

def reducer():
    index = rtree.Index()
    neighborhoods = []
    readNeighborhood('ZillowNeighborhoods-NY.shp', index, neighborhoods)
    for line in sys.stdin:
        source, value = line.strip().split('\t')
        values = value.strip().split(',')
        try:
            pickup_location = (float(values[4]), float(values[5]))
            dropoff_location = (float(values[6]), float(values[7]))
        except:
            continue
        pickup_location = neighborhoods[findNeighborhood(pickup_location, index, neighborhoods)][0].split('_')
        dropoff_location = neighborhoods[findNeighborhood(dropoff_location, index, neighborhoods)][0].split('_')
        zones = taxi_zones.taxi_zone_color(pickup_location[1], pickup_location[0])
        #print ','.join(map(str,  values))
        output_list = values + pickup_location+dropoff_location + [zones] + [source]
        print ','.join(map(str,  output_list))

if __name__=='__main__':
    print ','.join(map(str, vars_join))
    reducer()

