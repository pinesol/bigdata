import pandas as pd
import numpy as np
import geopy
from geopy.geocoders import Nominatim
import geocoder

geolocator = Nominatim()


def transform_gps2zip(lat_string, log_string):
    location = geolocator.reverse(log_string+','+lat_string)
    #g = geocoder.google([lat_string, log_string], method='reverse')
    address = location.address
    try:
        #address = g.json['neighborhood']
        zip_code = str([s.strip() for s in address.split(',') if s.strip().isdigit() and len(s.strip()) == 5][0])
        return zip_code
        #return address
    except:
        return 0


def transform_address2gps(address):
    location = geolocator.geocode(address)
    return [location.latitude, location.longitude]


def subway_nearest_neighbor(sub_dic, la_long_list):
    smallest = None
    key = None
    for subway in sub_dic.keys():
        distance = np.sum((np.array(sub_dic[subway]) - np.array(la_long_list))**2)
        if smallest:
            if smallest > distance:
                smallest = distance
                key = subway
        else:
            smallest = distance
            key = subway
    return key