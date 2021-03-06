#!/usr/bin/env python

import numpy as np
import subprocess
import sys
import os
import sys

inputOptions = sys.argv[1:]

#usage: (cat_of_all_alignments)


def main():

	input_file = [n for n in open(inputOptions[0],'r').read().replace("\r","").split("\n") if len(n)>0]

	sequences={}

	for line in input_file:

		if line[0:1] == ">":
			name=line[1:].split("|")[0]
			if (name in sequences.keys())==bool(0):
				sequences[name]=""

		else:
			sequences[name]+=line

	len_sequences=len(sequences[sorted(sequences.keys())[0]])
	number_of_strains=len(sequences.keys())
	print " "+str(number_of_strains)+"  "+str(len_sequences)

	for strain in sorted(sequences.keys()):
		print strain[0:9]+"          "[len(strain[0:9]):]+sequences[strain][0:50]

	print ""

	i=50
	while i < len_sequences:
		for strain in sorted(sequences.keys()):
			print sequences[strain][i:i+50]

		print ""
		i+=50
main()
