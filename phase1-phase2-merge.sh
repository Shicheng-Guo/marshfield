cd /home/local/MFLDCLIN/guosa/hpc/pmrp/merge
# make the first time merge to find out allele need to be filped. 
plink --bfile FinalRelease_QC_20140311_Team1_Marshfield --bmerge S_Hebbring_Unr  --out PMRP-Phase1-phase2-Full
# then filp anyone dataset
plink --bfile FinalRelease_QC_20140311_Team1_Marshfield --flip PMRP-Phase1-phase2-Full.missnp --make-bed --out 
# then filp anyone dataset and then merge again. 
plink --bfile FinalRelease_QC_20140311_Team1_Marshfield_Flip --bmerge S_Hebbring_Unr --out PMRP-Phase1-phase2-Full
# This the remaining non-merged alleles should be indels. run indel2indel.pl to change phase 2 indel mode to phase I. 
perl indel2indel.pl > S_Hebbring_Unr.bim.bim
mv S_Hebbring_Unr.bim.bim S_Hebbring_Unr.bim
# merge again for the last time 
plink --bfile FinalRelease_QC_20140311_Team1_Marshfield --bmerge S_Hebbring_Unr  --out PMRP-Phase1-phase2-Full
# Now you get the merge dataset
