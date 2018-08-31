infile1 = "/mnt/bigdata/Genetic/Projects/EXOMECHIP_MARSHFIELD/summary_results/FinalRelease_QC_20140311_Team1_Marshfield.vcf.plink.map"
infile2 = "/mnt/bigdata/Genetic/Projects/EXOMECHIP_MARSHFIELD/summary_results/FinalRelease_QC_20140311_Team1_Marshfield.vcf.plink.frq"
infile3 = "/mnt/bigdata/Genetic/Projects/EXOMECHIP_MARSHFIELD/tmp/FinalRelease_QC_20140311_Team1_Marshfield.annovar.hg19_multianno.csv"
map_dat = read.table(infile1,header=FALSE)
frq_dat = read.table(infile2,header=TRUE)
colnames(map_dat) = c("CHR","SNP","GD","BP")
map_dat2 = map_dat[which(map_dat$CHR<=22),]
frq_dat2 = frq_dat[which(frq_dat$CHR<=22),]
MAF0_vec = which(frq_dat2$MAF==0)
MAF0_loc = map_dat2[MAF0_vec,]$BP
## remove MAF0
map_dat3 = map_dat2[-MAF0_vec,]
frq_dat3 = frq_dat2[-MAF0_vec,]
inpath = "/mnt/bigdata/Genetic/Projects/Schrodi_2ALOF/data/"
outfile = paste(inpath,"exomechip_SNP_dbNSFP2.7.in",sep="")
write.table(map_dat3[,c(1,4)],file=outfile,quote=FALSE,row.names=FALSE,col.names=FALSE)
