use strict;
use Cwd;
use POSIX;
my $dir = getcwd;

my %cpgsnp;
open F1,"/gpfs/home/guosa/hpc/db/hg19/plan2/hg19.allCpGSNP150.bed";
while(<F1>){
	chomp;
	my($chr,$start,$end,$rs)=split/\s+/;
	$cpgsnp{$rs}=$_;
}
close F1;

open F2,"/gpfs/home/guosa/hpc/db/hg19/hg19.commonsnp150";
while(<F2>){
	my (undef,$chr,$start,$end,$rs,undef)=split/\t/;
	if($cpgsnp{$rs}){
		print "$cpgsnp{$rs}\n"; 
	}
}
close F2;

