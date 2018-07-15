Scripts to generate PCA plots – GIANT

(These scripts were updated from the files provided by Suthesh)

Use these script on the samples which are left after eyeballing

1.	Extract AIMS SNPs from total file and make new bed file

plink --bfile your_Exome_chip_file --extract ExomeChip_AIMs.txt --make-bed --out your_Exome_chip_file_AIM

2.	Merge files with 1000 genome files

plink --bfile your_Exome_chip_file_AIM --bmerge AIMs.1000G.v2.bed AIMs.1000G.v2.bim AIMs.1000G.v2.fam --make-bed --out Your_1000G_merged_file

**if there is a strand issue, please flip (--flip in Plink) your SNPs based on the file of Your_1000G_merged_file. missnp in step 1, and redo step 2.

3.	Select those variants with geno 0.05 

plink --bfile Your_1000G_merged_file --geno 0.05 --make-bed --out Your_1000G_merged_file_filter

** getting rid of these SNPs that only exist in 1000 Genome data, but not in your data.

4.	Make genome file

plink --bfile Your_1000G_merged_file_filter --genome --out Your_1000G_merged_file_filter_genome 

5.	MDS

plink --bfile Your_1000G_merged_file_filter --read-genome Your_1000G_merged_file_filter_genome.genome --cluster --mds-plot 10 --out Your_1000G_merged_file_filter.mds

6. 	Merge 1000Genomes population with your population labels
 	
The file of AA1000RG3new_1.0.csv [1092 subjects] contains the labels for CEU, YRI, and CHB/JPT, and other populations (below). It also contains a column GROUPS which is numeric.  You can add the relevant information about your population at the bottom of this file, such as FID, Code, Groups [==8 for your population] and rename it as a new file: New1000RG3plus.cvs. You can achieve this step in excel. This group column is needed for the color coding in R at the next step. You can find more information on the population labelling for all 1000 genome subjects (AIMs.1000G.v2.fam) on the 1000 genome websites.

ASW [AFR] (61) - African Ancestry in Southwest US
CEU [EUR] (85) - Utah residents (CEPH) with Northern and Western European ancestry
CHB [ASN] (97) - Han Chinese in Beijing, China
CHS [ASN] (100) - Han Chinese South
CLM [AMR] (60) - Colombian in Medellin, Colombia
FIN [EUR] (93) - Finnish from Finland
GBR [EUR] (89) - British from England and Scotland
IBS [EUR] (14) - Iberian populations in Spain
JPT [ASN] (89) - Japanese in Toyko, Japan
LWK [AFR] (97) - Luhya in Webuye, Kenya
MXL [AMR] (66) - Mexican Ancestry in Los Angeles, CA
PUR [AMR] (55) - Puerto Rican in Puerto Rico
TSI [EUR] (98) - Toscani in Italia
YRI [AFR] (88) - Yoruba in Ibadan, Nigeria

7.	Merge your_1000G_merged_file_filter.mds with your New1000RG3plus.txt file

R:
your_1000G_merged_file_filter <- read.table (“your_1000G_merged_file_filter.mds”, header=T)
New1000RG3plus <-read.csv("New1000RG3plus.csv", header=T)
SCAT1 <- merge (your_1000G_merged_file_filter, New1000RG3plus, by = "FID", all=TRUE)	
8.	Make cluster plots in R
pdf(“HA_1000G.pdf”)
plot (SCAT1$C1, SCAT1$C2, main= "AIMs from ExomeChip", xlab="MDS1", ylab="MDS2", col=c ("red", "blue", "green", "yellow", "cyan",  "coral",  "brown", "black") [SCAT1$Groups])
dev.off ()

You population is labled as black [8] based on the group codeing.

By eyeballing exclude cases which do not fit within your cohort ancestory.





