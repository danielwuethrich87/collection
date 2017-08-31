
#!/bin/sh


#$ -q all.q
#$ -e $JOB_ID.blast.err
#$ -o $JOB_ID.blast.out
#$ -cwd #executes from the current directory and safes the ouputfiles there
#$ -pe smp 16




module add Blast/ncbi-blast/2.2.29+;


export working_dir=$PWD


mkdir -p "$working_dir"/blast/result/
#cd /data/users/dwuethrich/Lcasei_pathway_modelling/sytheny_orthologe/Find_islands_by_syntheny_ortholog/blast2go/proteins
#cp ~/data1/Databases/blast2GO/microbial_ref_seq_1-may-2013/microbial_ref_seq_1-may-2013.fasta* /scratch/"$JOB_ID".1.all.q/
cd proteins
cp /data5/users/dwuethrich/nr_19_08_2015/nr* /scratch/"$JOB_ID".1.all.q/




parallel -j 16 "blastp -query {1} -db /scratch/"$JOB_ID".1.all.q/nr -outfmt 5 > ../blast/result/blast.{1}.xml" ::: *.fa

