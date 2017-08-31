#$ -q all.q
#$ -e $JOB_ID.qiime.err
#$ -o $JOB_ID.qiime.out
#$ -cwd #executes from the current directory and safes the ouputfiles there
#$ -pe smp 1


export working_dir=$PWD
export PATH="/home/dwuethrich/Application/miniconda/miniconda/bin:$PATH"
source activate qiime1
#count_seqs.py -i read_trimming_adaptors/final_reads/seqs.fna 
#pick_open_reference_otus.py -o otus/ -i ../analysis_qiime/read_trimming_adaptors/final_reads/seqs.fna -p params.txt  -a --jobs_to_start 16 -r /data/projects/p265_ITS_AMF_Jean_Yves/analysis_qiime/its_12_11_otus/rep_set/97_otus.fasta
#biom summarize-table -i otus/otu_table_mc2_w_tax_no_pynast_failures.biom
#core_diversity_analyses.py -o cdout/ -i otus/otu_table_mc2_w_tax.biom -m map.tsv -t otus/rep_set.tre -e 10 -p params_diversity.txt
#make_emperor.py -i cdout/bdiv_even1114/weighted_unifrac_pc.txt -o cdout/bdiv_even1114/weighted_unifrac_emperor_pcoa_plot -m map.tsv --custom_axes Cow
#make_emperor.py -i cdout/bdiv_even1114/unweighted_unifrac_pc.txt -o cdout/bdiv_even1114/unweighted_unifrac_emperor_pcoa_plot -m map.tsv --custom_axes Cow




#pnast alternative:

#identify_chimeric_seqs.py -i ../analysis_qiime/read_trimming_adaptors/final_reads/seqs.fna -m usearch61 -o usearch_checked_chimeras/ -r /data/projects/p261_jores_16S/SILVA/SILVA_128_QIIME_release/rep_set/rep_set_16S_only/97/97_otus_16S.fasta

#filter_fasta.py -f ../analysis_qiime/read_trimming_adaptors/final_reads/seqs.fna -o seqs_chimeras_filtered.fna -s usearch_checked_chimeras/chimeras.txt -n


#pick_open_reference_otus.py -o otus/ -i ../analysis_qiime/read_trimming_adaptors/final_reads/seqs.fna -p params.txt  -a --jobs_to_start 16 -r /data/projects/p265_ITS_AMF_Jean_Yves/analysis_qiime/its_12_11_otus/rep_set/97_otus.fasta


filter_alignment.py -o otus//mafft/ -i otus//mafft/rep_set.mafft.fasta
make_phylogeny.py -i otus/mafft/rep_set.mafft_pfiltered.fasta -o otus//rep_set.tre
core_diversity_analyses.py -o cdout/ -i otus/otu_table_mc2_w_tax.biom -m map.tsv -t otus/rep_set.tre -e 100 -p params_diversity.txt

source deactivate qiime1
