
source("2ALOF_process_sub.R")

inpath = "/mnt/bigdata/Genetic/Projects/Schrodi_2ALOF/data/phased_data_preprocess/"
outpath = "/home/guosa/hpc/Schrodi_2ALOF/result/"

#inpath1 = "/mnt/bigdata/Genetic/Projects/EXOMECHIP_MARSHFIELD/tmp/"
#inpath2 = "/mnt/bigdata/Genetic/Projects/EXOMECHIP_MARSHFIELD/"
#ann_in = paste(inpath1,"FinalRelease_QC_20140311_Team1_Marshfield.annovar.hg19_multianno.csv",sep="")
#vcf_info_in = paste(inpath2,"FinalRelease_QC_20140311_Team1_Marshfield.vcf.variant.info.update",sep="")
#sam_info_in = paste(inpath2,"FinalRelease_QC_Phenotypes_Marshfield_20140224_Team1.txt",sep="")
#ann_dat = read.csv(ann_in,header=TRUE)
#vcf_info_dat = read.table(vcf_info_in,header=TRUE)
#sam_dat = read.delim(sam_info_in,header=TRUE)
## define parameters
## chromosomes
chr_vec = c(1:22)

## prepare phenotype file
############################################################################################
## read in phenotypes
## two_alof_Phetyp1_RA_Converted.csv
## two_alof_Phetyp3_PA_Converted.csv
## two_alof_Phetyp6_SCL_ANA_ENA_Converted.csv
############################################################################################
#inpath_ph = "/mnt/bigdata/Genetic/Projects/Schrodi_2ALOF/data/"
#phen_dat = read.csv(paste(inpath_ph,"two_alof_Phetyp1_RA_Converted.csv",sep=""),header=TRUE)
#phen_dat2 = phen_dat[match(dem_dat$V1,phen_dat$SampleName),]
#pheno = phen_dat2$PheTyp1_RA_C1
## case and control codes

phen_dat = read.csv(paste(inpath,"two_alof_all_combed_v3.csv",sep=""),header=TRUE)
phen_num = dim(phen_dat)[2] - 4
phen_name = colnames(phen_dat)[-c(1:4)]

case = 2
control = 1

## find duplicates
 
SID_tb = table(phen_dat$SubjectID)
SID_dup_tb = SID_tb[which(SID_tb>1)]
dup_SID = names(SID_dup_tb)
SID_num_vec = c()
pos_vec = c()
for(i in 1:length(dup_SID))
{ 
  SID_num = SID_dup_tb[i]
  pos = which(phen_dat$SubjectID==dup_SID[i])
  
  SID_num_vec = c(SID_num_vec,rep(dup_SID[i],SID_num))
  pos_vec = c(pos_vec,pos)
}
  
SID_POS_mat = data.frame(SID=SID_num_vec,POS=pos_vec)

SID_pos_rm = SID_POS_mat$POS[2*c(1:length(dup_SID))-1]

for(i in 1:length(chr_vec))
{

  snp_info_in = paste(inpath,"chr",i,"_2ALOF_SNP_info_comb_v2.RData",sep="")
  load(snp_info_in) ## snp_out_info
  
  gene_sum_out = paste(inpath,"chr",i,"_2ALOF_SNP_info_comb_v2_summary.csv",sep="")

  gene_sum_tb = table(paste(snp_out_info$Gene.refGene),snp_out_info$IND)

  gene_sum_tb2 = data.frame(GENE=rownames(gene_sum_tb),EXONIC=as.numeric(gene_sum_tb[,1]),GWAS=as.numeric(gene_sum_tb[,2]))
  
  write.csv(gene_sum_tb2,file=gene_sum_out,row.names=FALSE)

}

## start main program

#for(i in 1:length(chr_vec))

#test_res = list()
 
#for(k in 1:phen_num) ##for(k in 1:1)
#for(k in 17:18)
for(k in 1:phen_num)
{

  pheno = phen_dat[-SID_pos_rm,(k+4)]

  phen_gen_res = list()
  
  #outf1 = paste(outpath,phen_name[k],"_result_list_v3.RData",sep="")
  #outf2 = paste(outpath,phen_name[k],"_res_summary_v3.csv",sep="")

  outf1 = paste(outpath,phen_name[k],"_result_list_v4.RData",sep="")
  outf2 = paste(outpath,phen_name[k],"_res_summary_v4.csv",sep="")

  #phen_gen_sum = data.frame()

  ct = 1

  for(i in 1:length(chr_vec)) ##for(i in 21:22)
  { 
    #ped_in = paste(inpath,"exomechip_SNV_PASS_BEAGLE_chr",i,"_phased_sel.ped",sep="")
    #map_in = paste(inpath,"exomechip_SNV_PASS_BEAGLE_chr",i,"_phased_sel.map",sep="")
    
    ped_in = paste(inpath,"exomechip_SNV_PASS_BEAGLE_chr",i,"_phased_sel2.ped",sep="")
    map_in = paste(inpath,"exomechip_SNV_PASS_BEAGLE_chr",i,"_phased_sel2.map",sep="")

    map_dat = read.table(map_in,header=FALSE)
    ped_dat0 = read.table(ped_in,header=FALSE,stringsAsFactors = FALSE,colClasses = c("character"))

    ped_dat = ped_dat0[-SID_pos_rm,]

    ## load chr*_2ALOF_SNP_info_comb.RData
    
    #snp_info_in = paste(inpath,"chr",i,"_2ALOF_SNP_info_comb.RData",sep="")
    snp_info_in = paste(inpath,"chr",i,"_2ALOF_SNP_info_comb_v2.RData",sep="")
    load(snp_info_in) ## snp_out_info
    #dim(snp_out_info)  
    #length(table(paste(snp_out_info$Gene.refGene)))
    #table(paste(snp_out_info$Gene.refGene))[1:10]    
    #in2 = snp_out_info

    if(F){
    snp_info_in2 = paste(inpath,"chr",i,"_2ALOF_SNP_info_comb.RData",sep="")
    load(snp_info_in2)
    in1 = snp_out_info
    dim(snp_out_info)
    length(table(paste(snp_out_info$Gene.refGene)))
    table(paste(snp_out_info$Gene.refGene))[1:10]
    }
    snp_num = dim(map_dat)[1]
    hap1_loc = c(1:snp_num)*2 - 1 + 6
    hap2_loc = c(1:snp_num)*2 + 6
    hap1_dat = ped_dat[,hap1_loc]
    hap2_dat = ped_dat[,hap2_loc]
    ## run gene-based 2ALOF test
    col_num = match("Otherinfo",colnames(snp_out_info))
    ann_dat_chr = snp_out_info[,c(1:col_num)]
    gene_tb = table(paste(snp_out_info$Gene.refGene))
    print(length(gene_tb))
    p_vec = sn_vec = sn_vec2 = c()    
    comb_ct_vec = matrix(-1,nrow=length(gene_tb),ncol=4)

    for(j in 1:length(gene_tb))
    {
      gene_in = names(gene_tb)[j]
      gene_res = ALOF2_test(gene_in,ann_dat_chr,hap1_dat,hap2_dat,pheno) 

      #test_res[[j]] = gene_res

      sn_vec[j] = gene_res[[2]]
      sn_vec2[j] = gene_res[[3]]

      if(gene_res[[3]]>0)
      {
        p_vec[j] = gene_res[[7]]$p.value
        comb_ct_vec[j,] = as.vector(gene_res[[6]])
      } else {
        p_vec[j] = NA
        comb_ct_vec[j,] = rep(0,4)
      }
      #print(j)

    }
        
    #outf3 = paste(outpath,phen_name[k],"_res_chr",i,"_v2.RData",sep="")
    #save(test_res,file=outf3)
    
    comb_res_sum = data.frame(CHR=i,GENE=names(gene_tb),P=p_vec,ORIG_SNP=sn_vec,NOHOM_SNP=sn_vec2,comb_ct_vec)

    print(i)

    if(ct==1)
    {
      phen_gen_sum = comb_res_sum
    } else {
      phen_gen_sum = rbind(phen_gen_sum,comb_res_sum)
    }

    ct = ct + 1
  }

  write.csv(phen_gen_sum,file=outf2,row.names=FALSE)  

  outf4 = paste(outpath,phen_name[k],"_res_summary_order_v4.csv",sep="")
  phen_gen_sum_ord = phen_gen_sum[order(phen_gen_sum$P),]
  write.csv(phen_gen_sum_ord,file=outf4,row.names=FALSE)

  print(k)

}


if(F){

for(k in 1:phen_num) ##for(k in 1:1)
{
  pheno = phen_dat[,(k+4)]

  outf2 = paste(outpath,phen_name[k],"_res_summary_v2.csv",sep="")
  dat2 = read.csv(file=outf2,header=TRUE)

  dat3 = dat2[order(dat2$P),]
      
  #outf3 = paste(outpath,phen_name[k],"_res_summary_order.csv",sep="")  

  print(k)
  print(phen_name[k])
  print(table(pheno))
  print(range(dat2$P,na.rm=TRUE))
 
  ##write.csv(dat3,file=outf3,row.names=FALSE)
}
}
## dat3 = dat2[order(dat2$P),]
