#!/usr/bin/env python

import numpy as np
import subprocess
import sys
import os
import sys
import random

inputOptions = sys.argv[1:]

#usage: file1


def main():

	reads=[]
	
	with open(inputOptions[0],'r') as f:
		counter=0
    		for line in f:
			counter+=1
			if counter==1:
				reads.append([])
				name=">"+line.replace("\n","")+"\n"
				reads[-1].append(name)

			if counter==2:
				reads[-1][0]+=(line.replace("\n",""))
			if counter==4:
				counter=0	



	with open(inputOptions[1],'r') as f:
		read_counter=-1
		counter=0
    		for line in f:
			counter+=1
			if counter==1:
				read_counter+=1
				name=">"+line.replace("\n","")+"\n"
				reads[read_counter].append(name)

			if counter==2:
				reads[read_counter][1]+=(line.replace("\n",""))
			if counter==4:
				counter=0
		

	counter=0

	#random.shuffle(reads)
	if len(reads) > 5000:
		select= 5000
	else:
		select= len(reads)	

	random_number=random.sample(xrange(0,len(reads)), select)

	for i in random_number:

		print reads[i][0]
		print reads[i][1]


main()
