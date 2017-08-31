#$ -q short.q
#$ -e $JOB_ID.qiime.err
#$ -o $JOB_ID.qiime.out
#$ -cwd #executes from the current directory and safes the ouputfiles there
#$ -pe smp 8


export working_dir=$PWD
export PATH="/home/dwuethrich/Application/miniconda/miniconda/bin:$PATH"
source activate qiime1
module add UHTS/Analysis/usearch/6.1.544;
count_seqs.py -i ../analysis_qiime/read_trimming_adaptors/final_reads/seqs.fna 

identify_chimeric_seqs.py -i ../analysis_qiime/read_trimming_adaptors/final_reads/seqs.fna -m usearch61 -o usearch_checked_chimeras/ -r /data/projects/p261_jores_16S/SILVA/SILVA_128_QIIME_release/rep_set/rep_set_16S_only/97/97_otus_16S.fasta

filter_fasta.py -f ../analysis_qiime/read_trimming_adaptors/final_reads/seqs.fna -o seqs_chimeras_filtered.fna -s usearch_checked_chimeras/chimeras.txt -n

pick_open_reference_otus.py -o otus/ -i seqs_chimeras_filtered.fna -p params.txt  -a --jobs_to_start 8 -r /data/projects/p261_jores_16S/SILVA/SILVA_128_QIIME_release/rep_set/rep_set_16S_only/97/97_otus_16S.fasta
biom summarize-table -i otus/otu_table_mc2_w_tax_no_pynast_failures.biom
core_diversity_analyses.py -o cdout/ -i otus/otu_table_mc2_w_tax_no_pynast_failures.biom -m map.tsv -t otus/rep_set.tre -e 1114 -p params_diversity.txt
make_emperor.py -i cdout/bdiv_even1114/weighted_unifrac_pc.txt -o cdout/bdiv_even1114/weighted_unifrac_emperor_pcoa_plot -m map.tsv --custom_axes Cow
make_emperor.py -i cdout/bdiv_even1114/unweighted_unifrac_pc.txt -o cdout/bdiv_even1114/unweighted_unifrac_emperor_pcoa_plot -m map.tsv --custom_axes Cow
source deactivate qiime1

