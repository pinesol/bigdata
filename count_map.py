#!/usr/bin/python

import sys
import string
import os
'''
varsold = 
["pickup_datetime dropoff_datetime store_and_fwd_flag rate_code \
pickup_longitude pickup_latitude dropoff_longitude dropoff_latitude \
passenger_count trip_distance fare_amount	surcharge mta_tax tip_amount \
tolls_amount total_amount payment_type pickup_borough pickup_neighbor \
dropoff_borough	dropoff_neighbor zone color"]

orderold = ["color zone pick_n pick_b drop_n drop_b day hour pickup_longitude \
pickup_latitude dropoff_longitude dropoff_latitude passenger_count \
trip_distance fare_amount	surcharge mta_tax tip_amount tolls_amount total_amount \
count"]

vars = 
['pickup_datetime','dropoff_datetime', 'store_and_fwd_flag' , \
'rate_code', 'pickup_longitude', 'pickup_latitude', 'dropoff_longitude',  \
'dropoff_latitude', 'passenger_count', 'trip_distance','fare_amount', \
'surcharge','mta_tax','tip_amount','tolls_amount','total_amount','payment_type', \
'pickup_borough','pickup_neighbor','dropoff_borough','dropoff_neighbor','pickup_zone' \
,'dropoff_zone','pickup_is_border','dropoff_is_border', 'color']

order = ["color pick_n pick_b drop_n drop_b pick_zone drop_zone pick_border \
drop_border day hour pickup_longitude pickup_latitude dropoff_longitude \
dropoff_latitude passenger_count trip_distance fare_amount surcharge \ 
mta_tax tip_amount tolls_amount total_amount count"]

data:
4: pickup_longitude
5: pickup_latitude
6: dropoff_longitude
7: dropoff_latitude
8: passenger_count
9: trip_distance
10: fare_amount
11: surcharge
12: mta_tax
13: tip_amount
14: tolls_amount
15: total_amount

'''



# input comes from STDIN (stream data that goes to the program)
for line in sys.stdin:    
	line = line.strip().split(',')

    	if line[0] == 'pickup_datetime':
		pass

   	else :
		color = line[-1]
		drop_border = line[-2]
		pick_border = line[-3]
		drop_zone = line[-4]
		pick_zone = line[-5]
		drop_n = line[-6]
		drop_b = line[-7]
		pick_n = line[-8]
		pick_b = line[-9]

		day = line[0].strip().split()[0]
		hour = line[0].strip().split()[1][0:2]
		data = ",".join(line[4:16])
	

    		print "%s,%s,%s,%s,%s,%s,%s,%s\t%s" %(color,pick_n,pick_b,drop_n,drop_b,pick_zone,drop_zone,pick_border,drop_border,day,hour,data)	
		

