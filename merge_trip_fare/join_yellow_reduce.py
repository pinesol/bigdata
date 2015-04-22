#!/usr/bin/python

import sys
import string
import os

mergevars = [ 'medallion', 'hack_license', 'vendor_id', 'pickup_datetime']

tripsvars = [ 'rate_code', 'store_and_fwd_flag','dropoff_datetime', \
'passenger_count','trip_time_in_secs','trip_distance','pickup_longitude', \
'pickup_latitude','dropoff_longitude','dropoff_latitude' ]

faresvars = [ 'payment_type','fare_amount','surcharge','mta_tax','tip_amount','tolls_amount','total_amount' ]

allvars = tripsvars + faresvars

index = ",".join(mergevars)
output = ",".join(allvars) 
print "%s\t%s" %(index,output)

keystate = ['init']
init = 1
farelist = []
triplist = []

# input comes from STDIN (stream data that goes to the program)
for line in sys.stdin: 
	key, tup = line.strip().split("\t", 1)
	key = key.split(',')
	source, data = tup.split("|", 1)
	data = data.split(',')
	
	if source == 'fares':
		faredata = data
		current = key

		if keystate != current and init==0:
			for i in range(len(triplist)):
				for j in range(len(farelist)):
					index = ",".join(key)
					outputtrip = ",".join(triplist[i])
					outputfare = ",".join(farelist[j])
					output = outputtrip+","+outputfare
					print "%s\t%s" %(index,output)

			farelist = [faredata]
			triplist = []
			keystate = current

		else:
			farelist.append(faredata)

	if source == 'trips':
		tripdata = data
		current = key

		if keystate != current and init==0:
			for i in range(len(triplist)):
				for j in range(len(farelist)):
					index = ",".join(key)
					outputtrip = ",".join(triplist[i])
					outputfare = ",".join(farelist[j])
					output = outputtrip+","+outputfare
					print "%s\t%s" %(index,output)

			farelist = []
			triplist = [tripdata]
			keystate = current

		else:
			triplist.append(tripdata)


	if init==1:
		init=0	
		keystate = current


#add exit code
for i in range(len(triplist)):
	for j in range(len(farelist)):
		index = ",".join(key)
		outputtrip = ",".join(triplist[i])
		outputfare = ",".join(farelist[j])
		output = outputtrip+","+outputfare
		print "%s\t%s" %(index,output)



