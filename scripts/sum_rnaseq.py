#!/usr/bin/env python

import subprocess
import sys
import os

inputOptions = sys.argv[1:]

#usage: gff counts


def main():



        #with open(inputOptions[0],'r') as f:
        #       for line in f:
        #               define_species(line) safe memory

        gff_file = [n for n in open(inputOptions[0],'r').read().replace("\r","").split("\n") if len(n)>0]
        
        id2feature={}
        for line in gff_file:

                if len(line.split("\t"))==9:
                        if line.split("\t")[2]!="gene" and line.split("\t")[2]!="repeat_region":
                                
                                id2feature[line.split("ID=")[1].split(";")[0]]=line.split("\t")[2]


        total_counts={}
        count_file = [n for n in open(inputOptions[1],'r').read().replace("\r","").split("\n") if len(n)>0]

        for key in ("CDS","rRNA","tRNA","tmRNA","__no_feature","__ambiguous"+"__too_low_aQual"+"__not_aligned" ):
                total_counts[key]=0
        for line in count_file:

                gene=line.split("\t")[0].replace("_gene","")
                if gene[0:2] == "__":
                        id2feature[gene]=gene

                if (gene in id2feature.keys()):
                        counts=int(line.split("\t")[1])
                        
                        if (id2feature[gene] in total_counts.keys()) == bool(0):
                                total_counts[id2feature[gene]]=0

                        total_counts[id2feature[gene]]+=counts

        print inputOptions[1].split("/")[len(inputOptions[1].split("/"))-1]#+"\t"+inputOptions[1].split("/")[len(inputOptions[1].split("/"))-1]+"_fraction"

        fraction={}
        sum_all=0
        for key in ("CDS","rRNA","tRNA","tmRNA","__no_feature","__ambiguous","__too_low_aQual","__not_aligned" ):
                sum_all+=total_counts[key]


        for key in ("CDS","rRNA","tRNA","tmRNA","__no_feature","__ambiguous","__too_low_aQual","__not_aligned" ):
                print str(round(float(total_counts[key])/float(sum_all)*100,2)) #str(total_counts[key])+"\t"+


main()
