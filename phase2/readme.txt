

# copy data from the raw data source
cd ~/hpc/pmrp/phase2
cp /mnt/bigdata/Genetic/Projects/S_Hebbring_2128_Released_Data/SNP_Information/SNP_Annotation/CoreExome_24v1p2_A1_Anno.csv  ./ 

cd ~/hpc/pmrp/phase2
cp /mnt/bigdata/Genetic/Projects/S_Hebbring_2128_Released_Data/PLINK_Files/*Rel.* ./

# fill up missing values for the probes without rs number in the column of RS_dbSNP137
anno<-read.csv("CoreExome_24v1p2_A1_Anno.csv")
map<-read.table("S_Hebbring_Rel.bim")
RS_dbSNP137<-as.character(anno$RS_dbSNP137)
Name<-as.character(anno$Name)
RS_dbSNP137[which(is.na(RS_dbSNP137))]<-Name[which(is.na(RS_dbSNP137))]
anno$RS_dbSNP137=RS_dbSNP137
write.csv(anno,file="CoreExome_24v1p2_A1_Anno.Guo.2018.March.csv")

