Here are the quantitative measures from diffusion tensor MRI data.  The autism group will be writing a paper on the genetics of the imaging data.  I’d like to get you on as an author.  They are interested in a linear regression analysis for the whole exome variants against the quantitative measures, adjusting for age.  I think we can probably ignore case/control status in the analysis at this point.  There are some methods that incorporate both quantitative measures and case/control status, but we’ll explore those at a later time.  We can filter out many of the variants if they’re only observed in one individual.  We can also ignore some of the phenotypes (those which have little correlation with the case/control status) if needed.  I’ve done that analysis and will send to you.

1, check the normality

normality is not good. 

2, linear regression with/without age 

3, permutation test with/without family-wise correction



install.packages("openxlsx")

# 314 samples listed in quantitative iffusion tensor MRI data file
# 256 samples have whole-exom sequencing data
# 14 samples don't have MRI quantitative measurement 
# 19 samples were removed since quality control
# 242 samples were included for the assciation study (MRI ~ Allele + age)

# outlier samples
1, 2 low call rate ( u70704cl, u69388s)
2, Gender discrepancy(u38386cl,u65210cl,317814-UW)
3.1, Family(336051,395993 remove, keep 372278)
3.2, Family(370121 remove, keep 386915)
3.3  MZ twin(u28908s remove, keep u28906s-B-Redo)
3.4  duplicated samples (Saliva vs cell line) (u68413d remove, keep u68413s)
4.0  9 PCA outlier(u62997s,u1941001s,u90503s,u59502cl,u64061s,u65457s,u810031s,u810030s,u59504s)
totally, these samples were removed (space sparate): u62997s,u1941001s,u90503s,u59502cl,u64061s,u65457s,u810031s,u810030s,u59504s,u28908s,u68413s,370121,336051,395993,u38386cl,u65210cl,317814-UW,u70704cl,u69388s

Actually, I found the data have already removed 4.0, 3.4, 3.3, 

library("openxlsx")
phen=read.xlsx("DougsPhenotypes_with_avg_age_QTL.xlsx", sheet = 1)
fam<-read.table("All_samples_Exome_QC.fam")
rank1<-match(unlist(lapply(fam[,1],function(x) gsub("u","",strsplit(as.character(x),"-|s|c")[[1]][1]))),phen$ID)
newphen<-cbind(fam,phen[rank1,])
colnames(newphen)[1:2]<-c("FID","IID")
colnames(newphen)[11]<-c("AvgAge")

# prepare covariates plink file (All_samples_Exome_QC.cov, only have age)
cov<-newphen[,c(1,2,11)]
cov[is.na(cov)]<- -9
write.table(cov,file="DougsPhenotypes_with_avg_age_QTL.newphen.cov",sep="\t",quote=F,col.names=c("FID","IID","AvgAge"),row.names=F)

# prepare multiple phenotype plink file (All_samples_Exome_QC.phen)
mphen<-newphen[,c(1,2,13:ncol(newphen))]
mphen[is.na(mphen)]<- -9
write.table(mphen,file="All_samples_Exome_QC.phen",sep="\t",quote=F,col.names=F,row.names=T)

# update, steve think we can do the analysis in case and control separately. 
mphen<-newphen[,c(1,2,10,13:ncol(newphen))]
mphen[is.na(mphen[,3]),3]<- -9
mphen[mphen[,3]=="Case",3]=1
mphen[mphen[,3]=="Control",3]=0
mphen[is.na(mphen)]<- -9
write.table(mphen,file="All_samples_Exome_QC.phen",sep="\t",quote=F,col.names=T,row.names=F)

# use perl script to submit job and creat result file with corresponding phenotype names
exc<-read.table("excludeSample.txt")
match(exc[,1],newphen[,1])

# 1031667 variants removed due to MAF<0.01 and 1618874 variants and 249 samples pass filters and QC.  
plink2 --bfile All_samples_Exome_QC --ci 0.95 --genotypic --maf 0.01 --remove excludeSample.txt --allow-no-sex --pheno All_samples_Exome_QC.phen --mpheno 1 --covar All_samples_Exome_QC.cov --linear --out test
plink --bfile All_samples_Exome_QC --ci 0.95 --linear mperm=500  --maf 0.01 --remove excludeSample.txt --allow-no-sex --pheno All_samples_Exome_QC.phen --mpheno 1 --covar All_samples_Exome_QC.cov  --out test
plink --bfile binary_fileset --recode vcf-iid --out new_vcf
plink --bfile All_samples_Exome_QC --ci 0.95 --linear perm --aperm 10 1000000 0.0001 0.01 5 0.001  --maf 0.01 --remove excludeSample.txt --allow-no-sex --pheno All_samples_Exome_QC.phen --mpheno 1 --covar All_samples_Exome_QC.cov  --out test  



