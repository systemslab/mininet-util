#!/bin/bash

# TODO: rewrite as actual perl script

#echo "segments_sent_out segments_retransmitted percent_retransmitted retransmitted_lost percent_retransmitted_lost packets_switch_out packets_switch_dropped percent_dropped"
echo -e "seg_tx\tretx\t%retex\trelost\t%relost\tpkt_sw\tdropped\t%dropped"

files=$(ls $1/netstat-h[2-9]*.txt $1/netstat-h[2-9]*-after.txt 2> /dev/null)
perl -ne 'BEGIN {my $sent = 0; my $retrans = 0; my $retrans_lost = 0;} /(\d+) segments send out/ && ($sent = $sent + $1) || /(\d+) segments retransmited/ && ($retrans = $retrans + $1) || /TCPLostRetransmit: (\d+)/ && ($retrans_lost = $retrans_lost + $1); END { my $percent_retrans = 100 * $retrans / $sent; printf("%d\t%d\t", $sent, $retrans); if ($retrans > 0 && $percent_retrans < 0.01) { print "0.00+\t" } else { printf("%3.2f\t", $percent_retrans); }; my $percent_retrans_lost = 100 * $retrans_lost / $retrans; printf("%d\t", $retrans_lost); if ($retrans_lost > 0 && $percent_retrans_lost < 0.01) { print "0.00+\t" } else { printf("%3.2f\t", $percent_retrans_lost); } }' $files

test -e $1/tc-stats-after.txt && \
grep -A1 "htb 5: dev s1-eth1" $1/tc-stats-after.txt | perl -ne 'if (/Sent (\d+) bytes (\d+) pkt \(dropped (\d+)/) { if ($3 == 0) { printf("%d\t%d\t0.00\n", $2, $3); } elsif ($3 > 0 && 100 * $3 / $2 < 0.01) { printf("%d\t%d\t0.00+\n", $2, $3); } else { printf("%d\t%d\t%3.2f\n", $2, $3, 100 * $3 / $2) } }' || \
echo -e "?\t?\t?"

