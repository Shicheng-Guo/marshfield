#!/usr/bin/perl -w

# bismark to alignment single and pair-end fastq in same project
# Good habit to creat parameter table for a project
# Contact: Shicheng Guo
# Version 1.3
# Update: Aug/23/2016

use strict;
use Cwd;
my $dir=getcwd;
die USAGE() if scalar(@ARGV<2);

my $sample_group_file=shift @ARGV;
my $submit=shift @ARGV;

open F,"$sample_group_file";
while(<F>){
    chomp;
    next if /^\s+$/;
    my @read = split /\t/;
    my $id=$read[0];
    my ($sample1,undef)=split /.fastq.gz/,$read[0];
    my $project="Marshfield";
    my $analysis="NASH";
    my $job_file_name = $id . ".job";
    my $status_file = $id.".status";
    my $curr_dir = $dir;
    my $ppn=32;
    my $multicore=2;
    my $walltime="480:00:00";
    my $queue="longq"; # hotel,pdafm,condo
	my $bismarkdb="/gpfs/home/guosa/hpc/db/hg19/bismark/";
	
    # chomp(my $phredcheck=`perl /home/shg047/bin/checkphred.pl $read[0]`);
    # my ($phred)=split /\s+/,$phredcheck;
    my $phred=33;
    $phred="--phred$phred";
    
    open(OUT, ">$job_file_name") || die("Error in opening file $job_file_name.\n");   
    print OUT "#!/bin/csh\n";
    print OUT "#PBS -N $job_file_name\n";
    print OUT "#PBS -q $queue\n";  # glean is free
    print OUT "#PBS -l nodes=1:ppn=$ppn\n";
    print OUT "#PBS -l walltime=$walltime\n";
    print OUT "#PBS -o ".$id.".log\n";
    print OUT "#PBS -e ".$id.".err\n";
    print OUT "#PBS -V\n";
    print OUT "#PBS -M shicheng.guo\@gmail.com \n";
    print OUT "#PBS -m abe\n";
    print OUT "#PBS -A Steven Schrodi\n";
    print OUT "cd $curr_dir\n";
    print "$job_file_name\n";
    if(scalar(@read) eq 2){
    my ($sample2,undef)=split /.fastq.gz/,$read[1];
    print OUT "trim_galore --paired --phred$phred --clip_R1 3 --clip_R2 3 --fastqc --illumina $sample1\.fastq.gz $sample2\.fastq.gz --output_dir ../fastq_trim\n";
    print OUT "bismark --bowtie2 $phred-quals --fastq -L 30 -N 1 --multicore $multicore $bismarkdb -1 ../fastq_trim/$sample1\_val_1.fq.gz -2 ../fastq_trim/$sample2\_val_2.fq.gz  -o ../bam";
    }else{
    print OUT "bismark --bowtie2 $phred-quals --fastq -L 30 -N 1 --multicore 6 /home/shg047/db/hg19 ../fastq_trim/$sample1\_trimmed.fq.gz -o ../bam";  
    }
   close(OUT);
   if($submit eq 'submit'){
   system("qsub $job_file_name");
   }
}

sub print_bismark_version{
	
my $bismark_version=bismark_version();	
	
	print<<"VERSION";
          SmartBismark - Smart Bisulfite Mapper and Methylation Caller Assembly Tools.

                       SmartBismark Version: smartbismark_version
                          Bismark Version: bismark_version
                           
        Copyright 2010-15 Shicheng Guo, University of California, San Diego

VERSION
    exit;
}


sub directory_build{
chdir getcwd;
mkdir "../fastq_trim" if ! -e "../fastq_trim" || print  "fastq_trim     Building Succeed!  <Trimed Fastq>     stored here\n";
mkdir "../bam" if ! -e "../bam"               || print  "bam            Building Succeed!    <Bam Files>      stored here\n";
mkdir "../bedgraph" if ! -e "../bedgraph"     || print  "bedgraph       Building Succeed!  <Bedgraph Files>   stored here\n";
mkdir "../sortbam" if ! -e "../sortbam"       || print  "sortbam        Building Succeed!  <SortBam Files>    stored here\n";
mkdir "../methyfreq" if ! -e "../methyfreq"   || print  "methyfreq      Building Succeed!  <MethyFreq Files>  stored here\n";
mkdir "../bedgraph" if ! -e "../bedgraph"     || print  "bedgraph       Building Succeed!  <BedGraph Files>   stored here\n";
mkdir "../bw" if ! -e "../bw"                 || print  "bigwig         Building Succeed!  <BigWig Files>     stored here\n";
mkdir "./tmp/" if ! -e "./tmp/"               || print  "tmp            Building Succeed!  <tmp Files>        stored here\n";
mkdir "./hapinfo/" if ! -e "./hapinfo/"       || print  "hapinfo        Building Succeed!  <hapinfo Files>    stored here\n";
}


sub USAGE{
print "\nUSAGE: $0 SamConfigFile submit\n";
print '
--------------------------------------------------------------------------------------------------------------
This command will trim the Fastq files with trim_galore for single-end and pair-end BS-seq data simultaniously. 

Example:  perl fastq2trimfastq.pl FastqMatchConfig.txt submit

SamConfigFile Format:
HOT243.fq.gz
HOT265.fq.gz
BMT1.read1.fq.gz        BMT1.read2.fq.gz
BMT2.read1.fq.gz        BMT2.read2.fq.gz
submit|notsumbit: indicate qsub job to TSCC or not?
The trimed fastq will be save in ../fastq_trim. 
Previous Script: 
1, Download or Prepare SRA Download Configure  (http://www.ebi.ac.uk/ena/data/view/SRP028600)
2, perl fastqDownload.pl SamConfig.txt 8 submit   (fastq-dump --split-files --gzip)
3, trim_galore --phred33 --fastqc --stringency 3 -q 20 --trim1 --length 20 --gzip --clip_R1 2 --three_prime_clip_R1 2 --illumina SRR299055_1.fastq.gz --output_dir ../fastq_trim
4, bismark_genome_preparation ./     # merge all the fa to one file (mm9.fa or hg19.fa)
--------------------------------------------------------------------------------------------------------------
';
}

