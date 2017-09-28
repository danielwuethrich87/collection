#!/bin/sh

#$ -q all.q
#$ -e $JOB_ID.hgap.err
#$ -o $JOB_ID.hgap.out
#$ -cwd #executes from the current directory and safes the ouputfiles there
#$ -pe smp 16

export working_dir=$PWD

COUNT=0
genome_sizes=(2200000 2200000 2200000 2200000 2200000 2200000)

for z in FAM22155_p1 FAM22155_p50_D01 FAM8105_p1 FAM8105_p50_E01 FAM8627_p1 FAM8627_p50_C01
do

mkdir -p "$working_dir"/results/"$z"

cd "$working_dir"/results/"$z"


export SEYMOUR_HOME=/mnt/apps/smrtanalysis-2.2.0/smrtanalysis_location/install/smrtanalysis-2.2.0.133377

source $SEYMOUR_HOME/etc/setup.sh

mkdir /scratch/smrtpipe2_2

for i in /data/projects/p155_helveticus_genome_alterations/PacBio/reads/"$z"/*.bax.h5; do echo "$i"; done > reads.fofn

fofnToSmrtpipeInput.py reads.fofn  > reads.xml

genome_size=${genome_sizes["$COUNT"]}
let COUNT=COUNT+1
python ~/Application/python/replace_string.py "$working_dir"/params.xml "\"genomeSize\"><value>2000000</value></param>" "\"genomeSize\"><value>"$genome_size"</value></param>" > "$working_dir"/params_specific.xml

smrtpipe.py -D MAX_THREADS=16 --params="$working_dir"/params_specific.xml xml:reads.xml

rm -rf /scratch/smrtpipe2_2

done






