#!/bin/bash

# --- shell script to run one phenotype for one block --- #

# Download the chromosome block:

#wget http://proxy.chtc.wisc.edu/SQUID/nu_haroldye/GP_imputation/chr$1/CHR$1_combined_p$2.recode.vcf.gz ## genotype file, large

## change attribute rvtest to executable
chmod a+x rvtest

## define computation parameters
PHEN_NAME="disease"
COV_NAME="sex,erh,genopl"  ## "sex,age,erh"
#COV_NAME="age,sex,erh,genopl" ## add age per Scott's request for this GWAS
#STAT_TEST="score"
#STAT_TEST="wald"
STAT_TEST="firth"

VCFIN="CHR$1_combined_p$2.recode.vcf.gz"
PEDIN="phe$3.in"
ASSCOUT="CHR$1_combined_p$2_EX_ALL_DX$3"

## with dosage
./rvtest --inVcf $VCFIN --pheno $PEDIN --dosage DS --covar $PEDIN --pheno-name $PHEN_NAME --covar-name $COV_NAME --out $ASSCOUT --single $STAT_TEST

## add error indicator

rvtestexit=$?

if [ $rvtestexit -ne 0 ]; then
  exit $rvtestexit;
fi

## results looks like CHR22_combined_p0_EX_ALL.single.RVTEST.SingleScore.assoc

#tar -cvf $ASSCOUT'.SingleScore.assoc.tar.gz' $ASSCOUT'.SingleScore.assoc' --remove-files ## remove the original file *.SingleScore.assoc

#gzip $ASSCOUT'.SingleScore.assoc'
#gzip $ASSCOUT'.SingleWald.assoc'

gzip $ASSCOUT'.SingleFirth.assoc'

#rm $ASSOOUT'.SingleScore.assoc'
rm $VCFIN
rm $VCFIN'.tbi'
