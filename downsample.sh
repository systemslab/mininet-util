#!/bin/bash

infile=$1
outfile=$2
percentage=$3

downsample () { 
  infile=$1 
  outfile=$2 
  percentage=$3
 
  cat $infile | perl -e ' 
    my $percentage = $ARGV[0]; 
    my $outfile = $ARGV[1]; 
    open OUT1, ">", "$outfile" or die $!; 
    while (<STDIN>) { 
        if (rand(100) < $percentage) { print OUT1 $_; } 
    } 
    close OUT1 or die $!; 
' $percentage $outfile
}
