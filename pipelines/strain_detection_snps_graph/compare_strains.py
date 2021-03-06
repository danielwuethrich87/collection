#!/usr/bin/env python
from scipy.stats import binned_statistic
import numpy as np
import subprocess
import sys
import os
import sys
from collections import Counter
import scipy
import operator

inputOptions = sys.argv[1:]

#usage: file1


def main():
		

	read_files={}
	sample_2_file=read_input_file()

	for i in sample_2_file.keys():

		read_files[i]=read_file(sample_2_file[i][0],sample_2_file[i][1])

	for i in read_files.keys():
		for z in read_files.keys():
			compare_samples(read_files[z],read_files[i],z,i,sample_2_file[z][1],sample_2_file[i][1])

def read_input_file():
	sample_2_file={}
	with open("input.tab",'r') as f:
    		for i in f:
			line=i.replace("\n","")
			sample_2_file[line.split("\t")[0]]=[line.split("\t")[1],line.split("\t")[2]]
	return sample_2_file

def compare_samples(sample_1,sample_2,name1,name2,sample_type_1,sample_type_2):

	common_sites=(set(sample_1.keys()).intersection(sample_2.keys()))
	number_of_common_sites=len(common_sites)

	count_conserved_sites=0
	for site in common_sites:

		if len(set(sample_1[site].keys()).intersection(set(sample_2[site].keys())))>=1:
			count_conserved_sites+=1

	print name1+ "\t" +sample_type_1+ "\t"+name2+ "\t" +sample_type_2+ "\t"+str(count_conserved_sites) + "\t"+str(float(count_conserved_sites)/float(number_of_common_sites))


def read_file(file_name,sample_type):


	all_cov=list()
	with open(file_name,'r') as f:
		next(f)
    		for i in f:
			line=i.replace("\n","")

		
			if (int(line.split("\t")[1]))>0:
				all_cov.append(int(line.split("\t")[1]))


	median=np.median(all_cov)
	low_median_cutoff = float(np.median(all_cov))/float(2)
	top_median_cutoff = float(np.median(all_cov))*float(2)

	coverage_cut_off=10
	number_of_covered_bases=len(all_cov)
	depth=median

	for i in [10,9,8,7,6,5,4,3]:
		if round((scipy.misc.comb(depth,i)),0) * (pow(0.00006,i)) * (pow(1-0.00006,depth-i)) *number_of_covered_bases < 100:
			coverage_cut_off=i


	with open(file_name,'r') as f:
		next(f)
    		for i in f:
			line=i.replace("\n","")
			read_depth=int(line.split("\t")[3])
			if low_median_cutoff<= read_depth and top_median_cutoff>=read_depth: 
				seq_name=line.split("\t")[0].split(":")[0]
				location=int(line.split("\t")[0].split(":")[1])
				#location_information[seq_name+"\t"+str(location)]={}

	location_information={}
	with open(file_name,'r') as f:
		next(f)
    		for i in f:
			line=i.replace("\n","")


			read_depth=int(line.split("\t")[3])

			if low_median_cutoff<= read_depth and top_median_cutoff>=read_depth: 

				seq_name=line.split("\t")[0].split(":")[0]
				location=int(line.split("\t")[0].split(":")[1])


				counts=line.split("\t")[4]
				counts_number=[]
					
				base_info={}
				for base in counts.split(" ")[0:4]:	
					count=int(base.split(":")[1])
					base=base.split(":")[0]
					if count >=1:
						
						base_information=Base_information(seq_name+"\t"+str(location), base, coverage_cut_off,count)
						base_info[base_information.base]=base_information
						#location_information[base.location][base.base]=base

				if sample_type=="mix":
					location_information[base_information.location]=base_info

				if sample_type=="ref":	
					if len(base_info.keys())>1:			
						sorted_bases = sorted(base_info.items(), key=operator.itemgetter(1),reverse=True)
					
						if sorted_bases[0][1].count>=sorted_bases[1][1].count*10:# check best bases
							location_information[base_information.location]={sorted_bases[0][0]:sorted_bases[0][1]}
					else:
						location_information[base_information.location]=base_info
	return location_information

class Base_information:
	def __init__(self, location, base, cov_cutoff,count):
		self.location = location
		self.base = base
		self.cov_cutoff = cov_cutoff
		self.count = count




main()
