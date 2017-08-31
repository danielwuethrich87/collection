#!/bin/sh

#$ -q all.q
#$ -e $JOB_ID.clustalo.err
#$ -o $JOB_ID.clustalo.out
#$ -cwd #executes from the current directory and safes the ouputfiles there
#$ -pe smp 6 #number of cpu reserved



mkdir gene_cluster
mkdir alignment

cd python_scripts

module add SequenceAnalysis/MultipleSequenceAlignment/clustal-omega/1.2.1;

python calculate_core_genome.py ../../ortho_MCL/groups_all.tab ../all_genes/all_CDS.fna

cd ../gene_cluster

parallel -j 6 "
clustalo -i {1} --outfmt=vie  --full -o ../alignment/{1}.clustaw
" ::: *.fasta


cat ../alignment/*.clustaw > ../alignment/all_alignments


python ../python_scripts/fuse_vienna_alignments.py ../alignment/all_alignments > ../to_use
