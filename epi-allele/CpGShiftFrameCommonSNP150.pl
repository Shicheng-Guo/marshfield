use strict;
use Cwd;
use POSIX;
my $dir = getcwd;

my %cpgsnp;
open F1,"/gpfs/home/guosa/hpc/db/hg19/plan2/commonCpGSNP/hg19.commonCpGSNP.bed.sort";
while(<F1>){
        chomp;
        my($chr,$start,$end,$rs)=split/\s+/;
        $cpgsnp{$rs}++;
}
close F1;

foreach my $rs(sort keys %cpgsnp){
        print "$rs\t$cpgsnp{$rs}\n" if $cpgsnp{$rs}>1;
}

