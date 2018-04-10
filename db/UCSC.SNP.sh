#1. allsnp150
awk '{print $2"\t"$3"\t"$4"\t"$5"\t"$7"\t"$8"\t"$10}' allsnp150 > allsnp150.hg19
# 163415361 SNPs

#1. commonsnp150
awk '{print $2"\t"$3"\t"$4"\t"$5"\t"$7"\t"$8"\t"$10}' hg19.commonsnp150 > commonsnp150.hg19
# 14810672 SNPs

