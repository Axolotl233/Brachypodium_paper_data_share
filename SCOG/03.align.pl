use strict;
use warnings;

## created by Yongzhi Yang. 2017/3/20 ##

my $mafft="mafft";
my $pal2nal="/data/00/user/user106/software/pal2nal/pal2nal.v14/pal2nal.pl";

open O, "> $0.sh";
my @in=<align/*/pep>;
for my $in (@in){
    my $in2=$in;
    $in2=~s/pep$/cds/ or die "$in2\n";
    print O "$mafft --auto --quiet $in > $in.best.fas ; $pal2nal $in.best.fas $in2 -output fasta > $in2.best.fas\n";
}

