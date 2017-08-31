#!/bin/sh


#$ -q all.q
#$ -e $JOB_ID.b2g.err
#$ -o $JOB_ID.b2g.out
#$ -cwd #executes from the current directory and safes the ouputfiles there
#$ -pe smp 1


export working_dir=$PWD



cd /mnt/apps/blast2go_Pipe/b2g4pipe/

export i=FAM21731


#for i in 18121 18149 Zhang BD_II LOCK919

#do



cat "$working_dir"/blast/result/*.xml > "$working_dir"/blast/"$i".blast.xml

mkdir -p "$working_dir"/blast2go/"$i"/

java -cp *:ext/*: es.blast2go.prog.B2GAnnotPipe -in "$working_dir"/blast/"$i".blast.xml -out "$working_dir"/blast2go/"$i"/"$i" -prop "$working_dir"/b2gPipe.properties -v -annot -dat -annex -goslim -wiki html_template.html # -img
 
#done
#fi
