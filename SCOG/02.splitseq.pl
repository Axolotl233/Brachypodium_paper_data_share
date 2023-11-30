use strict;
use warnings;
use Bio::SeqIO;

my %seq;
for my $in (<fix.dataset/*fa>){
    $in=~/(pep|cds).fa$/ or die "$in";
    my $type=$1;
    my $fa=Bio::SeqIO->new(-format=>"fasta",-file=>"$in");
    while (my $seq=$fa->next_seq) {
        my $id=$seq->id;
        my $seq=$seq->seq;
        $id=~s/\:/_/g;
        $seq{$type}{$id}=$seq;
    }
}
`mkdir align` if (! -e "align");
open (F,"AllClusters.txt.SCG.list")||die"$!";
while (<F>) {
    chomp;
    my @a=split(/\s+/,$_);
    next if /^#/;
    my @b=split(/,/,$a[3]);
    `mkdir align/$a[0]` if (! -e "align/$a[0]");
    for my $k ("cds","pep"){
        open (O,">align/$a[0]/$k");
        for $b (@b){
            $b=~s/\:/_/g;
            $b=~/^(\w+)\|/;
            my $sp=$1;
            die "$k\t$b\n" if ! exists $seq{$k}{$b};
            print O ">$sp\n$seq{$k}{$b}\n";
        }
        close O;
    }
}
