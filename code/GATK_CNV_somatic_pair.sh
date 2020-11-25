module load java/1.8.0_66 
java='/hpcf/apps/java/jdk1.8.0_66/bin/java'
##
gatk_path='/home/xdong/softs/gatk-4.1.0.0/gatk'
picard_path='/home/xdong/softs/picard.jar'
java_mem='-Xms60000m'

sample_tumor=$1
sample_normal=$2

ref_fasta="/home/xdong/db/GATK4/hg38/Homo_sapiens_assembly38.fasta"
ref_fasta_index="/home/xdong/db/GATK4/hg38/Homo_sapiens_assembly38.fasta.fai"
pon_vcf="/home/xdong/db/GATK4/hg38/somatic-hg38-1000g_pon.hg38.vcf.gz"
germline="/home/xdong/db/GATK4/hg38/somatic-hg38-af-only-gnomad.hg38.vcf.gz"
#tumor="result/WES/GATK4/${sample}/${sample}.aligned.duplicates_marked.recalibrated.bam"
tumor="result/WES/GATK4/${sample_tumor}/${sample_tumor}.final.bam"
normal="result/WES/GATK4/${sample_normal}/${sample_normal}.final.bam"
interval_list='/home/xdong/db/GATK4/hg38/intervals-whole_exome_illumina_coding_v1.Homo_sapiens_assembly38.targets.interval_list'

$gatk_path --java-options "$java_mem" ModelSegments \
  --denoised-copy-ratios result/WES/GATK4/${sample_tumor}/${sample_tumor}.denoisedCR.tsv \
  --normal-allelic-counts result/WES/GATK4/${sample_normal}/${sample_normal}.allelicCounts.tsv \
  --allelic-counts result/WES/GATK4/${sample_tumor}/${sample_tumor}.allelicCounts.tsv \
  --output-prefix ${sample_tumor}_${sample_normal} \
  -O result/WES/GATK4/${sample_tumor}/
