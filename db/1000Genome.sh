# Readme. 1000 Genome VCF to Plink
# Download 1000 Genome Genotyping data
# the file name system of X, Y and MT are not same autosome chromosomes, download them separately and vcf2plink.

for i in {1..22} X Y MT
do
echo cd /gpfs/home/guosa/hpc/db/1000Genome >chr$i.pbs
echo wget http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chr$i.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz  >> chr$i.pbs
echo wget http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chr$i.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz.tbi >> chr$i.pbs
done 
wget http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chrX.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.vcf.gz
wget http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chrX.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.vcf.gz.tbi
wget http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chrY.phase3_integrated_v2a.20130502.genotypes.vcf.gz
wget http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chrY.phase3_integrated_v2a.20130502.genotypes.vcf.gz.tbi
wget http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chrMT.phase3_callmom-v0_4.20130502.genotypes.vcf.gz	
wget http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chrMT.phase3_callmom-v0_4.20130502.genotypes.vcf.gz.tbi
## merge chromsome based ped/map to single ped/map system and then to binary form. 

for i in {1..22} X Y MT
do
echo cd /gpfs/home/guosa/hpc/db/1000Genome > chr$i.pbs
echo ulimit -n 3000 >> chr$i.pbs
echo plink --vcf ALL.chr$i.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz --out chr$i >> chr$i.pbs
qsub chr$i.pbs
done 

plink --vcf ALL.chrX.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.vcf.gz --make-bed --out chrX &
plink --vcf ALL.chrY.phase3_integrated_v2a.20130502.genotypes.vcf.gz --make-bed --out chrY &
plink --vcf ALL.chrMT.phase3_callmom-v0_4.20130502.genotypes.vcf.gz --make-bed --out chrMT &

## merge plink binary files (bed,fam,bim)
## This script help you creat allfiles.txt to merge them to the first binary file
for i in {2..22} X Y MT
do
echo chr$i.bed chr$i.bim chr$i.fam >> allfiles.txt
done

plink --bfile chr1 --merge-list allfiles.txt --make-bed --out 1000Genome.phase3

# sometimes, you will get error here, if plink found repeat SNPs. it will error and show you
# which SNPs are not unique and you need remove these non-unique SNPs (recorded in missnp file)
# remove repeat SNPs with different genomic position
for i in {1..22} X Y MT
do
echo cd /gpfs/home/guosa/hpc/db/1000Genome > chr$i.pbs
echo ulimit -n 3000 >> chr$i.pbs
echo plink --bfile chr$i --exclude 1000Genome.phase3-merge.missnp --make-bed --out chr$i >> chr$i.pbs
qsub chr$i.pbs
done 

# now you can run merge command again. 
plink --bfile chr1 --merge-list allfiles.txt --make-bed --out 1000Genome.phase3




# Supplementary:
# Chang told me don't use vcftools --plink, try plink --vcf, plink is better than vcftools
# But I record the vcftools command as the following:
for i in {1..22} X Y MT
do
echo cd /gpfs/home/guosa/hpc/db/1000Genome > chr$i.pbs
echo ulimit -n 3000 >> chr$i.pbs
echo vcftools --gzvcf ALL.chr$i.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz --plink --chr $i --out chr$i >> chr$i.pbs
qsub chr$i.pbs
done 
vcftools --gzvcf ALL.chrX.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.vcf.gz --plink --chr X --out chrX &
vcftools --gzvcf ALL.chrY.phase3_integrated_v2a.20130502.genotypes.vcf.gz --plink --chr Y --out chrY &
vcftools --gzvcf ALL.chrMT.phase3_callmom-v0_4.20130502.genotypes.vcf.gz --plink --chr MT --out chrMT &

