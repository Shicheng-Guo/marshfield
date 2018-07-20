use strict;
use Cwd;
use POSIX;
my $dir = getcwd;
chdir $dir;
open F, "/home/local/MFLDCLIN/guosa/hpc/db/hg19/snp150.hg19.txt";
while(<F>){
chomp;
my $line=$_;
my ($chr,undef)=split/\s+/,$line;
system("echo $line >> $chr\.vcf.bed");
}
