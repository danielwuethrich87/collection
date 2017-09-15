
#!/bin/sh


#$ -q all.q
#$ -e $JOB_ID.rename.err
#$ -o $JOB_ID.rename.out
#$ -cwd #executes from the current directory and safes the ouputfiles there
#$ -pe smp 1


   export PATH=/software/bin:$PATH;
   module add SequenceAnalysis/OrthologyAnalysis/orthomclSoftware/2.0.9;

   export PATH=/software/bin:$PATH;
   module add Blast/ncbi-blast/2.2.29+;

export working_dir=$PWD





mkdir -p "$working_dir"/input/renamed
cd  "$working_dir"/input/renamed

for i in 4877 5b CNRZ32 DPC4571 EH_01_D14 EH_01_D7 EH_09_D14 EH_09_D7 FAM10769 FAM10772 FAM10789 FAM1079 FAM10792 FAM10793 FAM10794 FAM10852 FAM10859 FAM10892 FAM10921 FAM10921p FAM10973 FAM10980 FAM10983 FAM10989 FAM10991 FAM10996 FAM11001 FAM11008 FAM11009 FAM11010 FAM11017 FAM11021 FAM11024 FAM11036 FAM11049 FAM11051 FAM11063 FAM11071 FAM11075 FAM11077 FAM11089 FAM11100 FAM11108c1 FAM11108c2 FAM11117 FAM11129 FAM11141 FAM11142 FAM11143 FAM11194 FAM11194f FAM11199 FAM11206 FAM1172 FAM1172i0 FAM11791 FAM1182 FAM1200c1 FAM1200c3 FAM12062 FAM12080 FAM12103 FAM12104 FAM12105 FAM12107 FAM12109 FAM12111c1 FAM12111c2 FAM1213 FAM1233 FAM1300 FAM1301 FAM13019 FAM1302 FAM13073 FAM13473 FAM13491 FAM13492 FAM13493 FAM13494 FAM13495 FAM13496 FAM13497 FAM13498 FAM13499c1 FAM13499c2 FAM13500 FAM13671 FAM13672 FAM13673 FAM13674 FAM13675 FAM13676 FAM13677 FAM13677f FAM13679 FAM13680 FAM13680f FAM13681 FAM13682 FAM13683 FAM13684 FAM13685 FAM13686 FAM13686f FAM13687 FAM13688 FAM13688f FAM13875 FAM13875p FAM13877 FAM13881 FAM14162 FAM14176f FAM14176p FAM14177 FAM14184 FAM14193 FAM14197 FAM14217 FAM14217p FAM14218f FAM14221 FAM14222 FAM14225 FAM14274 FAM14275 FAM14276 FAM14278 FAM14279c1c1 FAM14279c1c2 FAM14279c2 FAM14280c1c1 FAM14280c2c1 FAM1430 FAM14498c1 FAM14498c2 FAM14499 FAM1450 FAM14500 FAM1450i0 FAM1476c1 FAM1476c1p FAM1476c2 FAM1476c2i0 FAM1476c2p FAM1479 FAM15061 FAM15078 FAM15113 FAM15170 FAM15172 FAM15175 FAM15190 FAM15192 FAM15299 FAM15300 FAM15333 FAM15346 FAM15347 FAM15381 FAM15407 FAM1605 FAM1620 FAM1621 FAM1622 FAM1623 FAM16825 FAM16864c1 FAM16864c2 FAM16960 FAM17250 FAM17252 FAM17275c1 FAM17275c2 FAM17291 FAM17293 FAM17303 FAM17306 FAM17309 FAM17315 FAM17322 FAM17330 FAM17361 FAM17407 FAM17411 FAM17418 FAM17419c1 FAM17419c2 FAM17419c2i0 FAM17419c4 FAM17420c1 FAM17420c1i0 FAM17420c2 FAM17422 FAM17622 FAM17635 FAM17644 FAM17644i0 FAM17654 FAM17654c1 FAM17656 FAM17656i0 FAM17691 FAM17708 FAM17708i0 FAM17724 FAM17744 FAM17839 FAM17840 FAM17841 FAM17842 FAM17867 FAM17868 FAM17869 FAM17870 FAM17871 FAM17872 FAM17875 FAM17880 FAM17881 FAM17885 FAM17888 FAM17891 FAM17899 FAM17906 FAM17918 FAM17919c1 FAM17919c2 FAM17920 FAM17921 FAM17922 FAM17923 FAM17926 FAM17927 FAM17932c1 FAM17932c2 FAM17940 FAM17941 FAM17944 FAM17954c2 FAM17957 FAM17958 FAM17959 FAM17960 FAM18027 FAM18027BIM1 FAM18027BIM2 FAM18027BIM3 FAM18098 FAM18098p FAM18099 FAM18101 FAM18105 FAM18108 FAM18110 FAM18113 FAM18113c1 FAM18113c2 FAM18119 FAM18121 FAM18123 FAM18124 FAM18126 FAM18129 FAM18132 FAM18133 FAM18133c2 FAM18149 FAM18149p FAM18157 FAM1815c1 FAM1816 FAM18168 FAM18172 FAM18175 FAM18230 FAM18321 FAM18327 FAM18355 FAM18356 FAM18357 FAM18358 FAM18359 FAM18360 FAM18362c1 FAM18362c2 FAM18813 FAM18814 FAM18814p FAM18815 FAM18964 FAM18969 FAM18986 FAM18987 FAM18988 FAM19014 FAM19015 FAM19016 FAM19019 FAM19020 FAM19022 FAM19023 FAM19024 FAM19025 FAM19026 FAM19028f FAM19029 FAM19030 FAM19031 FAM19032 FAM19033 FAM19034 FAM19036 FAM19036p FAM19038 FAM19038p FAM19071 FAM19080 FAM19083 FAM19086 FAM19116 FAM19132 FAM19132p FAM19133 FAM19134 FAM19135 FAM19136 FAM19137 FAM19138 FAM19139 FAM19140 FAM19141 FAM19142 FAM19144 FAM19148 FAM19149 FAM19150 FAM19151 FAM19152 FAM19153 FAM19154 FAM19155 FAM19156 FAM19157 FAM19158 FAM19159 FAM19160 FAM19169 FAM19180 FAM19188 FAM19189c1 FAM19189c2 FAM19190c1 FAM19190c2 FAM19191 FAM19245 FAM19282 FAM19317 FAM19317c2 FAM19324 FAM19353 FAM19390 FAM19393 FAM19404 FAM19460 FAM19461 FAM19462 FAM19464 FAM19466 FAM19471 FAM19475 FAM19476 FAM19488 FAM19500 FAM19503c1 FAM19503c2 FAM19503c3 FAM19551c1 FAM19551c2 FAM19598 FAM19612 FAM19614 FAM19619 FAM19641 FAM19651 FAM19699 FAM19701 FAM19852 FAM19853 FAM19857 FAM19879 FAM19882 FAM19953 FAM19955 FAM19994 FAM20059 FAM20072 FAM20284 FAM20293 FAM20301 FAM20303 FAM20310 FAM20323f FAM20325 FAM20355 FAM20380 FAM20399 FAM20406 FAM20408 FAM20430 FAM20440 FAM20446 FAM20449 FAM20455 FAM20479 FAM20494 FAM20497 FAM20498 FAM20521 FAM20532 FAM20544 FAM20547 FAM20547i0 FAM20550 FAM20551 FAM20552 FAM20553 FAM20554 FAM20555 FAM20556 FAM20557 FAM20557i0 FAM20558 FAM20559 FAM20559i0 FAM20560 FAM20561 FAM20562 FAM20564 FAM20575 FAM20576 FAM20579 FAM20580 FAM20585 FAM20586 FAM20620 FAM20622 FAM20623 FAM20624 FAM20624i0 FAM20650 FAM20673 FAM20715 FAM20833 FAM20860 FAM20860p FAM20869 FAM20871 FAM20872 FAM20892 FAM20897 FAM20898 FAM20910 FAM20926 FAM20934 FAM21277 FAM21339 FAM21339c1 FAM21339c2 FAM21340c1 FAM21340c2 FAM21341c1 FAM21341c2 FAM21346c1 FAM21346c2 FAM21346c3 FAM21348c1 FAM21348c2 FAM21376 FAM21456 FAM21456i0 FAM21462 FAM21463 FAM21493 FAM21493i0 FAM21721 FAM21722 FAM21724 FAM21727 FAM21731 FAM21731p FAM21745c1 FAM21745c2 FAM21747 FAM21748 FAM21753 FAM21754 FAM21755c1 FAM21755c2 FAM21756c1 FAM21756c2 FAM21757 FAM21758 FAM21768 FAM21769 FAM21780 FAM21781 FAM21783 FAM21784 FAM21789 FAM21790 FAM21809c1 FAM21809c2 FAM21809c3 FAM21823 FAM21829 FAM21834 FAM21835 FAM21838 FAM21877 FAM21878 FAM21879 FAM21880 FAM21881 FAM21900 FAM21914 FAM21954 FAM21955 FAM21956 FAM21957c1 FAM21957c2 FAM21958 FAM21959 FAM21961 FAM21965 FAM21966 FAM21972 FAM21973 FAM21975 FAM21977 FAM21978 FAM21989 FAM21990 FAM21991 FAM21992 FAM21993 FAM21997 FAM21998 FAM21999 FAM22000 FAM22002 FAM22003 FAM22019 FAM22020 FAM22021 FAM22064 FAM22076 FAM22077 FAM22078 FAM22079 FAM22080c1 FAM22080c2 FAM22081 FAM22091c1 FAM22091c2 FAM22106 FAM22132 FAM22135 FAM22144 FAM22155p FAM22156 FAM22157 FAM22166 FAM22192 FAM22234 FAM22235 FAM22243 FAM22257 FAM22258 FAM22259 FAM22260 FAM22261 FAM22262 FAM22274 FAM22276 FAM22277 FAM22278 FAM22279 FAM22280 FAM22284 FAM22284p FAM22287 FAM22292 FAM22330 FAM22332 FAM22337 FAM22361 FAM22362 FAM22363 FAM22364 FAM22365 FAM22366 FAM22367 FAM22367p FAM22368 FAM22369 FAM22436 FAM22437 FAM22472 FAM22680 FAM22754 FAM23160 FAM23162 FAM23163 FAM23164 FAM23165 FAM23166 FAM23167 FAM23168 FAM23169 FAM23170 FAM23171 FAM23213 FAM23214 FAM23215 FAM23216 FAM23217 FAM23218 FAM23219 FAM23220 FAM23237 FAM23240 FAM23261 FAM23262 FAM23263 FAM23264 FAM23275 FAM23276 FAM23277 FAM23278 FAM23279 FAM23280 FAM23281 FAM23282 FAM23285 FAM23291 FAM23631 FAM23847 FAM23848 FAM23849 FAM23850 FAM23851 FAM23852 FAM23853 FAM23854 FAM23855 FAM23856 FAM23859 FAM23860 FAM23861 FAM23863 FAM23864 FAM23865 FAM23866 FAM23867 FAM23868 FAM23869 FAM23870 FAM23871 FAM23872 FAM23877 FAM23924 FAM23925 FAM23926 FAM23927 FAM23931 FAM23941 FAM23942 FAM23943 FAM23944 FAM23975 FAM23976 FAM23977 FAM23978 FAM23979 FAM23980 FAM23981 FAM23982 FAM23983 FAM23984 FAM23985 FAM23986 FAM23987 FAM23988 FAM23989 FAM23990 FAM23991 FAM23992 FAM23993 FAM23994 FAM23995 FAM23996 FAM23997 FAM23998 FAM23999 FAM24000 FAM24001 FAM24002 FAM24003 FAM2884 FAM2888 FAM2888c1 FAM2888c2 FAM2911 FAM2920 FAM2921 FAM2924 FAM3228 FAM3248 FAM3257 FAM3265 FAM4067 FAM4795 FAM5011 FAM6009 FAM6012 FAM6161 FAM6165 FAM6410 FAM6896c1 FAM6896c2 FAM7821 FAM8101 FAM8102c1c1 FAM8102c2 FAM8102c3c1 FAM8103c1 FAM8104c1 FAM8104c2 FAM8105c2 FAM8105p FAM8106c1 FAM8106c2 FAM8107 FAM8108c1 FAM8108c2 FAM8108c3 FAM8109 FAM8110c1 FAM8110c2 FAM8111c1c1 FAM8111c1c2 FAM8111c2 FAM8140 FAM8374 FAM8407 FAM8520 FAM8627p FSK_Cottens FSK_La_Praz G52 LH_32 LH_B02 MK401 NBRC100932 PIGR_YC_381 RMK150 RMK202 RMK202v2 RMK202v3 RMK202v5 Tilsit04 Tilsit13




do

orthomclAdjustFasta "$i" /data/projects/p313_dialact_2/analysis/assembly/results/"$i"/3_annotation/"$i"*.faa 1

#mv "$i".fasta "$working_dir"/input/renamed

done



mkdir "$working_dir"/blastparallel 


cd "$working_dir"/blastparallel

orthomclFilterFasta "$working_dir"/input/renamed 1 50

/home/dwuethrich/Application/diamond/diamond makedb --in goodProteins.fasta -d goodProteins.fasta


