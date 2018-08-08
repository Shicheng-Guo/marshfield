#!/usr/bin/env Rscript
setwd("/gpfs/home/guosa/run/tab")
TtestPValue<-function(data,x1,x2,pair=FALSE){
  data<-data.matrix(data)
  output<-matrix(NA,dim(data)[1],6)   # set output matrix ()
  for(i in 1:dim(data)[1]){
    out<-data.frame()
    if(pair==TRUE){
      Valid<-nrow(na.omit(data.frame(data[i,x1],data[i,x2])))
    }else{
      Valid<-100
    }
    if( sum(!is.na(data[i,x1]))>=3 & sum(!is.na(data[i,x2]))>=3 & Valid>3){ 
      tmp1<-try(t.test((data[i,x1]),(data[i,x2]),paired=F, na.action=na.omit))
      output[i,1]<-format(tmp1$p.value, scientific=TRUE)
      output[i,2]<-round(mean(data[i,x1],na.rm=T)-mean(data[i,x2],na.rm=T),3)
      output[i,3]<-round(mean(data[i,x1],na.rm=T),3)
      output[i,4]<-round(mean(data[i,x2],na.rm=T),3)
      output[i,5]<-round(sd(data[i,x1],na.rm=T),3)
      output[i,6]<-round(sd(data[i,x2],na.rm=T),3)
    }
  }
  rownames(output)<-rownames(data)
  output
}
args = commandArgs(trailingOnly=TRUE)
sam<-read.table("/gpfs/home/guosa/hpc/epimarker/Epimarkersample.txt",head=T,sep="\t")
data=read.table(args[1],head=T,sep="\t",row.names=1,check.names=F)
chr=unlist(strsplit(arg[1],split=".tab.txt"))
filename=unlist(strsplit(colnames(data),split=paste(".",chr,".tab",sep="")))
newsam=sam[match(filename,sam[,1]),]
blood=which(newsam[,4]=="Blood")
solid=which(newsam[,4]=="Solid")
rlt<-TtestPValue(data,blood,solid)
output=paste(args[1],".pvalue.rlt",sep="")
colnames(rlt)=c("Pvalue","delta","M1","M2","SD1","SD2")
write.table(rlt,file=output,sep="\t",quote=F,col.names=T,row.names=F)
