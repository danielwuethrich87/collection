#!/usr/bin/env python

import numpy as np
import subprocess
import sys
import os
import sys
import gzip
inputOptions = sys.argv[1:]

#usage: file1


def main():


	print_seq=bool(0)
	with gzip.open(inputOptions[0],'r') as f:
    		for line in f:
			seq=line.replace("\n","")
			if seq[0:1]==">":
				if seq.lower().find("uncultured")==-1 and seq.lower().find("unidentified")==-1 and seq.lower().find(";bacterium")==-1 and seq.lower().find(" sp.")==-1 and seq.split(" ")[1].split(";")[0]=="Bacteria" and seq.split(";")[len(seq.split(";"))-1].split(" ")[0] ==  seq.split(";")[len(seq.split(";"))-2]:
					#print seq.split(" ")[0]+" "+seq.split(";")[len(seq.split(";"))-1]
					print seq
					print_seq=bool(1)

				#elif seq.split(" ")[1].split(";")[0]=="Archaea":
				#	print seq
				#	print_seq=bool(1)

				else:
					print_seq=bool(0)
			else:
				if print_seq==bool(1):
					print seq.upper().replace("U","T")




main()



