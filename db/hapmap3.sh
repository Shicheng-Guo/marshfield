#!/usr/bin/sh
# https://www.broadinstitute.org/medical-and-population-genetics/hapmap-3
# b36= GRCh36 =hg18. hg19 == GRCh37. 
# each population

cd /home/local/MFLDCLIN/guosa/hpc/db/hapmap3/vcf
wget https://www.broadinstitute.org/files/shared/mpg/hapmap3/hapmap3_r1_b36_fwd.qc.poly.tar.bz2
wget https://www.broadinstitute.org/files/shared/mpg/hapmap3/relationships_w_pops_051208.txt
tar xjvf hapmap3_r1_b36_fwd.qc.poly.tar.bz2
tar xjvf relationships_w_pops_051208.txt

# consensus
wget https://www.broadinstitute.org/files/shared/mpg/hapmap3/hapmap3_r1_b36_fwd_consensus.qc.poly.recode.ped.bz2
wget https://www.broadinstitute.org/files/shared/mpg/hapmap3/hapmap3_r1_b36_fwd_consensus.qc.poly.recode.map.bz2
bzip2 -d hapmap3_r1_b36_fwd_consensus.qc.poly.recode.ped.bz2
bzip2 -d hapmap3_r1_b36_fwd_consensus.qc.poly.recode.map.bz2

wget https://www.broadinstitute.org/files/shared/mpg/hapmap3/relationships_w_pops_051208.txt

# Plink
plink --bfile hapmap3_r1_b36_fwd_consensus.qc.poly.recode  --missing
plink --file hapmap3_r1_b36_fwd_consensus.qc.poly.recode --maf 0.01 --make-bed --indep 50 5 2 --out hapmap3_r1_b36_fwd_consensus.qc.poly.recode
plink --bfile hapmap3_r1_b36_fwd_consensus.qc.poly.recode --extract hapmap3_r1_b36_fwd_consensus.qc.poly.recode.prune.in --genome --min 0.185
perl ./run-IBD-QC.pl plink

# merge hapmap 3 with marshfield dataset
# test snps	
SNP=rs1800562
SNP=rs1000007
plink --bfile hapmap3_r1_b37_fwd_consensus.qc.poly.recode --snp rs1000007 --recode --tab --out hapmap3
plink --bfile S_Hebbring_Unr.Guo --snp $SNP --recode --tab --out Marshfield
head Marshfield.ped
head hapmap3.ped
plink --bfile hapmap3_r1_b37_fwd_consensus.qc.poly.recode --snp rs1800562 --recode --tab --out hapmap3
plink --bfile S_Hebbring_Unr.Guo --snp rs1800562 --recode --tab --out Marshfield
head Marshfield.ped
head hapmap3.ped
# flip the fliped SNPS by merge-merge.missnp and then merge to find remainning SNPs still have multi-variants
plink --bfile hapmap3_r1_b37_fwd_consensus.qc.poly.recode --flip merge-merge.missnp --make-bed --out hapmap3_r1_b37_fwd_consensus.qc.poly.recode
plink --bfile S_Hebbring_Unr.Guo --bmerge hapmap3_r1_b37_fwd_consensus.qc.poly.recode --make-bed --out merge
# exclude these 16 multi-SNP
plink --bfile S_Hebbring_Unr.Guo --exclude merge-merge.missnp --make-bed --out S_Hebbring_Unr.Guo
plink --bfile hapmap3_r1_b37_fwd_consensus.qc.poly.recode --exclude merge-merge.missnp --make-bed --out hapmap3_r1_b37_fwd_consensus.qc.poly.recode
# merge again
plink --bfile S_Hebbring_Unr.Guo --bmerge hapmap3_r1_b37_fwd_consensus.qc.poly.recode --make-bed --out merge

	
