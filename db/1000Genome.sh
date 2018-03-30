# Readme. 1000 Genome VCF to Plink
# Download 1000 Genome Genotyping data
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

for i in {1..22} X Y MT
do
echo cd /gpfs/home/guosa/hpc/db/1000Genome > chr$i.pbs
echo ulimit -n 3000 >> chr$i.pbs
echo vcftools --gzvcf ALL.chr$i.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz --plink --chr $i --out chr$i >> chr$i.pbs
qsub chr$i.pbs
done 

echo vcftools --gzvcf ALL.chrX.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.vcf.gz --plink --chr X --out chrX
echo vcftools --gzvcf ALL.chrY.phase3_integrated_v2a.20130502.genotypes.vcf.gz --plink --chr $i --out chrY 
echo vcftools --gzvcf ALL.chr$i.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz --plink --chr MT --out chrMT
