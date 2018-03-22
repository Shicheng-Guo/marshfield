#!/usr/bin/perl
#This perl can find pvalue<0.05 from adjusted file created by plink

my ($adjust,@files,$file,$dir,$n,$m);
my $dir="/work/colleague/wujunjie/xrcc1/result";
chdir $dir or die "can't come into $dir";
my @files=glob "*.logistic";  

open OUT,"> logistic_filter.txt";
open OUT2,"> pvalue_all_test.txt";
my @pvalue;
while(my $filename=shift @files){
	open FH, $filename;
	while(<FH>){
			if(/CHR/ and ! $m){print OUT "\t$_"};$m++;
			next if /his4|hos6|gen|BONF|TEST|NA|for|allel|sex|treat|smokstatu|hos5|CHR/; 
		    my @line=split /\s+/;
		    push @pvalue,$line[-1];
			if($line[-1] < 0.5e-3){   
				print OUT "$filename\t";
				print OUT "$_";
              	$n++;
}
}
}
my $line2=join("\n",@pvalue);
print OUT2 $line2;
print "there are $n are finded\n"
