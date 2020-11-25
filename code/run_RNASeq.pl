#!/usr/bin/perl -w

$main_dir = "/home/xdong/project/BrainTumor/";
$salmon = "/home/xdong/bin/salmon";
$ref = "/home/xdong/db/Salmon_index_hg38/";

# X3_S45_L001_R1_001.fastq.gz 
#@all = split "\n",`ls $main_dir/data/RNASeq/`;
# R18048519LR01-BT280_combined_R1.fastq.gz
@all = split "\n",`ls $main_dir/data/public_MB/`;
foreach $each (@all){
	if($each =~ /^.*_RNA_paired_(ICGC_.*)_(.*)_1Sequence.txt.gz/){
		$name = "ICGC_".(split "_",$1)[1];
		$fastq{$name}{$each} = 1;
	}
}
##
foreach $name (keys %fastq){
	undef(@R1);
	undef(@R2);
	foreach $f1 (sort(keys %{$fastq{$name}})){
		$f2 = $f1;
		$f2 =~ s/_1S/_2S/g;
		#$ff1 = "data/RNASeq/$f1";
		#$ff2 = "data/RNASeq/$f2";
		$ff1 = "data/public_MB/$f1";
		$ff2 = "data/public_MB/$f2";
		if(-e $ff1 && -e $ff2){
			push(@R1,$ff1);
			push(@R2,$ff2);
		}else{
			print "Error, check $ff1,$ff2\n";
		}
	}
	$R1 = join " ",@R1;
	$R2 = join " ",@R2;
	$out = $main_dir."/result/RNASeq_public/$name\_salmon";
	$cmd = "$salmon quant -i $ref -l A -1 $R1 -2 $R2 -o $out";
	print $cmd."\n";
}
# cmd: salmon quant -i Ref -l A -1 R1 -2 R2 -o out
