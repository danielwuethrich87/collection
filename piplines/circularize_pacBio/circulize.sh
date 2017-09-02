#$ -q all.q
#$ -e $JOB_ID.circulize.err
#$ -o $JOB_ID.circulize.out
#$ -cwd #executes from the current directory and safes the ouputfiles there
#$ -pe smp 1

export working_dir=$PWD
export temp=/scratch/"$JOB_ID".1.all.q

module add Blast/ncbi-blast/2.6.0+;
mkdir result

for i in FAM1476c2 FAM22155p50 FAM8105p50 FAM8627p50 #  FAM1476c1


do

mkdir -p "$working_dir"/intermediate_results/"$i"

python /home/dwuethrich/Application/python/rename_contigs.py "$working_dir"/../hgap/results/"$i"/data/polished_assembly.fasta > "$working_dir"/intermediate_results/"$i"/polished_assembly.fasta

python "$working_dir"/python/split.py "$working_dir"/intermediate_results/"$i"/polished_assembly.fasta > "$working_dir"/intermediate_results/"$i"/split.fasta

makeblastdb -in "$working_dir"/intermediate_results/"$i"/split.fasta -dbtype nucl
blastn -db "$working_dir"/intermediate_results/"$i"/split.fasta -num_threads 1 -query "$working_dir"/intermediate_results/"$i"/split.fasta  -out "$working_dir"/intermediate_results/"$i"/split.fasta.tab -outfmt 6

python "$working_dir"/python/parse_blast.py "$working_dir"/intermediate_results/"$i"/split.fasta "$working_dir"/intermediate_results/"$i"/split.fasta.tab > "$working_dir"/intermediate_results/"$i"/circular.fasta
cp "$working_dir"/intermediate_results/"$i"/circular.fasta "$working_dir"/result/"$i"_circular.fasta



done
