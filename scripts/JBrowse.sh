for i in FAM10769 FAM10772 FAM15172 FAM15175 FAM15190 FAM15192 FAM15299 FAM15333 FAM15346 FAM15347 FAM15381 FAM15407 FAM18355 FAM19471 FAM20869 FAM20871 FAM20872 FAM21954 FAM21957c1 FAM23160 FAM23942 FAM23975 FAM23976 FAM23977 FAM23978 FAM23979 FAM23980 FAM23981 FAM23982 FAM23983 FAM23984 FAM23985 FAM23986 FAM23987 FAM23988 FAM23989 FAM23990 FAM23991 FAM23992 FAM23993 FAM23994 FAM23995 FAM23996 FAM23997 FAM23998 FAM23999 FAM24000 FAM24001 FAM24002 FAM24003

do

bin/prepare-refseqs.pl --fasta /home/dialactdb/dialact_webserver/data/files_for_download/"$i"/"$i"*.fna --out sample_data/json/"$i"/
bin/flatfile-to-json.pl --gff /home/dialactdb/dialact_webserver/data/files_for_download/"$i"/"$i"*.gff --trackLabel genes --trackType CanvasFeatures --out sample_data/json/"$i"/
bin/generate-names.pl --out sample_data/json/"$i"

done
