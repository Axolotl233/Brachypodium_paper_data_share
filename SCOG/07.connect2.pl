use strict;
use warnings;
use Bio::SeqIO;

my %seq;
my %dir;
my @in;
my @sp=qw/Bd11 Bd21 BhDABR113 BhDBd26 BhDEC BhSABR113 BhSBd26 BhSEC BstaABR114 BstaEC Osat/;
#my @in1=<align/*/cds.best.fas.gt80>;
#my @in2=<align/*/pep.best.fas.gt80>;
#my @in3=<align/*/cds.best.fas.gt80.codon12.fa>;
#my @in4=<align/*/cds.best.fas.gt80.codon3.fa>;
open (F,"06.gene.tree.pl.iqtree.sh")||die"$!";
while (<F>) {
    chomp;
    my @a=split(/\s+/,$_);
    $a[1]=~s/;//;
    $dir{$a[1]}++;
}
close F;
for my $dir (sort keys %dir){
    print $dir."\r";
    push @in,"$dir/cds.best.fas";
    #push @in,"$dir/pep.best.fas.gt80";
    #push @in,"$dir/cds.best.fas.gt80.codon12.fa";
    #push @in,"$dir/cds.best.fas.gt80.codon3.fa";
}
for my $in (@in){
    $in=~/\/(\w+\.best.fas)$/ or die "$in\n";
    my $type=$1;
    my $len=0;
    my %flt;
    my $fa=Bio::SeqIO->new(-file=>"$in",-format=>"fasta");
    while (my $seq=$fa->next_seq) {
        my $id=$seq->id;
        my $seq=$seq->seq;
        $len=length($seq);
        $flt{$id} = $seq;
    }
    
    for my $k (@sp){
        $flt{$k}="-" x $len  if (! exists $flt{$k});
        $seq{$type}{$k} .= $flt{$k};
    }
}

`mkdir concatenation` if (! -e "concatenation");
for my $k (sort keys %seq){
    open (O,">concatenation/$k");
    for my $k1 (sort keys %{$seq{$k}}){
        print O ">$k1\n$seq{$k}{$k1}\n";
    }
    close O;
}
