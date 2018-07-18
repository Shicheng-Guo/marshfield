use strict;
use Cwd;
my $dir = getcwd;
chdir $dir;

open F, "/home/local/MFLDCLIN/guosa/hpc/db/hg19/GWAS-Catlog.txt";
while(<F>){
        chomp;
        s/\s+//g;
        next if /chr|UMOD/;
        next if /-/;
        next if /\*|\:/;
        if(/^rs/){
        my @line=split/;|x/;
        my $put=join "\n",@line;
        print "$put\n";
}
}
