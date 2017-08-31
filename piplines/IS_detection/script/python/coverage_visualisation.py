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
# use: python prepare_data.py ../get_coverage/result/FAM22155p50_on_FAM22155p1/coverage.GATK.tab 

def main():

	


	contig_2_cov={}
	with open(inputOptions[0],'r') as f:
		#next(f)
    		for raw_line in f:
			line=raw_line.replace("\n","").replace("\r","")
			contig = line.split("\t")[0]
			location=int(line.split("\t")[1])
			depth= int(line.split("\t")[2])
			if (contig in contig_2_cov.keys())==bool(0):
				contig_2_cov[contig]={}
			contig_2_cov[contig][location]=depth



	window=100
	last_position=0
	for contig in sorted(contig_2_cov.keys()):
		
		for i in range(1,int(len(contig_2_cov[contig])/window)):
			start = i*window
			total=0
			for z in range(0,window):
				total+=contig_2_cov[contig][start+z]
			print str(i*window+last_position)+"\t"+contig+"\t"+inputOptions[1]+"\t"+str(float(total)/float(window))

		print str(i*window+last_position+1)+"\t"+contig+"\t"+inputOptions[1]+"\t0"
		print str(i*window+last_position+19999)+"\t"+contig+"\t"+inputOptions[1]+"\t0"
		last_position=last_position+len(contig_2_cov[contig])+20000

main()		



















