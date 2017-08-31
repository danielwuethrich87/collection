#!/bin/sh


#$ -q all.q
#$ -e $JOB_ID.IPS.err
#$ -o $JOB_ID.IPS.out
#$ -cwd #executes from the current directory and safes the ouputfiles there
#$ -pe smp 16

cd proteins

export working_dir=$PWD
export SGE_TASK_ID=1

#awk '/>/ {counter+=1; OUT=counter".fa"}; OUT{print >OUT}' test.fasta



parallel -j 4 /mnt/apps/interproscan-5.14-53.0/interproscan-5.14-53.0/./interproscan.sh -dp ppn=4 -T /scratch/"$JOB_ID"."$SGE_TASK_ID".all.q -iprlookup -goterms -i  {1} -f XML ::: *.fa




