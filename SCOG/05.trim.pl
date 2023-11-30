use strict;
use warnings;

my $tool="/data/00/user/user112/code/script/other_script/fasta_handle/fasta-missing.pl";
my @in1=<align/*/cds.best.fas>;
my @in2=<align/*/pep.best.fas>;

open O, "> $0.sh";
for my $in (@in1,@in2){
    if ($in=~/pep.best.fas/){
        print O "$tool $in 80 1 > $in.gt80\n";
    }else{
        print O "$tool $in 80 3 > $in.gt80\n";
    }
}
close O;
