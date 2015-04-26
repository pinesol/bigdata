#!/usr/bin/python

import sys
import string
import os
import numpy as np

	

keystate = None


# input comes from STDIN (stream data that goes to the program)
for line in sys.stdin: 
	key, tup = line.strip().split("\t", 1)
	tup = np.array([float(i) for i in tup.strip().split(",")])
	
	if not keystate:
		init = np.zeros(12)
		count = 0
		keystate = key
	elif key != keystate:
		print "%s,%s,%s" %(keystate,",".join([str(i) for i in init]),count)
		init = np.zeros(12)
		count = 0
		keystate = key
	init = init + tup
	count += 1

#exit code
print "%s,%s,%s" %(keystate,",".join([str(i) for i in init]),count)
