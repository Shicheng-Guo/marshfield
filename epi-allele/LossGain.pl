use strict;
use Cwd;
use POSIX;
my $dir = getcwd;

my %cpgsnp;
open F1,"/gpfs/home/guosa/hpc/db/1000Genome/bim/bim.txt";
while(<F1>){
	chomp;
	my($chr,$rs,$cm,$bp,$minor,$major)=split/\s+/;
	$cpgsnp{$rs}=$mjor;
}
close F1;

my %cpgsnp;
open F2,"/gpfs/home/guosa/hpc/db/hg19/plan2/hg19.commonCpGSNP.bed";
while(<F1>){
	chomp;
	my($chr,$start,$end,$rs)=split/\s+/;
	if($cpgsnp{$rs} eq "C" || $cpgsnp{$rs} eq "G"){
		print "$_\tG";
	}else{
		print "$_\tL";
	} 
}
close F2;

