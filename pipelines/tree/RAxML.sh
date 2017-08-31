#!/bin/sh



#$ -q all.q
#$ -e $JOB_ID.raxml.err
#$ -o $JOB_ID.raxml.out
#$ -cwd #executes from the current directory and safes the ouputfiles there
#$ -pe smp 16#number of cpu reserved

date

module add Phylogeny/raxml/8.1.2;


raxmlHPC-PTHREADS-SSE3 -T 16 -x 1522 -f a -m GTRGAMMA -p 1522 -# 1000 -s ../to_use -n Alignment

#raxmlHPC -f d -s ../to_use -m GTRGAMMA -n ml_core175 


date
