#!/usr/bin/perl

use strict;
use warnings;
use Bio::SeqIO;

 my @p_file = glob("./dataset/*.pep.clean.fa");
 my @c_file = glob("./dataset/*.cds.clean.fa");

`mkdir fix.dataset` if ! -e "./fix.dataset";

for my $file(@c_file){
    chomp $file;
    $file =~ /.*\/(.*)\.cds/;
    my $name = $1;
    #open O, "> ./fix.dataset/$name.pep.fa";
    open O, "> ./fix.dataset/$name.cds.fa";
    my $in=Bio::SeqIO->new(-file=>$file,-format=>'fasta');
    while(my $s=$in->next_seq){
	my $id=$s->id;
	my $seq=$s->seq;
	print O ">$name|$id\n";
	print O "$seq\n";
    }
    close O;
}
for my $file(@p_file){
    chomp $file;
    $file =~ /.*\/(.*)\.pep/;
    my $name = $1;
    open O, "> ./fix.dataset/$name.pep.fa";
    #open O, "> ./fix.dataset/$name.cds.fa";
    my $in=Bio::SeqIO->new(-file=>$file,-format=>'fasta');
    while(my $s=$in->next_seq){
	my $id=$s->id;
	my $seq=$s->seq;
	print O ">$name|$id\n";
	print O "$seq\n";
    }
    close O;
}
