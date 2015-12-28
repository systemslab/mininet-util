#!/bin/bash

# TODO: rewrite as actual perl script

echo "segments_sent_out segments_retransmitted percent_retransmitted packets_switch_out packets_switch_dropped percent_dropped"

perl -ne 'BEGIN {my $sent = 0; my $retrans = 0;} /(\d+) segments send out/ && ($sent = $sent + $1) || /(\d+) segments retransmited/ && ($retrans = $retrans + $1); END { my $percent_retrans = 100 * $retrans / $sent; printf("%d %d ", $sent, $retrans); if ($retrans > 0 && $percent_retrans < 0.01) { print "0.00+ " } else { printf("%3.2f ", $percent_retrans); } }' $1/netstat-h[2-9]*-after.txt

grep -A1 "htb 5: dev s1-eth1" $1/tc-stats-after.txt | perl -ne '/Sent (\d+) bytes (\d+) pkt \(dropped (\d+)/ && printf("%d %d %3.2f\n", $2, $3, 100 * $3 / $2);'
