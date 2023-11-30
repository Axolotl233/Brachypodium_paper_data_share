use strict;
use warnings;
use Bio::SeqIO;

my $iqtree="iqtree";
my %seq;
open (O,">$0.iqtree.sh");
my @in=<align/*/pep.best.fas.gt80>;
for my $in (@in){
    $in=~/^(\S+)\/pep.best.fas.gt80$/ or die "$in";
    my ($outdir,$pepfile,$cdsfile,$cdsfile12,$cdsfile3)=($1,"pep.best.fas.gt80","cds.best.fas.gt80","cds.best.fas.gt80.codon12.fa","cds.best.fas.gt80.codon3.fa");
    my $len0=0;
    my $len;
    my %out;
    my $lastseq="NA";
    my $lenfa=Bio::SeqIO->new(-format=>"fasta",-file=>"$outdir/$cdsfile");
    while (my $obj=$lenfa->next_seq) {
        my $seq=$obj->seq;
        $len=length($seq);
        $lastseq=$seq;
    }
    next if (! $len);
    $len0=$len;
    if ($len0 < 150){
        next;
    }
    #print "$outdir\t$len\t$lastseq\n";
    
    #open (O1,">$outdir/$cdsfile12");
    #open (O2,">$outdir/$cdsfile3");
    #my $cdsfa=Bio::SeqIO->new(-format=>"fasta",-file=>"$outdir/$cdsfile");
    #while (my $obj=$cdsfa->next_seq) {
    #    my $id=$obj->id;
    #    my $seq=$obj->seq;
    #    $len=length($seq);
    #    $out{$id}++ if $id=~/Gbi|Pab/;
    #    my @seq=split(//,$seq);
    #    print O1 ">$id\n";
    #    print O2 ">$id\n";
    #    for (my $i=0;$i<@seq;$i=$i+3){
    #        print O1 $seq[$i],$seq[$i+1];
    #        print O2 $seq[$i+2];
    #    }
    #    print O1 "\n";
    #    print O2 "\n";
    #}
    #close O1;
    #close O2;
    #open (O3,">$outdir/partition.table");
    #print O3 "DNA, p1=1-$len\\3,2-$len\\3\nDNA, p2=3-$len\\3\n";
    #close O3;
    my @out=sort keys %out;
    if ((scalar @out) == 0){
        @out=("Atr");
    }
    my $out=join(",",@out);
    
    #print O "cd $outdir ; /home/share/software/RAxML/standard-RAxML-master/raxmlHPC-PTHREADS -s $cdsfile -n $cdsfile -m GTRGAMMA -f a -x 12345 -N 100 -p 12345 -T 5 -q partition.table -o $out ; cd ../../\n";
    #print O "cd $outdir ; /home/share/software/RAxML/standard-RAxML-master/raxmlHPC-PTHREADS -s $cdsfile12 -n $cdsfile12 -m GTRGAMMA -f a -x 12345 -N 100 -p 12345 -T 5 -o $out ; cd ../../\n";
    #print O "cd $outdir ; /home/share/software/RAxML/standard-RAxML-master/raxmlHPC-PTHREADS -s $cdsfile3 -n $cdsfile3 -m GTRGAMMA -f a -x 12345 -N 100 -p 12345 -T 5 -o $out ; cd ../../\n";
    #print O "cd $outdir ; /home/share/software/RAxML/standard-RAxML-master/raxmlHPC-PTHREADS -s $pepfile -n $pepfile -m PROTCATWAG -f a -x 12345 -N 100 -p 12345 -T 5 -o $out ; cd ../../\n";

    #print O "cd $outdir ; $iqtree -s $pepfile -st AA -pre $pepfile -nt 5 -bb 1000 -m MFP -o $out -quiet -redo ; cd ../.. \n";
    print O "cd $outdir ; $iqtree -s $cdsfile -st DNA -pre $cdsfile -nt 5 -bb 1000 -m MFP -quiet -redo ; cd ../.. \n";
    #print O "cd $outdir ; $iqtree -s $cdsfile12 -st DNA -pre $cdsfile12 -nt 5 -bb 1000 -m MFP -o $out -quiet -redo ; cd ../.. \n";
    #print O "cd $outdir ; $iqtree -s $cdsfile3 -st DNA -pre $cdsfile3 -nt 5 -bb 1000 -m MFP -o $out -quiet -redo ; cd ../.. \n";
}

close O;
