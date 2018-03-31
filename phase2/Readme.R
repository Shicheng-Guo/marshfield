
# copy data from the raw data source
# Map file genomic version: hg19 (GRCh37) 
cd ~/hpc/pmrp/phase2
cp /mnt/bigdata/Genetic/Projects/S_Hebbring_2128_Released_Data/SNP_Information/SNP_Annotation/CoreExome_24v1p2_A1_Anno.csv  ./ 

cd ~/hpc/pmrp/phase2
cp /mnt/bigdata/Genetic/Projects/S_Hebbring_2128_Released_Data/PLINK_Files/*Rel.* ./

# Rel data analysis. However, I found Unt data is better to use. 
# fill up missing values for the probes without rs number in the column of RS_dbSNP137
# be careful, in CoreExome_24v1p2 array, there are some probes target to same SNP. therefore, bim/map might have Duplicate ID 'rs115741058'
# you can try to change any 'rs115741058' to 'rs115741058.2'
anno<-read.csv("CoreExome_24v1p2_A1_Anno.csv")
map<-read.table("S_Hebbring_Rel.bim")
RS_dbSNP137<-as.character(anno$RS_dbSNP137)
Name<-as.character(anno$Name)
RS_dbSNP137[which(RS_dbSNP137=="")]<-Name[which(RS_dbSNP137=="")]
anno$RS_dbSNP137=RS_dbSNP137
write.csv(anno,file="CoreExome_24v1p2_A1_Anno.Guo.2018.March.csv")
# replace the illuma ID in the binary map (bim) with RS_dbSNP137 for the publication
# Give an postfix to avoid problem: Duplicate ID 'rs115741058'
newRS_dbSNP137=make.names(anno[match(map[,2],anno$Name),]$RS_dbSNP137,unique=T)
map[,2]=newRS_dbSNP137
write.table(map,file="../S_Hebbring_Rel.Guo.bim",sep="\t",quote=F,col.names=F,row.names=F)
# pca analysis to phase 2 dataset
plink2 --bfile S_Hebbring_Rel.Guo --pca approx  --maf 0.05 --memory 30000 --out phase2.pca
# Postive control test: rs1800562 (chr6): represents a SNP that accounts for ~85% of all cases of hemochromatosis
# exm2253593 and exm596 are same to rs115741058
plink --bfile S_Hebbring_Rel.Guo --make-bed --snps rs1800562 --out rs1800562
plink --bfile rs1800562 --recode --tab --out rs1800562
# check homozygotes AA in 8648 individuals
grep 'A A' rs1800562.ped | wc -l    # 24 patients were found with AA homozygotes
# check other Hemochromatosis genes ( rs2280673 in RAB6B;  rs1800730 in HFE and rs235756 in the BMP2)
# what a pity, rs235756 in the BMP2 is not included by current array
# rs1799945 in the HFE gene, also known as H63D (risk genotype GG)
plink --bfile S_Hebbring_Rel.Guo --make-bed --snps rs1800562,rs1799945,rs2280673,rs1800730 --out Hemochromatosis
plink --bfile Hemochromatosis --recode --tab --out Hemochromatosis
plink --bfile S_Hebbring_Unr.Guo --maf 0.05 --hardy

# gender discrepancy: only 1.07 have --check-sex (not 1.9 and 2.0)
plink107 --bfile S_Hebbring_Unr.Guo --impute-sex --make-bed --out newfile

# genotyping ratio <5% (--mind 0.05)
plink --bfile S_Hebbring_Unr.Guo --missing
plink107 --bfile S_Hebbring_Unr.Guo --check-sex 

# binary to ped and map
plink --bfile S_Hebbring_Unr.Guo --recode --tab --out S_Hebbring_Unr.Guo

#population stratification-PCA analysis
plink --bfile rs1800562 --recode --tab --out rs1800562
plink --file data --hardy
#pairwise ibd estimate
plink --bfile S_Hebbring_Unr.Guo --remove fail-sexcheck-qc.txt --out S_Hebbring_Unr.Guo
plink --bfile S_Hebbring_Unr.Guo  --missing
plink --bfile S_Hebbring_Unr.Guo --indep 50 5 2
plink --bfile S_Hebbring_Unr.Guo --extract plink.prune.in --genome --min 0.185
perl ./run-IBD-QC.pl plink

# confirmation of known family relationships
sort -k 9 plink.genome | awk '{print $1,$2,$3,$4,$7,$8,$9,$10,$11,$12,$13}' | awk '$8>0.985' | grep -v NA | awk -F'[- ]' '{print $1,$1,$7,$7}' | wc -l
# remove 139 duplication samples (Hapmap and Marshfield)
plink --bfile S_Hebbring_Unr.Guo --remove fail-IBD-QC.txt --make-bed --out S_Hebbring_Unr.Guo
plink --bfile S_Hebbring_Unr.Guo --impute-sex --make-bed --out S_Hebbring_Unr.Guo

plink2 --bfile S_Hebbring_Unr.Guo --pca approx  --maf 0.05 --memory 30000 --out phase2.pca

plink2 --bfile merge --keep PCA.include.sample2.txt --pca approx  --maf 0.05 --memory 30000 --out phase3.pca

# Rel data analysis. However, I found Unt data is better to use. 
# fill up missing values for the probes without rs number in the column of RS_dbSNP137
# be careful, in CoreExome_24v1p2 array, there are some probes target to same SNP. therefore, bim/map might have Duplicate ID 'rs115741058'
# you can try to change any 'rs115741058' to 'rs115741058.2'
anno<-read.csv("CoreExome_24v1p2_A1_Anno.csv")
map<-read.table("S_Hebbring_Unr.bim")
RS_dbSNP137<-as.character(anno$RS_dbSNP137)
Name<-as.character(anno$Name)
RS_dbSNP137[which(RS_dbSNP137=="")]<-Name[which(RS_dbSNP137=="")]
anno$RS_dbSNP137=RS_dbSNP137
write.csv(anno,file="CoreExome_24v1p2_A1_Anno.Guo.2018.March.csv")
# replace the illuma ID in the binary map (bim) with RS_dbSNP137 for the publication
# Give an postfix to avoid problem: Duplicate ID 'rs115741058'
newRS_dbSNP137=make.names(anno[match(map[,2],anno$Name),]$RS_dbSNP137,unique=T)
map[,2]=newRS_dbSNP137
write.table(map,file="../S_Hebbring_Unr.Guo.bim",sep="\t",quote=F,col.names=F,row.names=F)
# cp S_Hebbring_Unr.fam ../S_Hebbring_Unr.Guo.fam
# cp S_Hebbring_Unr.bed ../S_Hebbring_Unr.Guo.bed
# pca analysis to phase 2 dataset
# plink2 --bfile S_Hebbring_Unr.Guo --pca approx  --maf 0.05 --memory 30000 --out phase2.pca
plink --bfile S_Hebbring_Unr.Guo --remove fail-sexcheck-qc.txt --impute-sex --make-bed --out S_Hebbring_Unr.Guo
plink2 --bfile S_Hebbring_Unr.Guo --pca approx  --maf 0.05 --memory 30000 --out phase2.pca

# R plot to show the PCA result
setwd("/home/local/MFLDCLIN/guosa/hpc/pmrp/phase2")
eigenvec<-read.table("phase2.pca.eigenvec",head=T)
saminfo<-read.table("S_Hebbring_Release_Sample_Sheet.txt",head=T,sep="\t")
sam<-saminfo[match(as.character(eigenvec$IID),saminfo$Sample_Name),]
pdf("phase2.pca-population.pdf")
Legends<-unique(data.frame(Population=sam$Population,Col=as.numeric(sam$Population)))
plot(eigenvec$PC2~eigenvec$PC1,cex=0.55,col=as.numeric(sam$Population),pch=as.numeric(sam$Population))
legend("topleft",legend=Legends$Population,col=Legends$Col,pch=Legends$Col,cex=0.55)
dev.off()
pdf("phase2.pca-gender.pdf")
Legends<-unique(data.frame(Gender=sam$Gender,Col=as.numeric(sam$Gender)))
plot(eigenvec$PC2~eigenvec$PC1,cex=0.55,col=as.numeric(sam$Gender),pch=as.numeric(sam$Gender))
legend("topleft",legend=Legends$Gender,col=Legends$Col,pch=Legends$Col,cex=0.55)
dev.off()

# Postive control test: rs1800562: represents a SNP that accounts for ~85% of all cases of hemochromatosis
# exm2253593 and exm596 are same to rs115741058
plink --bfile S_Hebbring_Unr.Guo --make-bed --snps rs1800562 --out rs1800562
plink --bfile rs1800562 --recode --tab --out rs1800562
# check homozygotes AA in 8648 individuals
grep 'A A' rs1800562.ped | wc -l    # 24 patients were found with AA homozygotes
# check other Hemochromatosis genes ( rs2280673 in RAB6B;  rs1800730 in HFE and rs235756 in the BMP2)
# what a pity, rs235756 in the BMP2 is not included by current array
# rs1799945 in the HFE gene, also known as H63D (risk genotype GG)
plink --bfile S_Hebbring_Unr.Guo --make-bed --snps rs1800562,rs1799945,rs2280673,rs1800730 --out Hemochromatosis
plink --bfile Hemochromatosis --recode --tab --out Hemochromatosis


# We need combind 1000 Genome and Hapmap 3 dataset (not need)
