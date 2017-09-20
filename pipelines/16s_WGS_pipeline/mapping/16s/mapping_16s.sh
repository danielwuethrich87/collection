#$ -q all.q
#$ -e $JOB_ID.mapping_16s_DNA.err
#$ -o $JOB_ID.mapping_16s_DNA.out
#$ -cwd #executes from the current directory and safes the ouputfiles there
#$ -t 1-3
#$ -pe smp 4
#$ -tc 1

array=( mock MK401 RMK150 RMK202)



#array=( mock Sample_17275_1)

sleep "$SGE_TASK_ID"
export working_dir=$PWD
export i=${array["$SGE_TASK_ID"]}

export R1=/data/projects/p113_KTI_agroscope/reads/final_reads/reads/"$i"_R1.fastq.gz
export R2=/data/projects/p113_KTI_agroscope/reads/final_reads/reads/"$i"_R2.fastq.gz
export cores="$NSLOTS"
export temp=/scratch/"$JOB_ID"."$SGE_TASK_ID".all.q
echo "$i" starting `date`


cp $R1 "$temp"/r1.fastq.gz
cp $R2 "$temp"/r2.fastq.gz

mkdir -p "$working_dir"/assemblies/read_info_0/"$i"


module add UHTS/Analysis/picard-tools/2.2.1;
module add UHTS/Analysis/samtools/1.2;
module add UHTS/Analysis/GenomeAnalysisTK/3.3.0;
module add UHTS/Analysis/BEDTools/2.22.1;
module add UHTS/Aligner/bowtie2/2.2.4;

mkdir -p "$temp"/"$i"/cov_selection

#cp "$working_dir"/../prokka/annotation/"$i"/"$i"_*.fna "$temp"/"$i"/cov_selection/scaffolds.fa

#cat "$temp"/r1.fastq.gz "$temp"/r2.fastq.gz > "$temp"/reads.fastq.gz

bowtie2 --no-unal -p "$cores" -x /data/projects/p187_cattle_and_sheep_encephalitis/cattle/small_unit_16s_18s_analysis/db/silva_truncated_bacteria_and_archea/SILVA_123.1_SSURef_Nr99_tax_silva_trunc_no_uncultured_full_names_bacteria_and_archaea -1 "$temp"/r1.fastq.gz -2 "$temp"/r2.fastq.gz -S "$temp"/"$i"/cov_selection/scaffolds.sam 2> "$temp"/"$i"/cov_selection/mapping_Info."$i" # --un-conc-gz "$temp"/"$i"/cov_selection/not_aligned_reads.fastq.gz

samtools view -bS "$temp"/"$i"/cov_selection/scaffolds.sam > "$temp"/"$i"/cov_selection/scaffolds.bam

#java -jar "$PICARD_PATH"/picard.jar SortSam I="$temp"/"$i"/cov_selection/scaffolds.sam O="$temp"/"$i"/cov_selection/scaffolds.bam SO=queryname

samtools view -b -F 4 "$temp"/"$i"/cov_selection/scaffolds.bam > "$temp"/"$i"/cov_selection/mapped.bam

bedtools bamtofastq -i "$temp"/"$i"/cov_selection/mapped.bam -fq "$temp"/"$i"/cov_selection/mapped.1.fastq -fq2 "$temp"/"$i"/cov_selection/mapped.2.fastq

java -jar /home/dwuethrich/Application/Trimmomatic-0.33/Trimmomatic-0.33/trimmomatic-0.33.jar PE -threads "$cores" -phred33 "$temp"/"$i"/cov_selection/mapped.1.fastq "$temp"/"$i"/cov_selection/mapped.2.fastq "$temp"/"$i"/cov_selection/mapped_trimmed.1.fastq "$temp"/"$i"/cov_selection/mapped_trimmed.1.not_paired.fastq "$temp"/"$i"/cov_selection/mapped_trimmed.2.fastq "$temp"/"$i"/cov_selection/mapped_trimmed.2.not_paired.fastq SLIDINGWINDOW:4:20 MINLEN:127 ILLUMINACLIP:/home/dwuethrich/Application/Trimmomatic-0.33/Trimmomatic-0.33/adapters/TruSeq3-PE.fa:2:30:10  2> "$working_dir"/assemblies/read_info_0/"$i"/"$i".read_trimm_info

rm "$temp"/"$i"/cov_selection/*.sam
rm "$temp"/"$i"/cov_selection/scaffolds.bam

mkdir -p "$working_dir"/assemblies/cov_selection/"$i"

mv "$temp"/"$i"/cov_selection/* "$working_dir"/assemblies/cov_selection/"$i"/


#clean-up-------------------------------------------------------------------------------------------------------------------------

mkdir -p "$working_dir"/assemblies/final_scaffold/"$i"/


rm -rf "$temp"/"$i"/gap_filler/"$i".gap_filler/reads/





echo "$i" finished `date`

#fi


