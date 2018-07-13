use strict;
use Cwd;
my $dir = getcwd;
chdir $dir;

my $bim=shift @ARGV;
open F,$bim;
while(<F>){
        chomp;
        my @line=split /\s+/;
        if($line[1]=~/indel/){
                if($line[4]=~/DEL/){
             $line[4]='D';
             $line[5]='I';
                }elsif($line[5]=~/DEL/){
                 $line[4]='I';
             $line[5]='D';
                }else{
                 if(length($line[4])>length($line[5])){
                 $line[4]='I';
             $line[5]='D';
                 }else{
                 $line[4]='D';
             $line[5]='T';
                 }
                }
        }

                if($line[1]=~/var/){
                if($line[4]=~/DEL/){
             $line[4]='D';
             $line[5]='I';
                }elsif($line[5]=~/DEL/){
                 $line[4]='I';
             $line[5]='D';
                }
                }

                my $output=join("\t",@line);
                print "$output\n";
}
