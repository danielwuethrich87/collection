#!/usr/bin/env python

import numpy as np
import subprocess
import sys
import os
import sys

inputOptions = sys.argv[1:]

#usage: file1


def main():

	input_file = [n for n in open(inputOptions[0],'r').read().replace("\r","").split("\n") if len(n)>0]

	sequences={}
	for line in input_file:
		if line[0:1]==">":
			name = line
			sequences[name]=""
		else:
			sequences[name]+=line

	split_sequences={}	
	for sequence in sequences.keys():
		half=len(sequences[sequence])/2
		split_sequences[str(sequence)+"_part1"]=sequences[sequence][0:half]
		split_sequences[str(sequence)+"_part2"]=sequences[sequence][half:]



	for sequence in sorted(split_sequences.keys()):
		print sequence
		printSequence(split_sequences[sequence])



def printSequence(sequence):
	i=0
	while i < len(sequence):
		if i+60<=len(sequence):
			print sequence[i:i+60]
		else:
			print sequence[i:]
		
		i+=60

main()
