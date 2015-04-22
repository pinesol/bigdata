#!/usr/bin/python

import sys
import string
import os



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





# input comes from STDIN (stream data that goes to the program)
for line in sys.stdin:   
    
    #yellow path
    if 'yellow' in str(os.environ['mapreduce_map_input_file']):
        source = 'Y'
        partA , partB = line.strip().split('\t')
        
        if partA[0] == 'm':
            pass
        else:
            full = partA.split(",") + partB.split(",")
            line = [full[yellowvars.index(i)] for i in greenvars ]
            print "%s\t%s" %(source,(",".join(line)))	
            
    #green path
    else:
        source = 'G'
        line = line.strip().split(",")
        if line[0] == 'pickup_datetime':
            pass
        else:
			print "%s\t%s" %(source,(",".join(line)))	




