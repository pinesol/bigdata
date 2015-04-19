#!/usr/bin/python

import sys
import string
import os
'''
tripsvars = [ \
'medallion','hack_license','vendor_id','rate_code',\
'store_and_fwd_flag','pickup_datetime','dropoff_datetime', \
'passenger_count','trip_time_in_secs','trip_distance','pickup_longitude', \
'pickup_latitude','dropoff_longitude','dropoff_latitude' ]

faresvars = [ \
'medallion','hack_license','vendor_id','pickup_datetime','payment_type', \
'fare_amount','surcharge','mta_tax','tip_amount','tolls_amount','total_amount' ]

mergevars = [ 'medallion', 'hack_license', 'vendor_id', 'pickup_datetime']
'''



# input comes from STDIN (stream data that goes to the program)
for line in sys.stdin:    
	line = line.strip().split(',')

    	if line[0] == 'medallion':
		pass

   	else :
        	#if 'trip' in str(os.environ['mapreduce_map_input_file']):
		if len(line) > 12:				
			source = 'trips'
		else:
			source = 'fares'

		if source == 'trips':
			key = []
			for i in [0,1,2,5]:
				key.append(line[i])
			for i in [0,0,0,2]:
				line.remove(line[i])
				

		if source == 'fares':
			key = []
			for i in [0,1,2,3]:
				key.append(line[i])
			for i in [0,0,0,0]:
				line.remove(line[i])
	

    		print "%s\t%s|%s" %((",".join(key)),source,(",".join(line)))	
		

