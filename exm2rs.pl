#!/usr/bin/perl

# transfer exm id to rs number id based on genomic coordination.

use strict;
use Cwd;
my $dir = getcwd;
chdir $dir;

my ($bim)=shift @ARGV;
my $allsnp="/home/guosa/hpc/db/hg19/allsnp150.hg19";

open F1,"$allsnp" || die "cannot open $allsanp\n";
open F2,"$bim" || die "cannot open $bim\n";
open OUT,">$bim\.bim";
my %bim;
my %allsnp;

#open and read all snps from 1000 genome database.
my $input;
while(<F1>){
        chomp;
        my($chr,undef,$pos,$rs,undef)=split/\s+/;
        $allsnp{"$chr:$pos"}=$rs;
        $input++;
}
print "$input++ SNP file reading completed.....\n";

#open bim files and read probes of immumina exom array
my $sum;
while(<F2>){
        chomp;
        my $line=$_;
        my($chr,$exmid,undef,$end,$ref,$alt)=split/\s+/,$line;
        my $loc="chr$chr:$end";
        if ($allsnp{$end}){
        print OUT "$chr\t$allsnp{$loc}\t0\t$end\t$ref\t$alt\n";
        $sum++;
        }else{
        print OUT "$line\n";
        }
}
print "change the exm id to rs number completed...\n";

print "$sum exm id were changed to rs id....\n";
