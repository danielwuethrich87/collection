#$ -q all.q
#$ -e $JOB_ID.dl.err
#$ -o $JOB_ID.dl.out
#$ -cwd #executes from the current directory and safes the ouputfiles there
#$ -pe smp 1

wget https://www.arb-silva.de/fileadmin/silva_databases/release_128/Exports/SILVA_128_SSUParc_tax_silva_trunc.fasta.gz
wget https://www.arb-silva.de/fileadmin/silva_databases/release_128/Exports/SILVA_128_SSUParc_tax_silva_trunc.fasta.gz.md5


#wget https://www.arb-silva.de/fileadmin/silva_databases/release_128/Exports/SILVA_128_SSURef_tax_silva_trunc.fasta.gz
#wget https://www.arb-silva.de/fileadmin/silva_databases/release_128/Exports/SILVA_128_SSURef_tax_silva_trunc.fasta.gz.md5

md5sum -c SILVA_128_SSUParc_tax_silva_trunc.fasta.gz.md5

#22-Sep-2016

