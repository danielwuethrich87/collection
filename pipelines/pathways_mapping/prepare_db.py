#!/usr/bin/env python

import numpy as np
import subprocess
import sys
import os


inputOptions = sys.argv[1:]

#usage: python prepare_db.py ../db/tax/categories.dmp ../db/20.5/data/reaction-links.dat  ../db/20.5/data/pathways.dat


def main():



	#with open(inputOptions[0],'r') as f:
    	#	for raw_line in f:
	#		line=raw_line.replace("\n","").replace("\r","")

	bacteria_tax=get_bacteria_tax(inputOptions)
	metacyc_2_ec=get_metacyc_2_ec(inputOptions)
	#metacyc_2_ec=get_metacyc_2_go(inputOptions)
	pathways=read_pathways(inputOptions,metacyc_2_ec)

	for pathway_key in pathways.keys():
	 	pathway=pathways[pathway_key]
		if (pathway.tax in bacteria_tax) == bool(1) and (pathway.super_pathway == bool(1)):  
			#print "--"+pathway.name
			reactios={}
			for sub_pathway_id in pathway.sub_pathways:
				for reaction in pathways[sub_pathway_id].reactions:
					if (reaction in reactios.keys()) == bool(0):
						reactios[reaction]=[]
					reactios[reaction].append(sub_pathway_id)

			
			for reaction in reactios.keys():
				
				print pathway.name+"\t"+str(reactios[reaction])+"\t"+reaction.replace("EC-","EC:")


			#print "---"+pathway.pathway_id+"\t"+pathway.name
			
			#for reaction in pathway.reactions:
			#	if reaction in metacyc_2_ec.keys():
			#		print reaction+"\t"+str(metacyc_2_ec[reaction])
					#print metacyc_2_ec[reaction]
					#go_terms.append(metacyc_2_ec[reaction])
			
			#print "//"


def read_pathways(inputOptions,metacyc_2_ec):
	input_file = [n for n in open(inputOptions[2],'r').read().replace("\r","").split("\n") if len(n)>0]

	pathways={}
	for line in input_file:
		if line[0:12]=="UNIQUE-ID - ":
			pathway=Pathway(line[12:])
		if line[0:14]=="COMMON-NAME - ":
			pathway.name=line[14:]
		if line[0:16]=="REACTION-LIST - ":
			reaction=line[16:]
			if reaction in metacyc_2_ec.keys():
				pathway.reactions.extend(metacyc_2_ec[reaction])
		if line[0:22]=="TAXONOMIC-RANGE - TAX-":
			pathway.tax=line[22:]
		if line[0:22]=="TYPES - Super-Pathways":
			pathway.super_pathway=bool(1)
		if line[0:15]=="SUB-PATHWAYS - ":
			pathway.sub_pathways.append(line[15:])
		if line[0:2]=="//":
			pathways[pathway.pathway_id]=(pathway)
			
	return pathways

def get_metacyc_2_ec(inputOptions):
	metacyc_2_ec={}
	input_file = [n for n in open(inputOptions[1],'r').read().replace("\r","").split("\n") if len(n)>0]
	for line in input_file:
		if line[0:1]!="#":
			metacyc=line.split("\t")[0]
			ecs=line.split("\t")[1:]
			metacyc_2_ec[metacyc]=ecs

	return metacyc_2_ec


#def get_metacyc_2_go(inputOptions):
#	input_file = [n for n in open(inputOptions[1],'r').read().replace("\r","").split("\n") if len(n)>0]
#
#	metacyc_2_go={}
#	for line in input_file:
#		if line[0:7]=="id: GO:":
#			GO= line[4:]
#
#		if line[0:14]=="xref: MetaCyc:":
#			metacyc=line[14:]
#			if (metacyc in metacyc_2_go.keys()) == bool(0):
#				metacyc_2_go[metacyc]=[]
#			metacyc_2_go[metacyc].append(GO)
#
#	return metacyc_2_go

def get_bacteria_tax(inputOptions):
	input_file = [n for n in open(inputOptions[0],'r').read().replace("\r","").split("\n") if len(n)>0]


	bacteria_tax=['2']
	for line in input_file:

		if line.split("\t")[0]=="B":
			bacteria_tax.append(line.split("\t")[1])
	return bacteria_tax

class Pathway:

	def __init__(self, pathway_id):
		self.pathway_id = pathway_id
		self.name = ""
		self.reactions = []
		self.sub_pathways = []
		self.tax = ""
		self.super_pathway=bool(0)

main()

