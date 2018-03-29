# IDn plink 23: X, 24: Y, 25: X+Y, 26:M 
# plink --bfile S_Hebbring_Unr.Guo --maf 0.02 --chr 23 --allow-no-sex --noweb --recode --tab --out chrX
# plink --bfile S_Hebbring_Unr.Guo --maf 0.02 --chr 24 --allow-no-sex --noweb --recode --tab --out chrY
system("plink --bfile S_Hebbring_Unr.Guo --maf 0.02 --chr 23 --allow-no-sex --noweb --recode --tab --out chrX")
system("plink --bfile S_Hebbring_Unr.Guo --maf 0.02 --chr 24 --allow-no-sex --noweb --recode --tab --out chrY")
chrx<-read.table("chrX.ped",stringsAsFactors=F,colClasses = c("character"))
chrx<-chrx[,-which(apply(chrx,2,function(x) sum(x==0))>7000)]
chry<-read.table("chrY.ped",stringsAsFactors=F,colClasses = c("character"))
chry<-chry[,-which(apply(chry,2,function(x) sum(x==0))>7000)]
GenderFScore<-read.table("plink.sexcheck",head=T)
saminfo<-read.table("S_Hebbring_Release_Sample_Sheet.txt",head=T,sep="\t")
# chrx het
Tmp<-c()
for(i in 1:nrow(chrx)){
x<-as.character(unlist(chrx[i,seq(7,ncol(chrx),by=2)]))
y<-as.character(unlist(chrx[i,seq(8,ncol(chrx),by=2)]))
Tmp<-c(Tmp,sum(x==y))
print(i)
}
chrXHetRatio=1-Tmp/((ncol(chrx)-6)/2)
Tmp<-unlist(apply(chry[,7:ncol(chry)],1,function(x) sum(x=="0")))
chrYcallrate=1-(Tmp/(ncol(chry)-6))
pedigreeGender=saminfo[match(chrx[,1],saminfo$Sample_Name),]$Gender
Fscore<-GenderFScore[match(chrx[,1],GenderFScore$IID),]$F
rlt<-data.frame(IID=chrx[,1],chrXHetRatio,chrYcallrate,pedigreeGender)

sam<-saminfo[match(as.character(rlt$IID),saminfo$Sample_Name),]
Rlt<-data.frame(rlt,sam$Gender,sam$Population)
write.table(Rlt,file="gender.prediction.txt",sep="\t",quote=F)
