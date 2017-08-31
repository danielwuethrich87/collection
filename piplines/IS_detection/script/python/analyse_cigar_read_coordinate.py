import operator
import csv
import sys
import math
from Bio.Blast import NCBIXML
import networkx as nx
import numpy as np
import re # re.findall('(\d+)([MIDNSHP])', a)
import datetime
inputOptions = sys.argv[1:]


def main():


	with open(inputOptions[0],'r') as f:
    		for raw_line in f:
                        line=raw_line.replace("\n","").replace("\r","")
                        scaffold=line.split("\t")[1]
                        read_start=int(line.split("\t")[2])
                        read_name=line.split("\t")[0]
                        cigar=line.split("\t")[3]
                        split_cigar=re.findall('(\d+)([MIDNSHPX=])', cigar)


			
			total=0
			location2count_read={}
			total_genome=0
			read_location2genome_location_difference={}
	
			for info in split_cigar:
	
				if info[1]=="D": # D and I and exchanged to make the position relative to the read
					location2count_read[total]+=int(info[0])
					read_location2genome_location_difference[total+i]=total_genome
					total_genome+=int(info[0])

				if info[1]=="I":
					for i in range(1,int(info[0])+1):
						location2count_read[total+i]=0
						read_location2genome_location_difference[total+i]=total_genome
					total+=int(info[0])		
				if info[1]=="M" or info[1]=="X" or info[1]=="=":
					for i in range(1,int(info[0])+1):
						location2count_read[total+i]=1
						read_location2genome_location_difference[total+i]=total_genome+i
					total+=int(info[0])
					total_genome+=int(info[0])	

			windowsize=600
			slide=100
			for i in range(1,(len(location2count_read.keys())-windowsize)/100):
				window_count=0
				window_start=i*100
				for z in range(0,windowsize):
					window_count+=location2count_read[window_start+z]
				if abs(window_count-windowsize)>=400:# this must be smaller than 300, otherwise the cuttoff is bigger than the window. And therefore the read sequence.
					print read_name+"\t"+str(window_count-windowsize)+"\t"+scaffold+"\t"+str(window_start)+"\t"+str(window_start+windowsize)+"\t"+str(read_start)+"\t"+str(read_location2genome_location_difference[window_start])+"\t"+str(read_location2genome_location_difference[window_start+windowsize])#+"\t"+str(five_prime_softclipping)


main()		
