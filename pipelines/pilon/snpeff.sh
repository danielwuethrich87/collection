#$ -q all.q
#$ -e $JOB_ID.snpeff.err
#$ -o $JOB_ID.snpeff.out
#$ -cwd #executes from the current directory and safes the ouputfiles there
#$ -t 1-43
#$ -pe smp 1
#$ -tc 1

strain_names=( mock 0943_58 A_59 B_49 BIO_48 BOJ_47 C_CN4_9 C_EN01_7 C_HU2_3 C_IL9_5 CN4_25 C_TT01i_1 DE2_34 DE2_40 DE6_41 DIA_62 EN01_24 H06_42 Hb17_61 HU2_39 IL9_35 IR2_43 IT6_44 KC_57 LJ_63 M_CN4_10 M_EN01_8 MG_45 M_HU2_4 M_IL9_6 M_TT01i_2 PT1_31 PT1_33 PT1_37 RW_46 S10_54 S12_55 S14_60 S15_56 S5P8_50 S7_51 S8_52 S9_53 TT01_23)


export working_dir=$PWD
export i=${strain_names["$SGE_TASK_ID"]}

mkdir -p "$working_dir"/snpeff/"$i"

cd "$working_dir"/snpeff/"$i"

java -Xmx4g -jar /home/dwuethrich/Application/snpEff_v4.3a/snpEff/snpEff.jar -c /home/dwuethrich/Application/snpEff_v4.3a/snpEff/snpEff.config -v Photorhabdus_luminescens_subsp_laumondii_tto1 "$working_dir"/vcf_files/"$i".vcf > "$i".snpeff.vcf



