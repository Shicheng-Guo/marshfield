

# copy data from the raw data source
cd ~/hpc/pmrp/phase2
cp /mnt/bigdata/Genetic/Projects/S_Hebbring_2128_Released_Data/SNP_Information/SNP_Annotation/CoreExome_24v1p2_A1_Anno.csv  ./ 

cd ~/hpc/pmrp/phase2
cp /mnt/bigdata/Genetic/Projects/S_Hebbring_2128_Released_Data/PLINK_Files/*Rel.* ./

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

# Postive control test: rs1800562: represents a SNP that accounts for ~85% of all cases of hemochromatosis
# exm2253593 and exm596 are same to rs115741058


plink --bfile S_Hebbring_Rel.Guo --make-bed --snps rs1800562 --out rs1800562
plink --bfile rs1800562 --recode --tab --out rs1800562

# check homozygotes AA in 8648 individuals
grep 'A A' rs1800562.ped | wc -l    # 24 patients were found with AA homozygotes

# check other Hemochromatosis genes ( rs2280673 in RAB6B;  rs1800730 in HFE and rs235756 in the BMP2)
# what a pity, rs235756 in the BMP2 is not included by current array
plink --bfile S_Hebbring_Rel.Guo --make-bed --snps rs1800562,rs1799945,rs2280673,rs1800730 --out Hemochromatosis


