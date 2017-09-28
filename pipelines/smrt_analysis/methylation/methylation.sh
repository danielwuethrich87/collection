#!/bin/sh

#$ -q all.q@binfservas12.unibe.ch
#$ -e $JOB_ID.hgap_methylation.err
#$ -o $JOB_ID.hgap_methylation.out
#$ -cwd #executes from the current directory and safes the ouputfiles there
#$ -pe smp 16

export working_dir=$PWD



for z in FAM22155_p1 FAM22155_p50_D01 FAM8105_p1 FAM8105_p50_E01 FAM8627_p1 FAM8627_p50_C01
do

mkdir -p "$working_dir"/results/"$z"/data

#gunzip -c "$working_dir"/../hgap/quiver/results/"$z"/data/polished_assembly.fasta.gz > "$working_dir"/../hgap/quiver/results/"$z"/data/polished_assembly.fasta

cp /data/projects/p155_helveticus_genome_alterations/PacBio/rotate_genomes/final_genomes/no_quiver_in_name/"$z".fasta "$working_dir"/results/"$z"/data/draft_assembly.fasta



cd "$working_dir"/results/"$z"


export SEYMOUR_HOME=/mnt/apps/smrtanalysis-2.2.0/smrtanalysis_location/install/smrtanalysis-2.2.0.133377
source $SEYMOUR_HOME/etc/setup.sh
module add UHTS/Analysis/samtools/1.3;


mkdir "$working_dir"/results/"$z"/reference
referenceUploader -c -p "$working_dir"/results/"$z"/reference -n "$z" -f "$working_dir"/results/"$z"/data/draft_assembly.fasta
samtools faidx "$working_dir"/results/"$z"/reference/"$z"/sequence/"$z".fasta




mkdir /scratch/smrtpipe2_2

for i in /data/projects/p155_helveticus_genome_alterations/PacBio/reads/"$z"/*.bax.h5; do echo "$i"; done > reads.fofn

fofnToSmrtpipeInput.py reads.fofn  > reads.xml


python ~/Application/python/replace_string.py "$working_dir"/params.xml "<value>/data/users/dwuethrich/L.parabuchneri/PacBio/Methylation/reference/FAM21731</value>" "<value>/data/projects/p155_helveticus_genome_alterations/PacBio/methylation/results/"$z"/reference/"$z"</value>" > "$working_dir"/params_specific.xml

smrtpipe.py -D MAX_THREADS=16 --params="$working_dir"/params_specific.xml xml:reads.xml

rm -rf /scratch/smrtpipe2_2

done






