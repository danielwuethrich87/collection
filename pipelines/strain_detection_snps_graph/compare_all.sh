#!/bin/sh
#$ -q all.q
#$ -e $JOB_ID.snp.err
#$ -o $JOB_ID.snp.out
#$ -cwd #executes from the current directory and safes the ouputfiles there
#$ -pe smp 1



python compare_strains.py
