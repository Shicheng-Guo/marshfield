
# run plink to get IBD and plink.genome, with PI_HAT>0.9 to select duplication
data<-read.table("plink.genome",head=T)
dup<-subset(data,PI_HAT>0.9)
rlt<-c()
Rlt<-c()
s1<-data.frame(FID=dup[,1],IID=dup[,2])
s2<-data.frame(FID=dup[,3],IID=dup[,4])
for(i in 1:138){
  rlt<-rbind(s1[i,],s2[i,])
  Rlt<-rbind(Rlt,rlt)
}
write.table(Rlt,file="duplicate.276.txt",sep="\t",quote=F,col.names = F,row.names=F)
Rlt<-read.table("duplicate.276.txt",head=F)
sam<-read.table("duplicate.tfam",head=F)
gdata<-read.table("duplicate.tped")
rlt<-c()
order=unlist(lapply(Rlt[,1],function(x) match(x,sam[,1])))
for(i in 1:((length(order)/2)-1)){
  x1<-gdata[,c(2*order[2*i-1]-1+4,2*order[2*i-1]+4)]
  x2<-gdata[,c(2*order[2*i]-1+4,2*order[2*i]+4)]
  rlt<-c(rlt,sum(!x1==x2)/(2*nrow(gdata)))
}
labels=sam[order[2*which.max(rlt)],]
incon<- -10*log(rlt,10)
pdf("Figure.inconsistency-based-on-duplicate-samples.pdf")
plot(sort(incon),pch=16,ylab="-10xlog(inconsistency,10)",xlab="sorted samples id by inconsistency ratio")
text(x=50,y=20,labels="9280653-1-0238038895 and 6373236-1-0238095908")
dev.off()



# I found this problem.  If we check the consistency between the duplication samples, the average inconsistency will be median 0.02% (SD=0.16%, max=1.5% based on 138 duplicates I identified).
# For some specific sample pairs (see bottom, and the bottom sample in the figure), high allele inconsistency were found 16763 (1.5%) alleles might have problem.  But for others only/less than 0.5%  inconsistency can be found. 
# So I think these inconsistency is just derived from random errors. 
