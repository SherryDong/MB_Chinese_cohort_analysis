module load java/1.8.0_66 
java='/hpcf/apps/java/jdk1.8.0_66/bin/java'
##
gatk_path='/home/xdong/softs/gatk-4.1.0.0/gatk'
picard_path='/home/xdong/softs/picard.jar'
java_mem='-Xms60000m'

sample_tumor=$1

ref_fasta="/home/xdong/db/GATK4/hg38/Homo_sapiens_assembly38.fasta"
ref_fasta_index="/home/xdong/db/GATK4/hg38/Homo_sapiens_assembly38.fasta.fai"
#pon_vcf="/home/xdong/db/GATK4/hg38/somatic-hg38-1000g_pon.hg38.vcf.gz"
pon_vcf="result/WES/GATK4/pon.vcf.gz";
germline="/home/xdong/db/GATK4/hg38/somatic-hg38-af-only-gnomad.hg38.vcf.gz"
tumor="result/WES/GATK4/${sample_tumor}/${sample_tumor}.aligned.duplicates_marked.recalibrated.bam"

$gatk_path --java-options "$java_mem" GetPileupSummaries \
  -I $tumor \
  -V "/home/xdong/db/GATK4/hg38/small_exac_common_3.hg38.vcf.gz" \
  -L "/home/xdong/db/GATK4/hg38/small_exac_common_3.hg38.vcf.gz" \
  -O result/WES/GATK4/${sample_tumor}/${sample_tumor}_getpileupsummaries.table

$gatk_path --java-options "$java_mem" CalculateContamination \
  -I result/WES/GATK4/${sample_tumor}/${sample_tumor}_getpileupsummaries.table  \
  -O result/WES/GATK4/${sample_tumor}/${sample_tumor}_calculatecontamination.table

