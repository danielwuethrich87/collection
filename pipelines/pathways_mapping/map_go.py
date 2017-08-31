#!/usr/bin/env python

import numpy as np
import subprocess
import sys
import os


inputOptions = sys.argv[1:]

#usage: python map_go.py ../metacyc/prepare_db/result /home/dwuethrich/Application/pfastGO_run/pfastGO-master/Software/databases/mapping/go.obo genes.go species


def main():

	print "\t"+inputOptions[3]

	superpathway2reactions=get_superpathways(inputOptions)
	
	go_2_ec=get_go_2_ec(inputOptions)
	ECs=get_annotation(inputOptions,go_2_ec)


	for superpathway in sorted(superpathway2reactions.keys()):
		#print superpathway.replace("superpathway of ","")+"\t"+str(len(set(superpathway2reactions[superpathway])))+"\t"+str(len(set(superpathway2reactions[superpathway])-set(ECs)))
		pathways_reactions=len(set(superpathway2reactions[superpathway]))
		pathways_not_found_reactions=len(set(superpathway2reactions[superpathway])-set(ECs))
		if pathways_reactions > 0:
			print superpathway.replace("superpathway of ","")+"\t"+str(float(pathways_reactions-pathways_not_found_reactions)/float(pathways_reactions))

def get_annotation(inputOptions,go_2_ec):

	GOs=[]	
	input_file = [n for n in open(inputOptions[2],'r').read().replace("\r","").split("\n") if len(n)>0]
		
	for line in input_file:
		if line.split("\t")[4]!="":
			GOs.extend(line.split("\t")[4].split(", "))

	ECs=[]
	for GO in set(GOs):
		ECs.extend(go_2_ec[GO])
	return ECs

def get_superpathways(inputOptions):
	superpathway2reactions={}

	input_file = [n for n in open(inputOptions[0],'r').read().replace("\r","").split("\n") if len(n)>0]
		
	for line in input_file:
		superpathway=line.split("\t")[0]
		if (superpathway in superpathway2reactions.keys()) ==bool(0):
			superpathway2reactions[superpathway]=[]
		if line.split("\t")[2]!="":
			superpathway2reactions[superpathway].append(line.split("\t")[2])
	return superpathway2reactions

def get_go_2_ec(inputOptions):
	input_file = [n for n in open(inputOptions[1],'r').read().replace("\r","").split("\n") if len(n)>0]

	go_2_ec={}
	for line in input_file:
		if line[0:7]=="id: GO:":
			GO= line[4:]
			if (GO in go_2_ec.keys()) == bool(0):
				go_2_ec[GO]=[]
		if line[0:9]=="xref: EC:":
			ec=line[6:]

			go_2_ec[GO].append(ec)

	return go_2_ec

main()

