#!/usr/bin/python

'''Functions that map a taxi's neighborhood and bourough to a taxi zone: 'yellow' or 'green'.
If a neighborhood or borough is mispelled, this assumes the zone is 'yellow'.
'''

__author__ = 'Alex Pine'


GREEN_MANHATTAN_NEIGHBORHOODS = [
    'astor row',
    'fort george',
    'central harlem',
    'east harlem',
    'hamilton heights',
    'harlem',
    'hudson heights',
    'inwood',
    'le petit senegal',
    'little senegal',
    'marble hill',
    'manhattan valley',
    'manhattanville',
    'morningside heights',
    'spanish harlem',
    'sugar hill',
    'washington heights',
    'west harlem']

GREEN_BOROUGHS = [
    'bronx',
    'brooklyn',
    'kings',
    'queens',
    'staten island',
    'the bronx']

GREEN_BORDER_NEIGHBORHOODS = [
    # Manhattan
    'east harlem',
    'harlem',
    'manhattanville',
    'morningside heights',
    'spanish harlem',
    # Queens
    'astoria',
    'astoria-long island city',
    'long island city',
    'sunny side',    
    'sunnyside',
    # Brooklyn
    'carroll gardens',
    'cobble hill',
    'downtown',
    'dumbo',
    'red hook',
    'williamsburg',
]

def is_green_taxi_neighborhood(neighborhood, borough):
    return (borough.lower() in GREEN_BOROUGHS 
            or neighborhood.lower() in GREEN_MANHATTAN_NEIGHBORHOODS)

def taxi_zone_color(neighborhood, borough):
    return 'green' if is_green_taxi_neighborhood(neighborhood, borough) else 'yellow'

def is_green_border_neighborhood(neighborhood):
    return neighborhood.lower() in GREEN_BORDER_NEIGHBORHOODS


if __name__ == '__main__':
    print 'Running tests...'
    assert is_green_taxi_neighborhood('harlem', 'new york')
    assert is_green_taxi_neighborhood('fake queens neighborhood', 'queens')
    assert not is_green_taxi_neighborhood('east village', 'new york')
    assert not is_green_taxi_neighborhood('fake manhattan neighborhood', 'manhattan')
    assert not is_green_taxi_neighborhood('fake neighborhood', 'fake borough')
    assert taxi_zone_color('lenox hill', 'new york') == 'yellow'
    assert taxi_zone_color('spanish harlem', 'new york') == 'green'
    assert taxi_zone_color('fake manhattan neighborhood', 'new york') == 'yellow'
    assert taxi_zone_color('fake brooklyn neighborhood', 'brooklyn') == 'green'
    assert taxi_zone_color('fake brooklyn neighborhood', 'fake borough') == 'yellow'
    assert is_green_border_neighborhood('Williamsburg')
    assert is_green_border_neighborhood('williamsburg')
    assert is_green_border_neighborhood('DUMBO')
    assert not is_green_border_neighborhood('Flushing')
    assert not is_green_border_neighborhood('Crown Heights')
    print 'Tests pass!'
