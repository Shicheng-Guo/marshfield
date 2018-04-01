library("Haplin")
ggd.qqplot = function(pvector, main=NULL, ...) {
  o = -log10(sort(pvector,decreasing=F))
  e = -log10( 1:length(o)/length(o) )
  plot(e,o,pch=19,cex=1, main=main, ...,
       xlab=expression(Expected~~-log[10](italic(p))),
       ylab=expression(Observed~~-log[10](italic(p))),
       xlim=c(0,max(e)), ylim=c(0,max(o)))
  lines(e,e,col="red")
}

set.seed(42)

setwd("C:\\Users\\guosa\\Downloads")
file=list.files(pattern="*.mperm")
for(i in 1:length(file)){
print(c(i,file[i]))
data<-read.table(file[i],head=T)
png(paste(i,"png",sep="."))
par(mfrow=c(2,2))
pQQ(na.omit(data$EMP1), conf = 0.95, mark = F,main="EMP1") 
pQQ(na.omit(data$EMP2), conf = 0.95, mark = F,main="EMP2") 
dev.off()
}

file=list.files(pattern="*.linear")
for(i in 1:length(file)){
  data<-read.table(file[i],head=T)
  png(paste(i,"png",sep="."))
  pQQ(na.omit(data[,ncol(data)]), conf = 0.95, mark = F,main="Genetic without age adjust") 
  dev.off()
  print(i)
}
