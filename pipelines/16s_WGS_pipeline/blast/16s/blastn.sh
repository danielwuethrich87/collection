#$ -q all.q
#$ -e $JOB_ID.species_finding.err
#$ -o $JOB_ID.species_finding.out
#$ -cwd #executes from the current directory and safes the ouputfiles there
#$ -t 1-3
#$ -pe smp 4
#$ -tc 1

array=( mock MK401 RMK150 RMK202)

export i=${array["$SGE_TASK_ID"]}

export cores=$NSLOTS
export working_dir=$PWD
export temp=/scratch/"$JOB_ID"."$SGE_TASK_ID".all.q
module add Blast/ncbi-blast/2.2.31+;

mkdir -p "$working_dir"/results/blastn/

mkdir -p "$working_dir"/results/reads/

mkdir -p "$working_dir"/results/parsed_blast/


#python "$working_dir"/../script/select_PE_reads.py "$working_dir"/../../mapping/16s/assemblies/cov_selection/"$i"/mapped_trimmed.1.fastq "$working_dir"/../../mapping/16s/assemblies/cov_selection/"$i"/mapped_trimmed.2.fastq  > "$working_dir"/results/reads/"$i"_16s_reads.fasta

echo "$i"


#blastn -db "$working_dir"/../../db/SILVA_and_NCBI/NCBI_16s.fasta -num_threads "$cores" -max_target_seqs 250 -query "$working_dir"/results/reads/"$i"_16s_reads.fasta -out "$working_dir"/results/blastn/"$i".results.csv -outfmt "6 qseqid sseqid stitle qlen slen length pident nident mismatch gaps evalue bitscore"


python "$working_dir"/../script/parse_16s_blast.py "$working_dir"/results/blastn/"$i".results.csv "$working_dir"/results/reads/"$i"_16s_reads.fasta "$working_dir"/results/parsed_blast/"$i" > "$working_dir"/results/parsed_blast/"$i".result


