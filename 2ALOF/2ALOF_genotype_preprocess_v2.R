source("/home/yez/Schrodi_2ALOF/rpgm/2ALOF_process_sub.R")
inpath1 = "/mnt/bigdata/Genetic/Projects/EXOMECHIP_MARSHFIELD/tmp/"
inpath2 = "/mnt/bigdata/Genetic/Projects/EXOMECHIP_MARSHFIELD/"
outpath = "/mnt/bigdata/Genetic/Projects/Schrodi_2ALOF/data/phased_data_preprocess/"
outpath2 = "/mnt/bigdata/Genetic/Projects/Schrodi_2ALOF/data/"
ann_in = paste(inpath1,"FinalRelease_QC_20140311_Team1_Marshfield.annovar.hg19_multianno.csv",sep="")
vcf_info_in = paste(inpath2,"FinalRelease_QC_20140311_Team1_Marshfield.vcf.variant.info.update",sep="")
sam_info_in = paste(inpath2,"FinalRelease_QC_Phenotypes_Marshfield_20140224_Team1.txt",sep="")
ann_dat = read.csv(ann_in,header=TRUE)
vcf_info_dat = read.table(vcf_info_in,header=TRUE)
sam_dat = read.delim(sam_info_in,header=TRUE)
## read in gwas markers
gwas_in1 = paste(outpath2,"gwas_sig_snps_Jun_2015_hg19.bed",sep="")
gwas_in2 = paste(outpath2,"gwas_sig_snps_Jun_2015_hg19_unlifted_manual.bed",sep="")
gwas_dat1 = read.delim(gwas_in1,header=FALSE,stringsAsFactors=FALSE)
gwas_dat2 = read.delim(gwas_in2,header=FALSE,stringsAsFactors=FALSE)
gwas_dat = rbind(gwas_dat1,gwas_dat2)
colnames(gwas_dat) = c("CHR","START","END","SNP")
chr_num = as.numeric(substr(gwas_dat$CHR,4,nchar(gwas_dat$CHR)))
gwas_dat$CHR_NUM = chr_num
## define parameters
## chromosomes
chr_vec = c(1:22)
## main program
## preprocess the genotype data to only select the ones are needed
marker_summary = matrix(-1,nrow=length(chr_vec),ncol=3)
for(i in 1:length(chr_vec))
{
  ped_in = paste(inpath1,"exomechip_SNV_PASS_BEAGLE_chr",i,"_phased.ped",sep="") ## only PASS, SNV, no indel or other bad markers
  map_in = paste(inpath1,"exomechip_SNV_PASS_BEAGLE_chr",i,"_phased.map",sep="")
  map_dat = read.table(map_in,header=FALSE)
  #ped_dat = read.table(ped_in,header=FALSE,stringsAsFactors = FALSE,colClasses = c("character"))
  gwas_dat_chr = gwas_dat[gwas_dat$CHR_NUM==i,]
  gwas_dat_chr_ord = gwas_dat_chr[order(gwas_dat_chr$START),]
  pos = match(map_dat$V2,vcf_info_dat$ID)
  vcf_info_dat_map = vcf_info_dat[pos,]
  ann_dat_map = ann_dat[pos,]
  snp_num = dim(map_dat)[1] ## total number of markers phased
  ## overlap with GWAS SNPs,map by location of the SNPs (in hg19)      
  gwas_chr_sh = intersect(as.numeric(gwas_dat_chr_ord$START),map_dat$V4)
  map_dat_gwas = map_dat[match(gwas_chr_sh,map_dat$V4),]
  ## remove all the intergenic and intronic variants
  pos1 = grep("intergenic",ann_dat_map$Func.refGene)
  pos2 = grep("intronic",ann_dat_map$Func.refGene)
  pos_rm1 = unique(c(pos1,pos2))
  ## remove synonymous SNV, frameshift, unknown,
  pos3 = which(ann_dat_map$ExonicFunc.refGene=="synonymous SNV")
  pos4 = which(ann_dat_map$ExonicFunc.refGene=="synonymous SNV;synonymous SNV")
  pos5 = grep("frameshift",ann_dat_map$ExonicFunc.refGene)
  pos6 = grep("unknown",ann_dat_map$ExonicFunc.refGene)
  pos7 = which(ann_dat_map$ExonicFunc.refGene=="synonymous SNV;synonymous SNV;synonymous SNV")
  pos8 = which(ann_dat_map$ExonicFunc.refGene==".")
  pos_rm2 = unique(c(pos3,pos4,pos5,pos6,pos7,pos8))
  pos_rm = unique(c(pos_rm1,pos_rm2))
  map_dat2 = map_dat[-pos_rm,]
  #if(dim(map_dat_gwas)[1]>0)
  #{
  #  ## merge two data sets
  #  map_dat_all_tmp = merge(map_dat2,map_dat_gwas,by.x="V2",by.y="V2",all=TRUE)
  #  map_dat_all = map_dat_all_tmp[,c(5,1,6,7)] ## pick the columns
 
  #} else {
  #  map_dat_all = map_dat2
  #}
  ## find overlap between map_dat_gwas and map_dat2
  ol_var = intersect(map_dat_gwas$V2,map_dat2$V2)
  if(length(ol_var)>0)
  {
    ## remove ol_var from map_dat_gwas and then combine the data sets
    map_dat_gwas2 = map_dat_gwas[-match(ol_var,map_dat_gwas$V2),]
    map_dat_all = rbind(map_dat2,map_dat_gwas2)
    IND = c(rep("EXONIC",dim(map_dat2)[1]),rep("GWAS",dim(map_dat_gwas2)[1]))    
  } else {
    ## combine two data set, if there is no overlap variants
    map_dat_all = rbind(map_dat2,map_dat_gwas)
    IND = c(rep("EXONIC",dim(map_dat2)[1]),rep("GWAS",dim(map_dat_gwas)[1]))
  }  
  map_dat_all$IND = IND
  colnames(map_dat_all)[c(1:4)] = c("CHR","SNP","GD","BP")
  map_dat_all_ord = map_dat_all[order(map_dat_all$BP),]
  ann_dat_map4 = ann_dat_map[match(map_dat_all_ord$BP,ann_dat_map$Start),] ##ann_dat_map[-pos_rm,]
  vcf_info_dat_map2 = vcf_info_dat_map[match(map_dat_all_ord$BP,vcf_info_dat_map$POS),]
  #snp_out_info = data.frame(ann_dat_map4,vcf_info_dat_map2,map_dat2)
  snp_out_info = data.frame(ann_dat_map4,vcf_info_dat_map2,map_dat_all_ord)
  marker_out_list = map_dat_all_ord$SNP #map_dat2$V2
  #out_marker = paste(outpath,"chr",i,"_2ALOF_SNP_list",sep="")    
  #write.table(marker_out_list,file=out_marker,quote=FALSE,row.names=FALSE,col.names=FALSE)
  out_marker = paste(outpath,"chr",i,"_2ALOF_SNP_v2_list",sep="")
  write.table(marker_out_list,file=out_marker,quote=FALSE,row.names=FALSE,col.names=FALSE)
  marker_summary[i,1] = snp_num 
  marker_summary[i,2] = dim(map_dat_gwas)[1]#length(marker_out_list)
  marker_summary[i,3] = length(marker_out_list)
  out_marker2 = paste(outpath,"chr",i,"_2ALOF_SNP_info_comb_v2.RData",sep="")
  save(snp_out_info,file=out_marker2)

  print(i)
}         
marker_summary2 = data.frame(CHR=chr_vec,marker_summary)
colnames(marker_summary2)[-1] = c("SNP_TOT","SNP_GWAS","SNP_FINAL")
outf = paste(outpath,"2ALOF_marker_summary_v2.csv",sep="")
write.csv(marker_summary2,file=outf,row.names=FALSE)
