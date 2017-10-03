
#!/bin/sh


#$ -q all.q
#$ -e $JOB_ID.roary.err
#$ -o $JOB_ID.roary.out
#$ -cwd #executes from the current directory and safes the ouputfiles there
#$ -pe smp 4


for i in Strain
do

for z in Strain

do
echo "$i" "$z"
java -jar OAT_cmd.jar -blastplus_dir /software/Blast/ncbi-blast/2.6.0+/bin/ -method ani -num_threads "$NSLOTS" -fasta1 ../../assembly/prokka/annotation/"$i"/"$i".fna -fasta2 ../../assembly/prokka/annotation/"$z"/"$z".fna

done

done












