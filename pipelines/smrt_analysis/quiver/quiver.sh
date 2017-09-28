#$ -q all.q
#$ -e $JOB_ID.blasr.err
#$ -o $JOB_ID.blasr.out
#$ -cwd #executes from the current directory and safes the ouputfiles there
#$ -pe smp 8


export LD_LIBRARY_PATH=/data/users/dwuethrich/Application/quiver_Dez_2016/pitchfork/deployment/lib:$LD_LIBRARY_PATH
export PATH=/data/users/dwuethrich/Application/quiver_Dez_2016/pitchfork/deployment/bin:$PATH

#for i in m54123_161208_125715.subreads.bam m54123_161213_104541.subreads.bam m54123_161213_175419.subreads.bam m54123_161214_010356.subreads.bam m54123_161214_081340.subreads.bam m54123_161214_152332.subreads.bam

#do

blasr ../reads/*.subreads.bam /data/references/horse/igenomes/Equus_caballus/Ensembl/EquCab2/Sequence/WholeGenomeFasta/genome.fa --out "$i"_alignment.bam --bam --nproc "$NSLOTS" --clipping soft
#quiver alignment.bam -r ../genomes/Akkermansia_YL44.fa -o variants.gff # -o consensus.fasta -o consensus.fastq #-j "$NSLOTS" --algorithm arrow

#done
