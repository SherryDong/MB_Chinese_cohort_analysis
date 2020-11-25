module load java/1.8.0_66 
java='/hpcf/apps/java/jdk1.8.0_66/bin/java'
##
gatk_path='/home/xdong/softs/gatk-4.1.0.0/gatk'
picard_path='/home/xdong/softs/picard.jar'
java_mem='-Xms60000m'

sample=$1

ref_fasta="/home/xdong/db/GATK4/hg38/Homo_sapiens_assembly38.fasta"
ref_fasta_index="/home/xdong/db/GATK4/hg38/Homo_sapiens_assembly38.fasta.fai"
pon_vcf="/home/xdong/db/GATK4/hg38/somatic-hg38-1000g_pon.hg38.vcf.gz"
germline="/home/xdong/db/GATK4/hg38/somatic-hg38-af-only-gnomad.hg38.vcf.gz"
tumor="result/WES/GATK4/${sample}/${sample}.aligned.duplicates_marked.recalibrated.bam"

$gatk_path --java-options "$java_mem" Mutect2 \
  -R $ref_fasta \
  -I $tumor \
  -tumor $sample \
  -O result/WES/GATK4/${sample}/${sample}_for_pon.vcf.gz \
