#!/usr/bin/env python

import numpy as np
import subprocess
import sys
import os
from subprocess import Popen
from ftplib import FTP
import gzip
import StringIO

inputOptions = sys.argv[1:]

#usage: python Download_genomes.py assembly_summary.txt names.dmp "Morganella morganii" "Raoultella ornithinolytica" "Facklamia tabacinasalis" "Corynebacterium casei" "Corynebacterium variabile" "Brevibacterium coryniformis" "Brevibacterium linens" "Lactobacillus parafarraginis" "Lactobacillus harbinensis" "Citrobacter freundii" "Klebsiella pneumoniae"



def main():

	species2strains=read_db(inputOptions[0])

	Popen(['rm','-rf','genomes'])


	for species in inputOptions[2:]:

		taxid=""
		with open(inputOptions[1],'r') as f:
    			for raw_line in f:
				line=raw_line.replace("\n","").replace("\r","")
				if line.split("\t|\t")[1] == species:
					taxid=line.split("\t")[0]

		if (taxid in species2strains.keys()) == bool(1):
			refseq_categories={"reference genome":[],"representative genome":[],"na":[]}

			for strain in species2strains[taxid]:
				refseq_categories[strain.refseq_category].append(strain)
		
			selected_strains=[]
			for refseq_category in ["reference genome","representative genome","na"]:
				if len(refseq_categories[refseq_category])>0 and len(selected_strains)==0:
					selected_strains=refseq_categories[refseq_category]
		
			strain_was_selected=bool(0)
			for assembly_level in {"Complete Genome","Chromosome","Scaffold","Contig"}:
				for strain in selected_strains:
					if strain.assembly_level == assembly_level and strain_was_selected==bool(0):
						strain_was_selected=bool(1)
						print "Selected strain for "+species+": "+ strain.name + " ("+strain.assembly_id+")"
						if species != strain.species:
							print "<-------Alternative name of species with Taxid:"+taxid
						#Popen(['wget', strain.download_link])
						get_ftp_file(strain.download_link.replace("ftp://ftp.ncbi.nlm.nih.gov/","RETR "), (strain.name + "_"+strain.assembly_id+"").replace(" ","_"),species)
		else:
			print species+": No asssembled genome available on NCBI."
	
def get_ftp_file(link,strain_id,species):
	Popen(['mkdir','-p','genomes'])
	ftp = FTP('ftp.ncbi.nlm.nih.gov')
	ftp.login() # Username: anonymous password: anonymous@

	sio = StringIO.StringIO()
	def handle_binary(more_data):
	    sio.write(more_data)

	resp = ftp.retrbinary(link, callback=handle_binary)
	sio.seek(0) # Go back to the start
	zippy = gzip.GzipFile(fileobj=sio)

	uncompressed = zippy.read()

	sequences={}
	for line in uncompressed.split("\n"):
		if line[0:1]==">" :
			name=line
			sequences[name]=""
		else:
			sequences[name]+=line


	f = open('genomes/'+species.replace(" ","_")+'.fa', 'w')
	

	for sequence_name in sequences.keys():
		f.write(sequence_name+"\n")
		sequence = sequences[sequence_name]

		i=0
		while i < len(sequence):
			f.write(sequence[i:i+60]+"\n")	 
			i+=60

def read_db(file_name):
	input_file = [n for n in open(file_name,'r').read().replace("\r","").split("\n") if len(n)>0]

	species2strains={}

	for line in input_file:
		if line[0:1]!="#":
			strain = Strain()
			strain.species=line.split("\t")[7].split(" ")[0]+" "+line.split("\t")[7].split(" ")[1]
			strain.species_ID=line.split("\t")[6]
			strain.name=line.split("\t")[7]
			strain.download_link=line.split("\t")[19]+"/"+line.split("\t")[19].rsplit("/",1)[1]+"_genomic.fna.gz"
			strain.assembly_level=line.split("\t")[11]
			strain.refseq_category=line.split("\t")[4]
			strain.assembly_id=line.split("\t")[15]
			if (strain.species_ID in species2strains.keys()) == bool(0):
				species2strains[strain.species_ID]=list()
			species2strains[strain.species_ID].append(strain)
	return species2strains

class Strain:
        def __init__(self):
                self.species=""
                self.name=""
                self.download_link=""
                self.assembly_level=""
                self.refseq_category=""
		self.assembly_id=""


main()


