inpath = "/mnt/bigdata/Genetic/Human_Genome_Reference/Exome_Consortium/release0.3/"
chr_vec = c(1:22)
for(i in 1:length(chr_vec))
{
  invcf = paste(inpath,"ExAC.r0.3.sites.vep.vcf.chr",chr_vec[i],".vcf",sep="")
  vcf_dat = read.table(invcf,header=FALSE)
  vcf_info = paste(vcf_dat$V8)
}
datin = vcf_info[587]
datin = vcf_info[505]
info_extract <- function(datin,tag)
{
 tmp = datin
 tmp2 = strsplit(tmp,split=";")[[1]]
 tmp3 = tmp2[length(tmp2)]
 tmp4 = strsplit(tmp3,split="[|]")[[1]]
 ## to decide whether CSQ presented on last item
 tmp5 = substr(tmp4[1],1,3)
 if(tmp5==tag)
 {
   tmp6 = tmp4
 } else {
   ## no CSQ item
   tmp6 = ""
 }
 return(tmp6)
}
res = lapply(vcf_info,info_extract,tag="CSQ")
res_len = c()
for(i in 1:length(res))
{ 
  res_len[i] = length(res[[i]])
}
table(res_len)
func_vec = c()
for(i in 1:length(res))
{ 
  pos = grep("Transcript",res[[i]])
  func_vec = c(func_vec,res[[i]][pos+1])
}
 
func_vec_tb = table(func_vec)
sort(func_vec_tb,decreasing=TRUE)[1:10]
pos = which(vcf_dat$V2==29121266)
vcf_dat[pos,]
var_info = res[[pos]]
res[[which(res_len==241)[1]]]
vcf_dat[which(res_len==48)[1],]
vcf_info[which(res_len==48)[1]]
vcf_dat[which(res_len==49)[1],]
vcf_info[which(res_len==49)[1]]
vcf_info[which(res_len==5520)[1]]
