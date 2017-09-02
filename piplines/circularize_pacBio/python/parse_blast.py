#!/usr/bin/env python

import numpy as np
import subprocess
import sys
import os
import sys
from difflib import SequenceMatcher

inputOptions = sys.argv[1:]

#usage: file1.fasta blast.tab


def main():

	sequences=read_fasta(inputOptions[0])
	hits=read_blast(inputOptions[1],sequences)
	sequence_redudance_contig=search_assebmlies_subsequences(inputOptions[1],sequences)
	best_locations=get_best_hit_locations(hits)

	for query in best_locations.keys():
		
		longest_commen_seq = compare_sequences(sequences[query][best_locations[query][0][0]:best_locations[query][0][1]],sequences[query.replace("part1","part2")][best_locations[query][1][0]:best_locations[query][1][1]])

		homology_to_other_contigs=len(sequence_redudance_contig[query])+len(sequence_redudance_contig[query.replace("part1","part2")])
		


		

		if len(longest_commen_seq)>=500:
			seq_part1=sequences[query]
			seq_part2=sequences[query.replace("part1","part2")]
	
			sequence=seq_part2[0:seq_part2.find(longest_commen_seq)]+seq_part1[seq_part1.find(longest_commen_seq):]

			print ">"+query.replace("_part1","")+ " sequence_length:"+str(len(sequence))+ " homology_to_other_contigs:"+str(homology_to_other_contigs) + " alignment_length:"+str(abs(best_locations[query][0][0]-best_locations[query][0][1]))+" identical_overlap:"+str(len(longest_commen_seq))
			printSequence(sequence)

		else:

			seq_part1=sequences[query]
			seq_part2=sequences[query.replace("part1","part2")]
			sequence=seq_part1+seq_part2

			if len(sequence)> homology_to_other_contigs*2:

				print ">"+query.replace("_part1","")+ " sequence_length:"+str(len(sequence))+ " homology_to_other_contigs:"+str(homology_to_other_contigs)+" not_closed"

				printSequence(sequence)

			else:
				sys.stderr.write(">"+query.replace("_part1","")+ " sequence_length:"+str(len(sequence))+ " homology_to_other_contigs:"+str(homology_to_other_contigs) + " alignment_length:"+str(abs(best_locations[query][0][0]-best_locations[query][0][1]))+" identical_overlap:"+str(len(longest_commen_seq))+" --> sequence was excluded\n")

def get_best_hit_locations(hits):
	coordinaes_2_query={}
	for hit in hits:
		
		best_hit= sorted(hits[hit], key=lambda x: int(x.split("\t")[3]), reverse=True)[0]
		coordinates=((int(best_hit.split("\t")[6]),int(best_hit.split("\t")[7])),(int(best_hit.split("\t")[8]),int(best_hit.split("\t")[9])))
		coordinaes_2_query[hit]= coordinates

	return coordinaes_2_query

def search_assebmlies_subsequences(file_name,sequences):
	sequence_redudance_contig={}

	for i in sequences.keys():
		sequence_redudance_contig[i]=set()

	input_file = [n for n in open(file_name,'r').read().replace("\r","").split("\n") if len(n)>0]

	for line in input_file:
		contig = line.split("\t")[0].split("_part")[0]
		seq_name = line.split("\t")[0]
		if contig != line.split("\t")[1].split("_part")[0]:		
			sequence_redudance_contig[seq_name]=sequence_redudance_contig[seq_name].union(range(int(line.split("\t")[6]),int(line.split("\t")[7])))
	
	return sequence_redudance_contig
	
def read_blast(file_name,sequences):

	input_file = [n for n in open(file_name,'r').read().replace("\r","").split("\n") if len(n)>0]

	hits={}
	for line in input_file:

		if line.split("\t")[0].find("part1")!=-1 and (line.split("\t")[0] in hits.keys())==bool(0):
			hits[line.split("\t")[0]]=list()
			hits[line.split("\t")[0]].append(line.split("\t")[0]+"\tX\t0\t0\t0\t0\t0\t0\t0\t0\t1\t0")

		if line.split("\t")[0].find("part1")!=-1 and line.split("\t")[1].find(line.split("\t")[0].replace("part1","part2"))!=-1:

			if int(line.split("\t")[6])<=100000 and (len(sequences[line.split("\t")[1]])-int(line.split("\t")[9]))<=100000:
			
				hits[line.split("\t")[0]].append(line)
	return hits

def read_fasta(file_name):

	input_file = [n for n in open(file_name,'r').read().replace("\r","").split("\n") if len(n)>0]

	sequences={}
	for line in input_file:
		if line[0:1]==">":
			name = line[1:]
			sequences[name]=""
		else:
			sequences[name]+=line.upper()

	return sequences


	

def compare_sequences(seq1,seq2):
	seed_length = len(seq1)

	subsequence_final=""
	while subsequence_final == "" and seed_length>=0:
	
		subsequence_final=search_window(seq1,seq2,seed_length)

		seed_length-=100


	
	return subsequence_final

	
def search_window(seq1,seq2,seed_length):
	i = 0
	subsequence_final=""
	while i+seed_length < len(seq1):
		sub_sequence=seq1[i:i+seed_length]

		if  seq2.find(sub_sequence)!=-1 and subsequence_final=="":

			subsequence_final= sub_sequence

		i+=5


	return subsequence_final

def printSequence(sequence):
	i=0
	while i < len(sequence):
		if i+60<=len(sequence):
			print sequence[i:i+60]
		else:
			print sequence[i:]
		
		i+=60

main()
