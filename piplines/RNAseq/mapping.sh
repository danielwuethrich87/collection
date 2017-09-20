#$ -q all.q
#$ -e $JOB_ID.mapping.err
#$ -o $JOB_ID.mapping.out
#$ -cwd #executes from the current directory and safes the ouputfiles there
#$ -t 1-6
#$ -pe smp 8



module add UHTS/Aligner/bowtie2/2.2.1;
sleep "$SGE_TASK_ID"0

export working_dir=$PWD
export temp=/scratch/"$JOB_ID"."$SGE_TASK_ID".all.q

array=( mock 1-3A 1-3C 1-3D MR3A MR3C MR3D)

export i=${array["$SGE_TASK_ID"]}

mkdir -p "$temp"/bowtie2/"$i"/remapping

cp "$working_dir"/../reads/"$i"_R1.fastq.gz "$temp"/bowtie2/"$i"/r1.fastq.gz


cp "$working_dir"/../../Clostridium_tyrobutyricum_FAM22553/genome/FAM22553.gb.fasta "$temp"/bowtie2/"$i"/remapping/scaffolds.fasta



wait
bowtie2-build "$temp"/bowtie2/"$i"/remapping/scaffolds.fasta "$temp"/bowtie2/"$i"/remapping/build > "$temp"/bowtie2/"$i"/remapping/buildingInfo
wait
#--local
bowtie2 --un-gz "$temp"/bowtie2/"$i"/remapping/unmapped.gz -p 8 -x "$temp"/bowtie2/"$i"/remapping/build -U "$temp"/bowtie2/"$i"/r1.fastq.gz -S "$temp"/bowtie2/"$i"/remapping/aligment.sam 2> "$temp"/bowtie2/"$i"/remapping/coverAgeInfo."$i"
wait

rm "$temp"/bowtie2/"$i"/*.fastq.gz

mkdir -p "$working_dir"/result/

mv "$temp"/bowtie2/"$i" "$working_dir"/result/"$i"


