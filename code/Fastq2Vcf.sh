module load R
module load java/1.8.0_66 
java='/hpcf/apps/java/jdk1.8.0_66/bin/java'
##
readgroup_name=$1
#fastq_prefix=$2
fastq_1=$2
#$fastq_prefix\_R1.trimmed.fastq.gz
fastq_2=$3
#$fastq_prefix\_R2.trimmed.fastq.gz
##
output_dir=result/WES/GATK4/${readgroup_name}
mkdir $output_dir
##
QC_dir=$output_dir
##
# 150120_I188_FCC6L5DANXX_L5_HUMujaEAAAAAAA-32_2.clean.fq.gz
# data/WES/Ydata/WGC051983U_combined_R2.fastq.gz
run_date=`date '+%Y-%m-%d'`
##
main_dir='/home/xdong/project/BrainTumor/'
tmp_dir='/home/xdong/tmp/'
## name
sample_name=$readgroup_name
base_file_name=$readgroup_name
final_gvcf_base_name=$readgroup_name
out_path=${output_dir}/${readgroup_name}
flowcell_unmapped_bams=${output_dir}/${readgroup_name}.unmapped.bam
library_name=$readgroup_name
## reference
ref_dict="/home/xdong/db/GATK4/hg38/Homo_sapiens_assembly38.dict"
ref_fasta="/home/xdong/db/GATK4/hg38/Homo_sapiens_assembly38.fasta"
ref_fasta_index="/home/xdong/db/GATK4/hg38/Homo_sapiens_assembly38.fasta.fai"
ref_alt="/home/xdong/db/GATK4/hg38/Homo_sapiens_assembly38.fasta.64.alt"
# Mills_and_1000G_gold_standard.indels.hg38.vcf.gz
known_indels_sites_VCFs_1="/home/xdong/db/GATK4/hg38/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz"
known_indels_sites_indices_1="/home/xdong/db/GATK4/hg38/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz.tbi"
known_indels_sites_VCFs_2="/home/xdong/db/GATK4/hg38/Homo_sapiens_assembly38.known_indels.vcf.gz"
known_indels_sites_indices_2="/home/xdong/db/GATK4/hg38/Homo_sapiens_assembly38.known_indels.vcf.gz.tbi"
dbSNP_vcf="/home/xdong/db/GATK4/hg38/dbsnp_146.hg38.vcf.gz"
dbSNP_vcf_index="/home/xdong/db/GATK4/hg38/dbsnp_146.hg38.vcf.gz.tbi"
wgs_coverage_interval_list="/home/xdong/db/GATK4/hg38/wgs_coverage_regions.hg38.interval_list"
wgs_evaluation_interval_list="/home/xdong/db/GATK4/hg38/wgs_evaluation_regions.hg38.interval_list"
## workflow string
bwa_disk_multiplier=2.5
sort_sam_disk_multiplier=3.25
md_disk_multiplier=2.25
max_duplication_in_reasonable_sample=0.30
max_chimerism_in_reasonable_sample=0.15
haplotype_scatter_count=50
bash_ref_fasta=${ref_fasta}
bwa_commandline="/hpcf/apps/bwa/install/0.7.12/bwa mem -K 100000000 -p -v 3 -t 1 -Y $bash_ref_fasta"
recalibrated_bam_basename=${base_file_name}.aligned.duplicates_marked.recalibrated
compression_level=2
java_mem='-Xms60000m'
platform_name='illumina'
sequencing_center='NextCode'
## path
gatk_path='/home/xdong/softs/gatk-4.1.0.0/gatk'
picard_path='/home/xdong/softs/picard.jar'
bwa_path='/hpcf/apps/bwa/install/0.7.12/bwa'
bwa_version=`$bwa_path 2>&1 | grep -e '^Version' |  sed 's/Version: //'`
samtools_path='/hpcf/apps/samtools/vendor/1.2/samtools'
## Steps
##
#${gatk_path} --java-options "$java_mem" \
#      FastqToSam \
#      --FASTQ ${fastq_1} \
#      --FASTQ2 ${fastq_2} \
#      --OUTPUT $out_path\.unmapped.bam \
#      --READ_GROUP_NAME ${readgroup_name} \
#      --SAMPLE_NAME ${sample_name} \
#      --LIBRARY_NAME ${library_name} \
#      --RUN_DATE ${run_date} \
#      --PLATFORM ${platform_name} \
#      --TMP_DIR $tmp_dir \
#      --SEQUENCING_CENTER ${sequencing_center} 

# QC the unmapped BAM:CollectQualityYieldMetrics
#input_bam=$flowcell_unmapped_bams
#metrics_filename=${QC_dir}/${readgroup_name}.unmapped.quality_yield_metrics
#echo "Start CollectQualityYieldMetrics for $readgroup_name"
##java $java_mem -jar $picard_path CollectQualityYieldMetrics INPUT=${input_bam} OQ=true OUTPUT=${metrics_filename}
#echo "Finish CollectQualityYieldMetrics for $readgroup_name; check ${metrics_filename}"
#
## Map reads to reference:SamToFastqAndBwaMemAndMba 
#output_bam_basename=$output_dir/${readgroup_name}.aligned.unsorted
#echo "Start SamToFastqAndBwaMemAndMba for $readgroup_name"
#$java $java_mem -jar $picard_path SamToFastq  INPUT=${input_bam} FASTQ=/dev/stdout INTERLEAVE=true NON_PF=true | \
#	$bwa_commandline /dev/stdin - 2> >(tee ${output_bam_basename}.bwa.stderr.log >&2) | \
#	java -Dsamjdk.compression_level=${compression_level} $java_mem -jar $picard_path MergeBamAlignment VALIDATION_STRINGENCY=SILENT EXPECTED_ORIENTATIONS=FR  ATTRIBUTES_TO_RETAIN=X0  ATTRIBUTES_TO_REMOVE=NM  ATTRIBUTES_TO_REMOVE=MD  ALIGNED_BAM=/dev/stdin  UNMAPPED_BAM=${input_bam}  OUTPUT=${output_bam_basename}.bam  REFERENCE_SEQUENCE=${ref_fasta}  PAIRED_RUN=true  SORT_ORDER="unsorted"  IS_BISULFITE_SEQUENCE=false  ALIGNED_READS_ONLY=false  CLIP_ADAPTERS=false  MAX_RECORDS_IN_RAM=2000000  ADD_MATE_CIGAR=true  MAX_INSERTIONS_OR_DELETIONS=-1  PRIMARY_ALIGNMENT_STRATEGY=MostDistant  PROGRAM_RECORD_ID="bwamem"  PROGRAM_GROUP_VERSION="${bwa_version}"  PROGRAM_GROUP_COMMAND_LINE="${bwa_commandline}"  PROGRAM_GROUP_NAME="bwamem"  UNMAPPED_READ_STRATEGY=COPY_TO_TAG  ALIGNER_PROPER_PAIR_FLAGS=true  UNMAP_CONTAMINANT_READS=true  ADD_PG_TAG_TO_READS=false	
#
#echo "Finish SamToFastqAndBwaMemAndMba for $readgroup_name; check ${output_bam_basename}.bam"
#
## QC the aligned but unsorted readgroup BAM, no reference as the input here is unsorted, providing a reference would cause an error: CollectUnsortedReadgroupBamQualityMetrics 
#input_bam=${output_bam_basename}.bam
#output_bam_prefix=$QC_dir/${readgroup_name}.readgroup
#echo "Start CollectUnsortedReadgroupBamQualityMetrics for $readgroup_name"
#$java $java_mem -jar $picard_path CollectMultipleMetrics INPUT=${input_bam} OUTPUT=${output_bam_prefix} ASSUME_SORTED=true PROGRAM="null" PROGRAM="CollectBaseDistributionByCycle" PROGRAM="CollectInsertSizeMetrics" PROGRAM="MeanQualityByCycle" PROGRAM="QualityScoreDistribution" METRIC_ACCUMULATION_LEVEL="null" METRIC_ACCUMULATION_LEVEL="ALL_READS"
#echo "Finish CollectUnsortedReadgroupBamQualityMetrics for $readgroup_name; check ${output_bam_prefix}"
#
## Aggregate aligned+merged flowcell BAM files and mark duplicates: MarkDuplicates 
#input_bams=${output_bam_basename}.bam
#output_bam_basename=$output_dir/${base_file_name}.aligned.unsorted.duplicates_marked
#metrics_filename=$output_dir/${base_file_name}.duplicate_metrics
#echo "Start MarkDuplicates"
#$java -Dsamjdk.compression_level=${compression_level} $java_mem -jar $picard_path MarkDuplicates INPUT=$input_bams OUTPUT=${output_bam_basename}.bam METRICS_FILE=${metrics_filename} VALIDATION_STRINGENCY=SILENT \
#      READ_NAME_REGEX=read_name_regex OPTICAL_DUPLICATE_PIXEL_DISTANCE=2500 ASSUME_SORT_ORDER="queryname" CLEAR_DT="false" ADD_PG_TAG_TO_READS=false
#echo "Finish MarkDuplicates"
#
## Sort aggregated+deduped BAM file and fix tags: SortSampleBam 
#input_bam=${output_bam_basename}.bam
#output_bam_basename=$output_dir/${base_file_name}.aligned.duplicate_marked.sorted
#echo "Start SortSampleBam"
#$java -Dsamjdk.compression_level=${compression_level} $java_mem -jar $picard_path SortSam INPUT=${input_bam} OUTPUT=${output_bam_basename}.bam SORT_ORDER="coordinate" CREATE_INDEX=true CREATE_MD5_FILE=true MAX_RECORDS_IN_RAM=300000 TMP_DIR=$tmp_dir
#echo "Finish SortSampleBam"

######################################################################################################
#### merge different bam files

# Generate the recalibration model by interval: BaseRecalibrator 
output_bam_basename=$output_dir/${base_file_name}.aligned.duplicate_marked.sorted
input_bam=${output_bam_basename}.bam
recalibration_report_filename=$output_dir/${base_file_name}.recal_data.csv
echo "Start BaseRecalibrator"
#$gatk_path --java-options "-XX:GCTimeLimit=50 -XX:GCHeapFreeLimit=10 -XX:+PrintFlagsFinal -XX:+PrintGCTimeStamps -XX:+PrintGCDateStamps -XX:+PrintGCDetails -Xloggc:gc_log.log $java_mem" \
$gatk_path --java-options "$java_mem" \
      BaseRecalibrator -R ${ref_fasta} -I ${input_bam} --use-original-qualities -O ${recalibration_report_filename} --known-sites ${dbSNP_vcf} \
      --known-sites ${known_indels_sites_VCFs_1}  --known-sites ${known_indels_sites_VCFs_2}
echo "Finish BaseRecalibrator"

output_report_filename=$recalibration_report_filename

# Apply the recalibration model by interval: ApplyBQSR 
input_bam=${output_bam_basename}.bam
output_bam_basename=$output_dir/${recalibrated_bam_basename}
recalibration_report=$output_report_filename
echo "Start ApplyBQSR"
#$gatk_path --java-options "-XX:+PrintFlagsFinal -XX:+PrintGCTimeStamps -XX:+PrintGCDateStamps -XX:+PrintGCDetails -Xloggc:gc_log.log -XX:GCTimeLimit=50 -XX:GCHeapFreeLimit=10 -Dsamjdk.compression_level=${compression_level} $java_mem" \
$gatk_path --java-options "$java_mem" \
     ApplyBQSR  --create-output-bam-md5 --add-output-sam-program-record -R ${ref_fasta} -I ${input_bam} --use-original-qualities -O ${output_bam_basename}.bam \
    -bqsr ${recalibration_report} --static-quantized-quals 10 --static-quantized-quals 20 --static-quantized-quals 30 
echo "Finish ApplyBQSR"

# QC the final BAM: CollectReadgroupBamQualityMetrics 
input_bam=${output_bam_basename}.bam
input_bam_index=${output_bam_basename}.bai
output_bam_prefix=$QC_dir/${base_file_name}.readgroup_CollectReadgroupBamQualityMetrics
echo "Start CollectReadgroupBamQualityMetrics"
$java $java_mem -jar $picard_path CollectMultipleMetrics INPUT=${input_bam} \
      REFERENCE_SEQUENCE=${ref_fasta} OUTPUT=${output_bam_prefix} ASSUME_SORTED=true PROGRAM="null" PROGRAM="CollectAlignmentSummaryMetrics" \
      PROGRAM="CollectGcBiasMetrics" METRIC_ACCUMULATION_LEVEL="null" METRIC_ACCUMULATION_LEVEL="READ_GROUP" 
echo "Finish CollectReadgroupBamQualityMetrics"

