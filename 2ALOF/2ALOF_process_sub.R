
hap_sum <- function(hap1,hap2,len){
	snp_n = len
	G_MAT = data.frame(MIN_A=rep("",len),MIN_CT=rep(-1,len),MAJ_A=rep("",len),MAJ_CT=rep(-1,len),VAR=rep("Y",len),stringsAsFactors =FALSE)
	for(i in 1:snp_n){
		hap = c(paste(hap1[,i]),paste(hap2[,i]))
		pos_m = which(hap=="0")
		if(length(pos_m)==0)
		{
			hap_cl = hap
		} else {
			hap_cl = hap[-pos_m]
		}
    g_tb = table(hap)
		MAJ = names(g_tb)[which(g_tb==max(g_tb))]
    MIN = names(g_tb)[which(g_tb==min(g_tb))]
    G_MAT[i,1] = MIN 
		G_MAT[i,3] = MAJ
		G_MAT[i,2] = g_tb[which(g_tb==min(g_tb))]
		G_MAT[i,4] = g_tb[which(g_tb==max(g_tb))]
		if(MAJ==MIN){
     G_MAT[i,5] = "N"
		} 
	}
	G_MAT$MINMIN = paste(G_MAT$MIN_A,G_MAT$MIN_A,sep="")
  G_MAT$MAJMAJ = paste(G_MAT$MAJ_A,G_MAT$MAJ_A,sep="")
	return(G_MAT)
}


var_func_ct <- function(hap,G_MAT){	    
    pos1 = which(hap == G_MAT$MINMIN) ## minor alleles on different strands, 2
    pos2 = which(hap == G_MAT$MAJMAJ) ## major alleles on different stands
    pos3 = c(1:length(hap))[-c(pos1,pos2)]
    hp_het = hap[pos3]
    if(length(hp_het)>1){
		G_MAT_het = G_MAT[pos3,]
		strand_hap_het = matrix(0,nrow=2,ncol=length(pos3))
    for(i in 1:length(pos3)){
    hp_het_tmp = hp_het[i]
		min_c = ifelse(substr(hp_het_tmp,1,1) == G_MAT_het$MIN_A[i],1,2)
    strand_hap_het[min_c,i] = 1   	  
		}
		ss = apply(strand_hap_het,1,sum)
  	hap_het_score = ifelse(ss[1]*ss[2]>0,1,0)
	  } else {
	  hap_het_score = 0
	  }
    res = data.frame(hom_ref=length(pos2),hom_alt=length(pos1),het_compound=hap_het_score)
    return(res)
}


ALOF2_test <- function(gene_in,gene_ann,hap1_in,hap2_in,phen_in){ 
  gene_pos = which(gene_ann$Gene.refGene==gene_in)
  gene_ann_dat_map = gene_ann[gene_pos,]
  gene_orig_size = length(gene_pos)
  hap1_gene_dat = data.frame(hap1_in[,gene_pos])
  hap2_gene_dat = data.frame(hap2_in[,gene_pos])
  G_MAT = hap_sum(hap1_gene_dat,hap2_gene_dat,length(gene_pos))
  G_MAT = data.frame(G_MAT,gene_ann_dat_map)
  pos_novar = which(G_MAT$VAR=="N") ## no variantions of the marker
  gene_nohom_size = gene_orig_size - length(pos_novar)
  if(gene_nohom_size>0){
  if(length(pos_novar)>1){
    G_MAT2 = G_MAT[-pos_novar,]
    hap1_gene_dat2 = data.frame(hap1_gene_dat[,-pos_novar])
    hap2_gene_dat2 = data.frame(hap2_gene_dat[,-pos_novar])
    } else {
    G_MAT2 = G_MAT
    hap1_gene_dat2 = data.frame(hap1_gene_dat)
    hap2_gene_dat2 = data.frame(hap2_gene_dat)
  }
  # pos_hom_alt_ind = c()
  hap1_num_dat = hap2_num_dat = data.frame(matrix(0,nrow=dim(hap1_gene_dat2)[1],ncol=dim(G_MAT2)[1]))
  g_num_dat = matrix(0,nrow=dim(hap1_gene_dat2)[1],ncol=dim(G_MAT2)[1]) 
   for(j in 1:dim(G_MAT2)[1]){ 
    h1 = hap1_gene_dat2[,j]
    h2 = hap2_gene_dat2[,j]       
    hap1_num_dat[h1==G_MAT2$MIN_A[j],j] = 1
    hap2_num_dat[h2==G_MAT2$MIN_A[j],j] = 1
    g_num_dat[,j] = hap1_num_dat[,j] + hap2_num_dat[,j]
  }
 
  pos_hom_alt_ind = c()
  for(j in 1:dim(g_num_dat)[2]){
    g_tmp = g_num_dat[,j]
    pos_hom_alt = which(g_tmp==2)
    pos_hom_alt_ind = c(pos_hom_alt_ind,pos_hom_alt)
    }

  pos_hom_alt_ind = unique(pos_hom_alt_ind)
  A_hom = B_hom = C_hom = D_hom = 0
  A_het = B_het = C_het = D_het = 0
  if(length(pos_hom_alt_ind)>0){
    hap1_num_dat2 = data.frame(hap1_num_dat[-pos_hom_alt_ind,])
    hap2_num_dat2 = data.frame(hap2_num_dat[-pos_hom_alt_ind,])
    phen_hom_alt = phen_in[pos_hom_alt_ind]
    A_hom = A_hom + length(which(phen_hom_alt==case))
    C_hom = C_hom + length(which(phen_hom_alt==control))
    pheno2 = phen_in[-pos_hom_alt_ind]
    } else {
    hap1_num_dat2 = hap1_num_dat
    hap2_num_dat2 = hap2_num_dat
    pheno2 = phen_in
  }
  ## calculate the heterozygous cases
  ## minor alleles must come from different haplotype for each individual 
  hap1_score = apply(hap1_num_dat2,1,sum)
  hap2_score = apply(hap2_num_dat2,1,sum)
  hap_score = hap1_score*hap2_score
  pos_het_ind = which(hap_score>0)
  if(length(pos_het_ind)>0){
    pheno3_LOF = pheno2[pos_het_ind]
    pheno3_nLOF = pheno2[-pos_het_ind]

    ## LOF +
    A_het = A_het + length(which(pheno3_LOF==case))
    C_het = C_het + length(which(pheno3_LOF==control))

    ## LOF -
    B_het = B_het + length(which(pheno3_nLOF==case))
    D_het = D_het + length(which(pheno3_nLOF==control))

  } else {
    ## LOF -
    B_het = B_het + length(which(pheno2==case))
    D_het = D_het + length(which(pheno2==control))
  }

  A = A_hom + A_het
  B = B_hom + B_het
  C = C_hom + C_het
  D = D_hom + D_het

  stats_tb_hom = matrix(c(A_hom,B_hom,C_hom,D_hom),ncol=2)
  stats_tb_het = matrix(c(A_het,B_het,C_het,D_het),ncol=2)
  stats_tb_comb = matrix(c(A,B,C,D),ncol=2)
  dimnames(stats_tb_comb) = dimnames(stats_tb_het) = dimnames(stats_tb_hom) = list(c("LOF+","LOF-"),c("D+","D-"))
  #stats_test = fisher.test(stats_tb_comb)
  stats_test = fisher.test(stats_tb_comb,alternative="greater")
  } else {
    stats_tb_hom = stats_tb_het = stats_tb_comb = stats_test = G_MAT2 = "NA" 
  }
  res = list(gene_in,gene_orig_size,gene_nohom_size,stats_tb_hom,stats_tb_het,stats_tb_comb,stats_test,G_MAT,G_MAT2,table(phen_in))
  return(res)
}

if(F){
  A = B = C = D = rep(0,dim(hap1_gene_dat2)[1])
  for(j in 1:dim(hap1_gene_dat2)[1]){
    h1 = paste(hap1_gene_dat2[j,])
    h2 = paste(hap2_gene_dat2[j,])
    hp = paste(h1,h2,sep="")
    hp_score = as.numeric(var_func_ct(hp,G_MAT2))
    if(pheno[j]==1) ## diseased
    {
      if(hp_score[2]>0||hp_score[3]>0)
      {
        A[j] = 1
      } else {
        B[j] = 1
      }

    } else {
      if(hp_score[2]>0||hp_score[3]>0)
      {
        C[j] = 1
      } else {
        D[j] = 1
      }
    }
  }
  stats_tb = matrix(c(sum(A),sum(B),sum(C),sum(D)),ncol=2)
}
