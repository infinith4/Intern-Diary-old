#!/usr/bin/perl -I./lib
#use v5.14
use strict;
use warnings;

use Text::CSV_XS; 
my $file ="partner.csv";
my $csv = Text::CSV_XS->new({binary => 1, eol => $/});
open my $fh, "<:utf8", $file or die "$file: $!"; #">
while (my $row = $csv->getline($fh)) {
    my @fields = @$row;
    # なにか処理をする
    print "@$row\n";
    
}
