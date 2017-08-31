#!/usr/bin/env python

import numpy as np
import subprocess
import sys
import os


inputOptions = sys.argv[1:]

#usage: python convert_orthoMCL_2_roary.py ../ortho_MCL/groups_all.tab ../ortho_MCL/blastparallel/goodProteins.fasta ../roary/paralogs_separate/input/FAM*.gff


def main():

	gene_2_name={}
	for  gff_file in inputOptions[2:]:
		input_file = [n for n in open(gff_file,'r').read().replace("\r","").split("\n") if len(n)>0]
		for line in input_file:
			if len(line.split("\t"))==9 and line.find(";product=")!=-1:
				gene=line.split(";locus_tag=")[1].split(";")[0].replace("FAM","")
				product=line.split(";product=")[1].split(";")[0]
				gene_2_name[gene]=product
	strains={}
	sequences={}
	with open(inputOptions[1],'r') as f:
    		for raw_line in f:
			line=raw_line.replace("\n","").replace("\r","")
			if line[0:1]==">":
				name=line[1:].split(" ")[0]
				sequences[name]=""
				strains[name.split("|")[0]]=1
			else:
				sequences[name]+=line.replace("*","")

	strains=sorted(strains.keys())

	input_file = [n for n in open(inputOptions[0],'r').read().replace("\r","").split("\n") if len(n)>0]

	header='"Gene","Non-unique Gene name","Annotation","No. isolates","No. sequences","Avg sequences per isolate","Genome Fragment","Order within Fragment","Accessory Fragment","Accessory Order with Fragment","QC","Min group size nuc","Max group size nuc","Avg group size nuc"'
	for strain in strains:
		header+=","+strain

	print header


	for line in input_file:

		cluster_strains={}
		genes= line.split(" ")
		for gene in genes:
			strain = gene.split("|")[0]
			cluster_strains[strain]=1
		to_print = "FAM"+genes[0].replace("FAM","").split("|")[1]+",,"+gene_2_name[genes[0].split("|")[1].replace("FAM","")]+","+str(len(cluster_strains.keys()))+","+str(len(genes))+","+str(round(float(len(genes))/float(len(cluster_strains.keys())),2))+",,,,,,,,"

		for strain in strains:
			genes_strain=""
			for gene in genes:
				gene_strain = gene.split("|")[0]			
				if gene_strain==strain:
					genes_strain+=" "+gene

			to_print+=","+genes_strain[1:]
		print to_print

main()

