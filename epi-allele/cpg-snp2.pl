use strict;
use Cwd;
use POSIX;
my $dir = getcwd;
chdir $dir;

my $chr=shift @ARGV;

my %iupac={
'A/G' => 'R',
'C/T' => 'Y',
'A/C' => 'M',
'G/T' => 'K',
'C/G' => 'S',
'A/T' => 'W',
'A/C/T' => 'H',
'C/G/T' => 'B',
'A/C/G' => 'V',
'A/G/T' => 'D',
'A/C/G/T' => 'N',
};

sub match_all_positions {
    my ($regex, $string) = @_;
    my @ret;
    while ($string =~ /$regex/g) {
        push @ret, [ $-[0], $+[0] ];
    }
    return @ret
}

open F1,"$chr.fa";
my $genome;
while(<F1>){
    chomp;
    next if />/;
    $_=~s/N/X/g;
    $genome .=$_;
}
my @seq=split //,$genome;

close F1;
open F2,"$chr.vcf.bed" || die "cannot open test.txt";
open OUT,"$chr.mask.fa";
while(<F2>){
    chomp;
    my $line=$_;
    my ($chr,$start,$end,$rs,$strand,$ref,$alt)=split/\s+/,$line;
    $seq[$end]=$iupac{$alt};
}
close F2;
close OUT;

my $line=0;
foreach my $seq(@seq){
	$line++;
	print "$seq";
	print "\n" if $line % 100 ==0;
}

my $data=join "",@seq;

my @cpgsnp;
for my $i(qw /C Y M S H B V N/){
	for my $j(qw /G R K S B V D N/){
		push @cpgsnp,"$i$j";
	}
	    @cpgsnp=@cpgsnp[1..$#cpgsnp];
}

my $regex=join "|",@cpgsnp;
open OUT2,">$chr.hg19_cpgsnp.bed";
my @pos=&match_all_positions($regex,$genome);
foreach my $pos(@pos){
	my $opt=join "\t",@$pos;
	print OUT2 "$chr\t$opt\n";
}
close OUT2;



