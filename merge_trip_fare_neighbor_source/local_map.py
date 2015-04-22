#!/usr/bin/env python
import sys
sys.path.append('.')
import matplotlib
matplotlib.use('Agg')
from matplotlib.path import Path
from rtree import index as rtree
import numpy,shapefile, time
import taxi_zones
import pandas as pd

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

def parseInput():
    for line in sys.stdin:
        line = line.strip('\n')
        values = line.split(',')
        if len(values) > 1 and values[0] != 'medallion':
            yield values

def mapper():
    index = rtree.Index()
    neighborhoods = []
    readNeighborhood('ZillowNeighborhoods-NY.shp', index, neighborhoods)
    trip = pd.read_csv('/Users/Tian/Documents/NYU/2015_SPRING/Big_Data/project/yellow_taxi_data/FOIL2013/trip_data_1.csv')
    trip['pickup_borough'] = 0
    trip['pickup_neighbor'] = 0
    trip['dropoff_borough'] = 0
    trip['dropoff_neighbor'] = 0
    trip['zone'] = 0

    for i in range(len(trip)):
        print i
        values = list(trip.iloc[i])
        pickup_location = (float(values[10]), float(values[11]))
        dropoff_location = (float(values[12]), float(values[13]))
        pickup_location = neighborhoods[findNeighborhood(pickup_location, index, neighborhoods)][0].split('_')
        dropoff_location = neighborhoods[findNeighborhood(dropoff_location, index, neighborhoods)][0].split('_')
        zones = taxi_zones.taxi_zone_color(pickup_location[1], pickup_location[0])
        #print ','.join(map(str,  values))
        trip.iloc[i] = pd.Series(values + pickup_location+dropoff_location + [zones])

if __name__=='__main__':
    mapper()

