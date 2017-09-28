https://github.com/bioperl/bioperl-live/blob/master/scripts/Bio-DB-GFF/bp_genbank2gff3.pl
raxmlHPC-PTHREADS-SSE3 -T "$NSLOTS" -x 1522 -f a -m GTRGAMMA -p 1522 -# 1000 -s ../core_gene_alignment.aln -n Alignment
raxmlHPC-PTHREADS-SSE3 -T "$NSLOTS" -x 1522 -f a -m PROTGAMMAWAG -p 1522 -# 1000 -s ../to_use -n Alignment
