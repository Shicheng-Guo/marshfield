use strict;
use Cwd;
use POSIX;
my $dir = getcwd;

my %cpgsnp;
open F1,"/home/guosa/hpc/db/hg19/plan2/hg19.allCpGSNP150.bed";
while(<F1>){
	chomp;
	my($chr,$start,$end,$rs)=split/\s+/;
	$cpgsnp{$rs}=$_;
}
close F1;

open F2,"/home/guosa/hpc/immnue/immuneGWAS.bed";
while(<F2>){
	chomp
	my (undef,$chr,$start,$end,$rs,undef)=split/\t/;
	if($cpgsnp{$rs}){
    print "$cpgsnp{$rs}\t$_\n";
	}
}
close F2;




