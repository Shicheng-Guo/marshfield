### A Gene-Based Recessive Diplotype Exome Scan to identify recessive and compound heterozygosity variants
#### 1. Determination of Putative Functional Variants
Putative functional variants included in the analyses satisfied the quality control criteria as described previously. In addition, markers in the analyses were either GWAS-significant as of June 2015 and/or annotated as missense, nonsense, 3’UTR, 5’UTR or occurring within a splice site region.
#### 2. Haplotype Phasing
In general, gametic phasing is necessary to directly determine compound heterozygous individuals at a particular gene.  Several algorithms are available for inferring phased haplotypes from unphased genotype data using population-based samples, including the localized haplotype-cluster model algorithm implemented in the software Beagle. Each gene in the exome was phased separately using this method within Beagle (default method for our analysis).
#### 3. Essential files
FinalRelease_QC_20140311_Team1_Marshfield.10302018.annovar.hg19_multianno.csv too large (~348M) to upload to github, please send email to obtain.
#### 4. File interpretation
2ALOF_process_sub.R: main functions in this analysis
#### 5. Usage
```
Rscript 2ALOF_main_v5.R
```

