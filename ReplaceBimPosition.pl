use strict;
use Cwd;
my $dir = getcwd;
chdir $dir;

my $bim=shift @ARGV;
my $mistake=shift @ARGV;
my $correct=shift @ARGV;

my @mistake;
open F,$mistake;
@mistake=<F>;
close F;

my %db;
open F,$correct;
chomp;
my $line=$_;
my (undef,$rs,undef)=split/\s+/,$line;
$db{$rs}=$line;
close F;

open F1,$bim;
while(<F1>){
	chomp;
	my $line=$_;
	my @line=split/\s+/,$line;
    my $line=$db{$line[1]} if $line[1]~~ @mistake;
    print "$line\n";
}
