#!/usr/bin/env python

import numpy as np
import subprocess
import sys
import os
import re

inputOptions = sys.argv[1:]

#usage: python make_arrows.py ../results/FAM1476c2p_on_FAM1476c1p.read_info.tab ../../../../../final_genomes/prokka/annotation/FAM1476c1p/FAM1476c1p_*.gff ../../../results/FAM1476c2p_on_FAM1476c1p_deletions.fasta


def main():


	transposome_2_locations=read_locations()
	contig2lenght=get_chromosome_information()
	genes=read_genes(contig2lenght)	
	print_deletions(genes)


	found_connections = {}
	
	for transposome_2_location in transposome_2_locations:

		contig_transposome=transposome_2_location[0][0]
		range_transposome=range(transposome_2_location[0][1],transposome_2_location[0][2])

		contig_insertion=transposome_2_location[1][0]

		if (transposome_2_location[1][2] - transposome_2_location[1][1])>200:
			range_insertion=range(transposome_2_location[1][1]+100,transposome_2_location[1][2]-100)
		else:
			range_insertion=range(transposome_2_location[1][1],transposome_2_location[1][2])
		
		insertion_gene=""
		best_overlap_insertion=0
		best_overlap=0
		best_gene=""
		for gene in genes:

			if gene.contig==contig_transposome:
				
				overlap=len(set(gene.positions).intersection(set(range_transposome)))
				if overlap>best_overlap:
					best_overlap=overlap
					best_gene=gene

			if gene.contig==contig_insertion:
			
				overlap_insertion=len(set(gene.positions).intersection(set(range_insertion)))
				if overlap_insertion>best_overlap_insertion:
					best_overlap_insertion=overlap_insertion
					insertion_gene=gene
					
				#if (location_insertion in gene.positions) == bool(1):
				#	insertion_gene=gene

		
		connection_name = best_gene.gene_id+"_to_"+insertion_gene.gene_id

		if (connection_name in found_connections.keys())==bool(0):
			found_connections[connection_name]=[best_gene,insertion_gene,0]

		found_connections[connection_name][2]+=1

	#print len(found_connections.keys())

	links_file = open(inputOptions[3]+'/links.tab', 'w')
	arrows_file= open(inputOptions[3]+'/linkends.txt', 'w')
	
	for connection in found_connections.values():
		start_contig=connection[0].contig
		start_locations=connection[0].start
		
		tartget_contig=connection[1].contig
		tartget_location=connection[1].start	

		if connection[2] > 1 and connection[0].gene_id != connection[1].gene_id:
			links_file.write(start_contig+" "+str(start_locations-100)+" "+str(start_locations+100)+" "+str(tartget_contig)+" "+str(int(tartget_location-connection[2]*200))+" "+str(int(tartget_location+connection[2]*200))+"\tcolor=lblue,thickness=2p"+"\n")
			arrows_file.write(str(tartget_contig)+" "+str(int(tartget_location))+" "+str(int(tartget_location))+" 0\n")
		
			print connection[0].gene_id +"\t"+connection[1].gene_id +"\t"+str(connection[2])

def print_deletions(genes):
	found_connections = {}
	with open(inputOptions[2],'r') as f:
    		for raw_line in f:
			line=raw_line.replace("\n","").replace("\r","")
			if line[0:1]==">":
				location=[line.split(";_genomic_locations:")[1].split(";")[0],int(line.split("_location_start:")[1].split(";")[0]),int(line.split("_location_end:")[1].split("/")[0])]
				best_overlap=0
				best_gene=""
				contig_deletion=location[0]
				range_deletion=range(location[1],location[2])

				for gene in genes:



					if gene.contig==contig_deletion:
				
						overlap=len(set(gene.positions).intersection(set(range_deletion)))
						if overlap>best_overlap:
							best_overlap=overlap
							best_gene=gene

				connection_name = best_gene.gene_id+"_to_deletion"

				if (connection_name in found_connections.keys())==bool(0):
					found_connections[connection_name]=[best_gene,"deletion",0]

				found_connections[connection_name][2]+=1



	deletions_file = open(inputOptions[3]+'/deletions.tab', 'w')
	for connection in found_connections.values():
		#start_contig=connection[0].contig
		#start_locations=connection[0].start
		
		if connection[2] > 1:
			deletions_file.write(connection[0].contig +" "+str(connection[0].start)+" "+str(connection[0].end)+" "+str(-connection[2])+"\n")
		
			print  "deletion"+"\t"+connection[0].gene_id +"\t"+str(connection[2])

def read_genes(contig2lenght):
	genes=[]
	input_file = [n for n in open(inputOptions[1],'r').read().replace("\r","").split("\n") if len(n)>0]
	last_contig=""
	for line in input_file:
		if len(line.split("\t"))==9:
			if line.split("\t")[2]!="gene" and line.split("\t")[2]!="repeat_region" and line.split("\t")[2]!="remark" and line.split("\t")[2]!="source" and line.find("locus_tag=")!=-1:

				gene=Gene()
				gene.contig=line.split("\t")[0]
				gene.start=int(line.split("\t")[3])
				gene.end=int(line.split("\t")[4])
				gene.positions=range(gene.start,gene.end)
				gene.gene_id=line.split("locus_tag=")[1].split(";")[0]
				gene.product=line.split("product=")[1].split(";")[0]

				if last_contig != gene.contig:
					intergenic_region_contig_start=Gene()
					intergenic_region_contig_start.contig=gene.contig
					intergenic_region_contig_start.start=0
					intergenic_region_contig_start.end=gene.start
					intergenic_region_contig_start.positions=range(intergenic_region_contig_start.start,intergenic_region_contig_start.end)
					intergenic_region_contig_start.gene_id="contig_start_"+gene.gene_id
					intergenic_region_contig_start.product="intergenic_region"

					if last_contig != "":
						intergenic_region_contig_end=Gene()
						intergenic_region_contig_end.contig=genes[-1].contig
						intergenic_region_contig_end.start=genes[-1].end
						intergenic_region_contig_end.end=contig2lenght[gene.contig]
						intergenic_region_contig_end.positions=range(intergenic_region_contig_end.start,intergenic_region_contig_end.end)
						intergenic_region_contig_end.gene_id="contig_end_"+genes[-1].gene_id
						intergenic_region_contig_end.product="intergenic_region"
						genes.append(intergenic_region_contig_end)	
					
					genes.append(intergenic_region_contig_start)

				if len(genes)>0:
					if genes[-1].contig == gene.contig:
						intergenic_region=Gene()
						intergenic_region.contig=gene.contig
						intergenic_region.start=genes[-1].end
						intergenic_region.end=gene.start
						intergenic_region.positions=range(intergenic_region.start,intergenic_region.end)
						intergenic_region.gene_id=genes[-1].gene_id+"_"+gene.gene_id
						intergenic_region.product="intergenic_region"
						genes.append(intergenic_region)
				last_contig = gene.contig
				genes.append(gene)

	intergenic_region_contig_end=Gene()
	intergenic_region_contig_end.contig=genes[-1].contig
	intergenic_region_contig_end.start=genes[-1].end
	intergenic_region_contig_end.end=contig2lenght[gene.contig]
	intergenic_region_contig_end.positions=range(intergenic_region_contig_end.start,intergenic_region_contig_end.end)
	intergenic_region_contig_end.gene_id="contig_end_"+genes[-1].gene_id
	intergenic_region_contig_end.product="intergenic_region"
	genes.append(intergenic_region_contig_end)

	return genes




def read_locations():
	transposome_2_location=[]
	with open(inputOptions[0],'r') as f:
    		for raw_line in f:
			line=raw_line.replace("\n","").replace("\r","")
			location=[line.split(";_genomic_locations:")[1].split(";")[0],int(line.split("_location_start:")[1].split(";")[0]),int(line.split("_location_end:")[1].split("/")[0])]
			cigar=line.split("\t")[3]
			align_length=cigar_2_length(cigar)
			transposom=[line.split("\t")[1],int(line.split("\t")[2]),int(line.split("\t")[2])+align_length]
			transposome_2_location.append([transposom,location])
	return transposome_2_location

def cigar_2_length(cigar):

	split_cigar=re.findall('(\d+)([MIDNSHPX=])', cigar)
	total_genome=0
	for info in split_cigar:

		if info[1]=="D": # D and I and exchanged to make the position relative to the read

		        total_genome+=int(info[0])

       
		if info[1]=="M" or info[1]=="X" or info[1]=="=":

		        total_genome+=int(info[0])	


	return total_genome

def get_chromosome_information():
	chromosomes_file = open(inputOptions[3]+'/BacteriaContigs.txt', 'w')
	contig2lenght={}
	input_file = [n for n in open(inputOptions[1],'r').read().replace("\r","").split("\n") if len(n)>0]
	for line in input_file:
		if line [0:17]=="##sequence-region":	
			contig2lenght[line.split(" ")[1]]=int(line.split(" ")[3])
			chromosomes_file.write("chr - "+line.split(" ")[1]+" "+line.split(" ")[1]+" 0 "+line.split(" ")[3]+" red\n")	
	return contig2lenght

class Gene:
	def __init__(self):
		self.contig=""
		self.start=0
		self.end=0
		self.positions=[]
		self.gene_id=""
		self.product=""
		#self.event_starts=0
		#self.event_ends=0
main()

