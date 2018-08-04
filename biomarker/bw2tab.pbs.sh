# submit the job by chromesome so that we can make the test chrosome by chromesome.

for i in {1..22} X Y
do
for j in `ls *.$i.job`
do
qsub $j
done
done
