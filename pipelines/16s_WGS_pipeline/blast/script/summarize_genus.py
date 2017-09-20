import operator
import csv
import sys
import math
from Bio.Blast import NCBIXML
import datetime
import ast

inputOptions = sys.argv[1:]

# usage: out_xml sequence.fasta  

def main():


	genus_2_count={}

	with open(inputOptions[0],'r') as f:
    		for line_raw in f:
			line=line_raw.replace("\r","").replace("\n","")

			taxonomy=line.split("\t")[1]
			if len(taxonomy.split(";"))>=6:
				taxonomy=";".join(taxonomy.split(";")[0:6])

				if (taxonomy in genus_2_count.keys()) == bool(0):
					genus_2_count[taxonomy]=0
				
				genus_2_count[taxonomy]+=int(line.split("\t")[2])

	print "Genus\tread_count"
	for i in sorted(genus_2_count.items(), key=operator.itemgetter(1),reverse=True):
		print i[0]+"\t"+str(i[1])

main()		
