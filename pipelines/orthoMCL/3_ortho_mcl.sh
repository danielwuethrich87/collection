
#!/bin/sh


#$ -q all.q@binfservas09.unibe.ch
#$ -e $JOB_ID.ortho_mcl.err
#$ -o $JOB_ID.ortho_mcl.out
#$ -cwd #executes from the current directory and safes the ouputfiles there
#$ -pe smp 1


   export PATH=/software/bin:$PATH;
   module add SequenceAnalysis/OrthologyAnalysis/orthomclSoftware/2.0.9;

   export PATH=/software/bin:$PATH;
   module add Blast/ncbi-blast/2.2.28+;

export working_dir=$PWD



cd "$working_dir"/blastparallel

cat blast.* > blastparallel.tab

orthomclBlastParser "$working_dir"/blastparallel/blastparallel.tab "$working_dir"/input/renamed > "$working_dir"/blastparallel/parsed_blastparallel.tab

cd "$working_dir"





cd /data/users/dwuethrich/mySQL_server/mysql-5.6.15-linux-glibc2.5-x86_64

./bin/mysqld_safe --defaults-file=/data/users/dwuethrich/mySQL_server/my.cnf &

sleep 2000


mysql --defaults-file=/data/users/dwuethrich/mySQL_server/my.cnf -u root -e "create database orthomcl;"
mysql --defaults-file=/data/users/dwuethrich/mySQL_server/my.cnf -u root -e "GRANT SELECT,INSERT,UPDATE,DELETE,CREATE VIEW,CREATE, INDEX, DROP on orthomcl.* TO orthomcl@localhost;"

orthomclInstallSchema /data/users/dwuethrich/mySQL_server/mysql.configfile

cd "$working_dir"

orthomclLoadBlast /data/users/dwuethrich/mySQL_server/mysql.configfile "$working_dir"/blastparallel/parsed_blastparallel.tab

orthomclPairs /data/users/dwuethrich/mySQL_server/mysql.configfile log cleanup=yes

orthomclDumpPairsFiles /data/users/dwuethrich/mySQL_server/mysql.configfile

/home/dwuethrich/Application/mcl/mcl-12-068/mcl/bin/./mcl mclInput --abc -I 1.5 -o mclOutput

orthomclMclToGroups group 1000 < mclOutput > groups.txt

mysql --defaults-file=/data/users/dwuethrich/mySQL_server/my.cnf -u root -e "drop database orthomcl"

mysqladmin --socket=/data/users/dwuethrich/mySQL_server/socket/socket -u root shutdown

