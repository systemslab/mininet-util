#!/bin/bash

# TODO: rewrite as actual perl script

#echo "segments_sent_out segments_retransmitted percent_retransmitted retransmitted_lost percent_retransmitted_lost packets_switch_out packets_switch_dropped percent_dropped"
echo -e "seg_tx\tretx\t%retex\trelost\t%relost\tpkt_sw\tdropped\t%dropped"

files=$(ls $1/netstat-h[2-9]*.txt $1/netstat-h[2-9]*-after.txt 2> /dev/null)
script=$(cat <<'RETX'
BEGIN {
  my $sent = 0;
  my $retrans = 0;
  my $retrans_lost = 0;
}

/(\d+) segments send out/ && ($sent = $sent + $1);
/(\d+) segments retransmited/ && ($retrans = $retrans + $1);
/TCPLostRetransmit: (\d+)/ && ($retrans_lost = $retrans_lost + $1);

END {
  if($sent == 0) {
    printf("NA\tNA\tNA\tNA\tNA\t");
    exit;
  }

  my $percent_retrans = 100 * $retrans / $sent;
  if($retrans == 0) {
    printf("%d\t%d\t%3.4f\t%d\t%3.4f\t", $sent, 0, 0.0, 0, 0.0);
    exit;
  } else {
    printf("%d\t%d\t", $sent, $retrans);
  }

  if($percent_retrans < 0.0001) {
    print "> 0\t";
  } else {
    printf("%3.4f\t", $percent_retrans);
  }

  my $percent_retrans_lost = 100 * $retrans_lost / $retrans;
  if($retrans_lost == 0) {
    printf("%d\t%3.4f\t", 0, 0.0);
    exit;
  } else {
    printf("%d\t", $retrans_lost);
  }

  if ($retrans_lost > 0 && $percent_retrans_lost < 0.0001) {
    print "> 0\t";
  } else {
    printf("%3.4f\t", $percent_retrans_lost);
  }
}
RETX
)

perl -ne "${script}" $files

script=$(cat <<'DROP'
if (/Sent (\d+) bytes (\d+) pkt \(dropped (\d+)/) {
  if ($3 == 0) {
    printf("%d\t%d\t0.00\n", $2, $3);
  } elsif ($3 > 0 && 100 * $3 / $2 < 0.0001) {
    printf("%d\t%d\t> 0\n", $2, $3);
  } else {
    printf("%d\t%d\t%3.4f\n", $2, $3, 100 * $3 / $2)
  }
}
DROP
)

test -e $1/tc-stats-after.txt && \
grep -A1 "htb 5: dev s1-eth1" $1/tc-stats-after.txt | perl -ne "${script}" || \
echo -e "NA\tNA\tNA

