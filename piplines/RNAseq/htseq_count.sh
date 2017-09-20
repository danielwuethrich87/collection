#$ -q all.q
#$ -e $JOB_ID.htseq_count.err
#$ -o $JOB_ID.htseq_count.out
#$ -cwd #executes from the current directory and safes the ouputfiles there
#$ -pe smp 1

module add UHTS/Analysis/HTSeq/0.6.1;


export working_dir=$PWD

mkdir -p "$working_dir"/result/CDS
mkdir -p "$working_dir"/result/gene

for i in 1-3A 1-3C 1-3D MR3A MR3C MR3D

do

htseq-count -m intersection-nonempty -a 0 -t gene -i locus_tag -s reverse  "$working_dir"/../mapping/result/"$i"/remapping/aligment.sam  "$working_dir"/../../Clostridium_tyrobutyricum_FAM22553/genome/FAM22553.gb.no_pseudo.repeat_region.gff > "$working_dir"/result/gene/"$i".gene.counts
htseq-count -m intersection-nonempty -t CDS -i locus_tag -s reverse  "$working_dir"/../mapping/result/"$i"/remapping/aligment.sam  "$working_dir"/../../Clostridium_tyrobutyricum_FAM22553/genome/FAM22553.gb.no_pseudo.repeat_region.gff  > "$working_dir"/result/CDS/"$i".CDS.counts

done
