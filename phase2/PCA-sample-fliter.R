eigenvec<-read.table("phase3.pca.eigenvec",head=T,"\t")
sam<-read.table("Phenotype.marsh.hapmap3.phen",head=T,sep="\t")
sam<-sam[match(eigenvec[,1],sam[,1]),]

pdf("Marshfield.Hapmap3-PC1-PC2-population.pdf")
Legends<-unique(data.frame(Population=sam$Label,Col=as.numeric(sam$Label),Pch=as.numeric(sam$Label)))
plot(eigenvec$PC2~eigenvec$PC1,cex=0.8,col=as.numeric(sam$Label),pch=as.numeric(sam$Label),xlab="PC1 (39.8%)",ylab="PC2 (19.8%)")
legend("topright",legend=Legends$Population,col=Legends$Col,pch=Legends$Pch,cex=0.65,bty="n")
dev.off()

pdf("Marshfield.Hapmap3-PC1-PC3-population.pdf")
Legends<-unique(data.frame(Population=sam$Label,Col=as.numeric(sam$Label),Pch=as.numeric(sam$Label)))
plot(eigenvec$PC3~eigenvec$PC1,cex=0.8,col=as.numeric(sam$Label),pch=as.numeric(sam$Label),xlab="PC1 (39.8%)",ylab="PC3 (7.6%)")
legend("topright",legend=Legends$Population,col=Legends$Col,pch=Legends$Pch,cex=0.65,bty="n")
dev.off()

pdf("Marshfield.Hapmap3-PC3-PC2-population.pdf")
Legends<-unique(data.frame(Population=sam$Label,Col=as.numeric(sam$Label),Pch=as.numeric(sam$Label)))
plot(eigenvec$PC3~eigenvec$PC2,cex=0.8,col=as.numeric(sam$Label),pch=as.numeric(sam$Label),xlab="PC2 (19.8%)",ylab="PC3 (7.6%)")
legend("topright",legend=Legends$Population,col=Legends$Col,pch=Legends$Pch,cex=0.65,bty="n")
dev.off()

newdata<-data.frame(eigenvec,sam)
AFN<-c()
ASN<-c()
for(i in seq(-0.04,0,by=0.0005)){
Table=data.frame(table(subset(newdata,PC1>i)$Label))
AF=Table[match("African-Marshfield",Table[,1]),2]
AS=Table[match("Asian-Marshfield",Table[,1]),2]
AFN<-c(AFN,AF)
ASN<-c(ASN,AS)
}
pdf("Figure.PC-threshold-sample-sensitivity.pdf")
plot(y=AFN,x=seq(-0.04,0,by=0.0005),type = "o",col="black",lwd=3,ylab="Number of non-European",xlab="Threshold of PC1")
lines(ASN~seq(-0.04,0,by=0.0005),type = "o",col="red",lwd=3)
legend("topright",legend = c("Asian","African"),lty = 1,col=c("red","black"),bty="n",lwd = 3)
dev.off()
input<-subset(newdata,PC1> -0.015 & Label=="European-Marshfield")
write.table(input,file="S_Hebbring_Unr.Guo.Schroid.7921.txt",sep="\t",quote=F,row.names=F,col.names=T)
write.table(input[,c(1,2)],file="S_Hebbring_Unr.Guo.Schroid.7921.input",sep="\t",quote=F,row.names=F,col.names=T)

