module load java/1.8.0_66 
java='/hpcf/apps/java/jdk1.8.0_66/bin/java'
##
gatk_path='/home/xdong/softs/gatk-4.1.0.0/gatk'
picard_path='/home/xdong/softs/picard.jar'
java_mem='-Xms60000m'

input=$1
output=`echo $input | perl -pe 's/cr.seg/called.seg/g'`

$gatk_path --java-options "$java_mem" CallCopyRatioSegments \
  -I $input -O $output
