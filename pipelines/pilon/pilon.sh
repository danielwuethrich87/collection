#$ -q all.q
#$ -e $JOB_ID.pilon.err
#$ -o $JOB_ID.pilon.out
#$ -cwd #executes from the current directory and safes the ouputfiles there
#$ -t 1-43
#$ -pe smp 4
#$ -tc 10

strain_names=( mock 0943_58 A_59 B_49 BIO_48 BOJ_47 C_CN4_9 C_EN01_7 C_HU2_3 C_IL9_5 CN4_25 C_TT01i_1 DE2_34 DE2_40 DE6_41 DIA_62 EN01_24 H06_42 Hb17_61 HU2_39 IL9_35 IR2_43 IT6_44 KC_57 LJ_63 M_CN4_10 M_EN01_8 MG_45 M_HU2_4 M_IL9_6 M_TT01i_2 PT1_31 PT1_33 PT1_37 RW_46 S10_54 S12_55 S14_60 S15_56 S5P8_50 S7_51 S8_52 S9_53 TT01_23)


#array=( mock Sample_17275_1)

sleep "$SGE_TASK_ID"
export working_dir=$PWD
export i=${strain_names["$SGE_TASK_ID"]}

export R1="$working_dir"/../reads/"$i"_R1.fastq.gz
export R2="$working_dir"/../reads/"$i"_R2.fastq.gz
export ref="$working_dir"/reference/TTO1.fna
export cores=$NSLOTS
export temp=/scratch/"$JOB_ID"."$SGE_TASK_ID".all.q
echo "$i" starting `date`

cp $ref "$temp"/reference.fasta
cp $R1 "$temp"/r1.fastq.gz
cp $R2 "$temp"/r2.fastq.gz

module add UHTS/Analysis/samtools/1.3;
module add UHTS/Aligner/bwa/0.7.13;

mkdir -p "$temp"/"$i"/mapping


bwa index "$temp"/reference.fasta
bwa mem -t "$NSLOTS" "$temp"/reference.fasta "$temp"/r1.fastq.gz "$temp"/r2.fastq.gz > "$temp"/"$i"/mapping/alignment.sam

samtools sort -@ "$NSLOTS" -T "$i"_temp -o "$temp"/"$i"/mapping/sorted.bam "$temp"/"$i"/mapping/alignment.sam

samtools index "$temp"/"$i"/mapping/sorted.bam

mkdir -p "$working_dir"/mapping/"$i"

mv "$temp"/reference.fasta* "$working_dir"/mapping/"$i"
mv "$temp"/"$i"/mapping/sorted.bam* "$working_dir"/mapping/"$i"

mkdir "$working_dir"/mapping/"$i"/pilon

java -Xmx16G -jar /home/dwuethrich/Application/Pilon_1.22/pilon-1.22.jar --genome "$working_dir"/mapping/"$i"/reference.fasta --frags "$working_dir"/mapping/"$i"/sorted.bam --changes --variant --tracks --outdir "$working_dir"/mapping/"$i"/pilon --output "$i"


echo "$i" finished `date`

