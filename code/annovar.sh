prefix=$1
input_vcf=${prefix}_step2_filter.vcf.gz
# pass
input_av=${prefix}_step2_filter.pass.avinput
output=${prefix}_step2_filter.pass
#perl /home/xdong/db/ANNOVAR/convert2annovar.pl -format vcf4 -allsample -withfreq -filter pass $input_vcf >$input_av
#perl /home/xdong/db/ANNOVAR/table_annovar.pl $input_av /home/xdong/db/ANNOVAR/humandb_hg38/ -buildver hg38 -out $output -protocol refGene,ensGene,clinvar_20180603,kaviar_20150923,esp6500siv2_all,hrcr1,ljb26_all,cosmic70,dbnsfp33a,nci60,1000g2015aug_all,1000g2015aug_eas,exac03,esp6500siv2_ea -operation g,g,f,f,f,f,f,f,f,f,f,f,f,f

# all
input_av=${prefix}_step2_filter.avinput
output=${prefix}_step2_filter
##
perl /cluster/apps/refseq/ANNOVAR//convert2annovar.pl -format vcf4 -allsample -withfreq -withfilter -includeinfo $input_vcf >$input_av
perl /cluster/apps/refseq/ANNOVAR//table_annovar.pl $input_av /cluster/apps/refseq/ANNOVAR/humandb_hg19/ -buildver hg19 -out $output -protocol refGene,ensGene,clinvar_20180603,kaviar_20150923,esp6500siv2_all,hrcr1,ljb23_all,cosmic70,dbnsfp33a,nci60,1000g2015aug_all,1000g2015aug_eas,exac03,esp6500siv2_ea -operation g,g,f,f,f,f,f,f,f,f,f,f,f,f -otherinfo
