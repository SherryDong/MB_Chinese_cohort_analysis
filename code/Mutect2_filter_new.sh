module load java/1.8.0_66 
module load tabix
java='/hpcf/apps/java/jdk1.8.0_66/bin/java'
##
gatk_path='/home/xdong/softs/gatk-4.1.0.0/gatk'
picard_path='/home/xdong/softs/picard.jar'
java_mem='-Xms60000m'

#sample_tumor=$1
#input_vcf=result/WES/GATK4/${sample_tumor}/${sample_tumor}_${sample_normal}_step2.vcf.gz
#output_vcf=result/WES/GATK4/${sample_tumor}/${sample_tumor}_${sample_normal}_step2_filter.vcf.gz

prefix=$1
# result/WES/new_results/BT276_B276
input_vcf=${prefix}_step2.vcf.gz
output_vcf=${prefix}_step2_filter.vcf.gz
sample_tumor=`echo $prefix | awk -F '/' {'print $4'} | awk -F "_" {'print $1'}`

ref_fasta="/home/xdong/db/GATK4/hg38/Homo_sapiens_assembly38.fasta"
ref_fasta_index="/home/xdong/db/GATK4/hg38/Homo_sapiens_assembly38.fasta.fai"
#pon_vcf="/home/xdong/db/GATK4/hg38/somatic-hg38-1000g_pon.hg38.vcf.gz"
pon_vcf="result/WES/GATK4/pon.vcf.gz";
germline="/home/xdong/db/GATK4/hg38/somatic-hg38-af-only-gnomad.hg38.vcf.gz"
tabix -p vcf $input_vcf

$gatk_path --java-options "$java_mem" FilterMutectCalls \
  -V $input_vcf \
  --read-filter MappingQualityReadFilter \
  --unique-alt-read-count 2 --min-median-read-position 5 --min-strand-artifact-allele-fraction 0.01 --maximum-mapping-quality 50 \
  --contamination-table result/WES/new_results/${sample_tumor}_calculatecontamination.table \
  -O $output_vcf
