#!/usr/bin/env Rscript
# summary.R
# Rscript --vanilla summary.R allCpG-SNP.hg19.G1000.bed.sort.bed.summary
# Rscript --vanilla summary.R allCpG-SNP.hg19.G500.bed.sort.bed.summary
# Rscript --vanilla summary.R allCpG-SNP.hg19.G250.bed.sort.bed.summary
args = commandArgs(trailingOnly=TRUE)
data<-read.table(args)
filename=paste(args,".pdf",sep="")
pdf(filename)
par(mfrow=c(2,2))
hist(data[which(data[,4]<20000),4],main="CpG-SNP Cluster Average Length",xlab="Length")
hist(data[which(data[,5]<100),5],main="Number of CpG-SNPs",xlab="CpG-SNP Number")
hist(data[which(data[,4]<400),6],main="Average Gap between CpG-SNPs",xlab="Average Distance")
hist(data[,5]/data[,4],main="Density of CpG-SNPs within cluster",xlab="Density")
dev.off()







