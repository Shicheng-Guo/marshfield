# DEEP and KNIH bigwig is 0-100 scale while Blue and Roadmap is 0-1 scale. 
# bigwig to wig and (4th column)/100 and replace with new bigwig 

for i in `ls *DEEP*.bigWig *KNIH*.bigWig `
do
echo \#PBS -N $i  > $i.job
echo \#PBS -l nodes=1:ppn=1 >> $i.job
echo cd /gpfs/home/guosa/run >> $i.job
echo bigWigToWig $i $i.wig  >> $i.job
echo awk \'{print \$1\"\\t\"\$2\"\\t\"\$3\"\\t\"\$4/100}\' $i.wig \> $i.w >> $i.job
echo wigToBigWig $i.w /gpfs/home/guosa/hpc/db/hg19/hg19.chrom.sizes $i.bw  >> $i.job
echo rm $i >> $i.job
qsub $i.job
done
