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
# use: python prepare_data.py ../analyse_known_IS/detect_all/results/"$i"/"$i"_long_indels_reads.tab ../extract_positions/reads/"$i".fastq > results/"$i"_insertions.fasta

def main():

	read_2_ins={}
	read_2_deletion={}

	ins_2_genomic_location={}
	ins_2_genomic_location_end={}
	with open(inputOptions[0],'r') as f:
    		for raw_line in f:
			line=raw_line.replace("\n","").replace("\r","")	
			name=line.split("\t")[0]


			if (name in read_2_ins.keys()) == bool(0):
				read_2_ins[name]={}
				read_2_deletion[name]={}		

			start=int(line.split("\t")[3])
			end=int(line.split("\t")[4])


			genomic_location=line.split("\t")[2]+";_location_start:"+str(int(line.split("\t")[5])+int(line.split("\t")[6]))
			ins_2_genomic_location[name+"_"+str(start)]=genomic_location	
			
			genomic_location_end=";_location_end:"+str(int(line.split("\t")[5])+int(line.split("\t")[7]))
			ins_2_genomic_location_end[name+"_"+str(end)]=genomic_location_end


			if int(line.split("\t")[1]) < 0:
				
				for i in range(start,end):
					read_2_ins[name][i]=1

			else:
				for i in range(start,end):
					read_2_deletion[name][i]=1
	read_2_sequence={}
	counter=0
	with open(inputOptions[1],'r') as f:
    		for raw_line in f:
			line=raw_line.replace("\n","").replace("\r","")	

			read_2_sequence[line.split("\t")[0]] = line.split("\t")[4]



	get_sequences(read_2_sequence,read_2_ins,ins_2_genomic_location,ins_2_genomic_location_end,"insertions")
	get_sequences(read_2_sequence,read_2_deletion,ins_2_genomic_location,ins_2_genomic_location_end,"deletions")

def get_sequences(read_2_sequence,read_2_ins,ins_2_genomic_location,ins_2_genomic_location_end,variant_type):

	sample_id=inputOptions[2]
	read_variant_part_file = open(inputOptions[3]+'/'+sample_id+'_'+variant_type+'.fasta', 'w')
	reads_with_variant_file = open(inputOptions[3]+'/'+sample_id+'_reads_with_'+variant_type+'.fasta', 'w')
	for read in read_2_ins.keys():

		#building a graph to find connected elements
		G=nx.Graph()
		edges=list()

		for base in read_2_ins[read].keys():
			edges.append([base,base+1])
		
		G.add_edges_from(edges)
		counter=0
		for connected_component in sorted(nx.connected_components(G), key = len, reverse=True):
			counter+=1
			start = sorted(connected_component)[0]
			end = sorted(connected_component)[-1]

			



			read_variant_part_file.write(">"+read.replace("/","_")+"_"+str(counter)+"_start_on_read:"+str(start)+";_end_on_read:"+str(end)+";_genomic_locations:"+ins_2_genomic_location[read+"_"+str(start)]+ins_2_genomic_location_end[read+"_"+str(end)]+"/0/0_"+str(len(read_2_sequence[read][start:end]))+"\n")
			read_variant_part_file.write(read_2_sequence[read][start:end]+"\n")

			if counter==1:
				reads_with_variant_file.write(">"+read.replace("/","_")+"_"+str(counter)+"_start_on_read:"+str(start)+";_end_on_read:"+str(end)+";_genomic_locations:"+ins_2_genomic_location[read+"_"+str(start)]+"/0/0_"+str(len(read_2_sequence[read]))+"\n")

				reads_with_variant_file.write(read_2_sequence[read]+"\n")
					







main()		



















