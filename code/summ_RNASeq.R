#### run
library(xlsx)
library(NetBID2)
salmon_dir <- 'result/RNASeq_public'
output_prefix <- 'MB_public'
#### generate phe; 11-A-Anti-424-pGIPZ-Meredith-Davis_salmon
all_f <- list.files(salmon_dir)
all_s <- gsub('(.*)_salmon', '\\1',all_f)
all_g <- all_s ## can modify to others, if replicates exist

phe_info <- read.xlsx('data/data_summary/nature22973-s1 (1).xlsx')
phe_info <- phe_info[which(phe_info$RNA_SEQ=='YES'),]

use_eset <- load.exp.RNASeq.demoSalmon(salmon_dir=salmon_dir,use_phenotype_info=phe_info,
                                              use_sample_col='PID',use_design_col='SUBGROUP',merge_level='transcript',return_type='eset')
use_eset_gene <- load.exp.RNASeq.demoSalmon(salmon_dir=salmon_dir,use_phenotype_info=phe_info,
                                              use_sample_col='PID',use_design_col='SUBGROUP',merge_level='gene',return_type='eset')
save(use_eset,use_eset_gene,file=sprintf("%s.RData",output_prefix))


