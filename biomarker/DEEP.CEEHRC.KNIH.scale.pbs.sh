# DEEP and CEEHRC is 0-100 scale
# KNIH is 0-10 scale

cd /gpfs/home/guosa/run
for i in `ls *DEEP*.bigWig *CEEHRC*.bigWig`
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

for i in `ls *KNIH*.bigWig`
do
echo \#PBS -N $i  > $i.job
echo \#PBS -l nodes=1:ppn=1 >> $i.job
echo cd /gpfs/home/guosa/run >> $i.job
echo bigWigToWig $i $i.wig  >> $i.job
echo awk \'{print \$1\"\\t\"\$2\"\\t\"\$3\"\\t\"\$4/10}\' $i.wig \> $i.w >> $i.job
echo wigToBigWig $i.w /gpfs/home/guosa/hpc/db/hg19/hg19.chrom.sizes $i.bw  >> $i.job
echo rm $i >> $i.job
qsub $i.job
done
