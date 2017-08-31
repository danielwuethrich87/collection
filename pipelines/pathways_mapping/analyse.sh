#$ -q short.q
#$ -e $JOB_ID.pathway.err
#$ -o $JOB_ID.pathway.out
#$ -cwd #executes from the current directory and safes the ouputfiles there
#$ -pe smp 1





for i in MH0001 MH0002 MH0003 MH0004 #"all species" #"Anaerosphaera aminiphila" "Arthrobacter arilaitensis" "Atopostipes suicloacalis" "Brevibacterium linens" "Corynebacterium variabile" "Lactobacillus casei" "Lactobacillus delbrueckii" "Lactobacillus fermentum" "Lactobacillus helveticus" "Lactobacillus parabuchneri" "Lactobacillus paracasei" "Lactobacillus parafarraginis" "Lactobacillus plantarum" "Lactobacillus rhamnosus" "Lactococcus lactis" "Lactococcus raffinolactis" "Leuconostoc mesenteroides" "Marinilactibacillus psychrotolerans" "Pediococcus acidilactici" "Pediococcus pentosaceus" "Pediococcus stilesii" "Peptoniphilus stercorisuis" "Propionibacterium acidipropionici" "Propionibacterium acnes" "Propionibacterium freudenreichii" "Propionibacterium jensenii" "Propionibacterium thoenii" "Staphylococcus saprophyticus" "Streptococcus thermophilus"

do

species=${i//" "/"_"}

#echo -e "\t"$species > result/$species/pathways.tab
mkdir -p result/$species

python map_go.py ../metacyc/prepare_db/result /home/dwuethrich/Application/pfastGO_run/pfastGO-master/Software/databases/mapping/go.obo analysis/$species/all.go $species > result/$species/pathways.tab


done
