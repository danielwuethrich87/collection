#$ -q all.q
#$ -e $JOB_ID.quiver.err
#$ -o $JOB_ID.quiver.out
#$ -cwd #executes from the current directory and safes the ouputfiles there
#$ -pe smp 16
#$ -t 1-12
#$ -tc 1

strain_names=( mock I46 I49 YL44 I48 KB1 KB18 YL27 YL31 YL32 YL45 YL58 YL2)
export i=${strain_names["$SGE_TASK_ID"]}

export LD_LIBRARY_PATH=/data/users/dwuethrich/Application/quiver_Dez_2016/pitchfork/deployment/lib:$LD_LIBRARY_PATH
export PATH=/data/users/dwuethrich/Application/quiver_Dez_2016/pitchfork/deployment/bin:$PATH
module add UHTS/Analysis/samtools/1.3;



mkdir -p result/"$i"

sawriter genomes/sequences/"$i".fasta.sa genomes/sequences/"$i".fasta
samtools faidx genomes/sequences/"$i".fasta
#blasr ../../pacbio/PacBio_baxh5_rawdata_11APR16/"$i"/*.bax.h5 genomes/sequences/"$i".fasta --out result/"$i"/alignment.bam --bam --nproc "$NSLOTS" --clipping subread --sa ../genomes/"$i".fasta.sa
blasr ../../pacbio/bam_files/"$i"/*subreads.bam genomes/sequences/"$i".fasta --out result/"$i"/alignment.bam --bam --nproc "$NSLOTS" --clipping subread --sa genomes/sequences/"$i".fasta.sa

samtools sort -@ "$NSLOTS" -T "$i"_temp -o result/"$i"/sorted.bam result/"$i"/alignment.bam
pbindex result/"$i"/sorted.bam
quiver result/"$i"/sorted.bam -r genomes/sequences/"$i".fasta -o result/"$i"/variants.gff -j "$NSLOTS" --algorithm arrow -o result/"$i"/"$i"_consensus.fasta -o result/"$i"/"$i"_consensus.fastq


