




## I check the phase I data systemically with rs1800562 as the examples.
## check permutaitontest and the qqplot for permutaiton with rs1800562 as the examples.
cd /home/local/MFLDCLIN/guosa/hpc/hemochromatosis/haplotype
# now we know we need select sel not sel2 since rs1800562 is not in sel2
wc -l exomechip_SNV_PASS_BEAGLE_chr8_phased_sel2.map  # rs1800562 was not listed in sel2
wc -l exomechip_SNV_PASS_BEAGLE_chr8_phased_sel.map # rs1800562 was listed in sel2
mkdir ../plink
cp *sel.* ../plink/
cp two_alof_all_combed_v4.csv ../plink
# save this csv to phen so that we can analyze it with plink
plink --file exomechip_SNV_PASS_BEAGLE_chr6_phased_sel --make-bed --out exomechip_SNV_PASS_BEAGLE_chr6_phased_sel

# 12793 variants and 10124 people pass filters and QC.
phen1<-read.table("two_alof_all_combed_v4.phen",head=T)
phen2<-read.table("exomechip_SNV_PASS_BEAGLE_chr6_phased_sel.fam")
match(phen1[,2],phen2[,1]) 
# I found the order is totally same, don't worry. 
plink --bfile exomechip_SNV_PASS_BEAGLE_chr6_phased_sel --ci 0.95 --logistic --pheno two_alof_all_combed_v4.phen --pheno-name PheTyp7_Iron_C1  --allow-no-sex --out PheTyp7_Iron_C1
plink --bfile exomechip_SNV_PASS_BEAGLE_chr6_phased_sel --ci 0.95 --logistic --pheno two_alof_all_combed_v4.phen --pheno-name PheTyp7_Iron_C2  --allow-no-sex --out PheTyp7_Iron_C2