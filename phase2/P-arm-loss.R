
plink --bfile ../S_Hebbring_Unr.Guo --keep parmloss.txt --chr 23 --allow-no-sex --recode --tab --transpose --out 1176608-1-0238062177

setwd("C:\\Users\\guosa\\Downloads")
data<-read.table("1176608-1-0238062177.tped",head=F)
het<-apply(data,1,function(x) sum(! as.character(x[5])==as.character(x[6])))
plot(het~data$V4,col="red",cex=2,xlab="Chromosome X",ylab="Heterozygote")
