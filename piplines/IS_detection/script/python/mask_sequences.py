#!/usr/bin/env python

import numpy as np
import subprocess
import sys
import os


inputOptions = sys.argv[1:]

#usage: python mask_sequences.py ../blast/input/FAM1476c1p.fna ../blast/result/blast_results.FAM1476c1p.tab 



def main():


	input_file = [n for n in open(inputOptions[0],'r').read().replace("\r","").split("\n") if len(n)>0]

	sequences={}

	for line in input_file:
		if line [0:1]==">":
			name = line[1:].split(" ")[0]
			sequences[name]=""

		else:
			sequences[name]+=line			
		

	input_file = [n for n in open(inputOptions[1],'r').read().replace("\r","").split("\n") if len(n)>0]

	for line in input_file:
		query=line.split("\t")[0]
		hit=line.split("\t")[1]
		align_idendity=float(line.split("\t")[2])
		align_length=int(line.split("\t")[3])
		query_start=int(line.split("\t")[6])
		query_end=int(line.split("\t")[7])
		hit_start=int(line.split("\t")[8])
		hit_end=int(line.split("\t")[9])
		if hit_start> hit_end:
			hit_start=int(line.split("\t")[9])
			hit_end=int(line.split("\t")[8])			

		if query != hit or query_start != hit_start or query_end != query_end:
			if align_idendity >= 95 and align_length >= 600:
				if sequences[query][query_start:query_end].count("N")==0:
					Ns=""
					for i in range(hit_start,hit_end):
						Ns+="N"
					#print len(sequences[hit])
					#print len(sequences[hit][0:hit_start])+len(Ns)+len(sequences[hit][hit_end:])
					#print len(sequences[hit][0:hit_start])
					#print len(sequences[hit][hit_end:])
					#print len(Ns)
					#print hit_start
					#print hit_end
					#print "--------"
					sequences[hit]=sequences[hit][0:hit_start]+Ns+sequences[hit][hit_end:]
	for sequence in sequences.keys():
		print ">"+sequence
		printSequence(sequences[sequence])
def printSequence(sequence):
        i=0
        while i < len(sequence):
                if i+60<=len(sequence):
                        print sequence[i:i+60]
                else:
                        print sequence[i:]
                
                i+=60

main()

