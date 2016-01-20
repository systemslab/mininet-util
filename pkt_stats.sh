#!/bin/bash

# TODO: rewrite as actual perl script

#echo "segments_sent_out segments_retransmitted percent_retransmitted fast_retransmits percent_fast_retransmits lost_retransmits percent_lost_retransmits packets_queued_switch packets_dropped_switch percent_dropped"
echo -e "segTX\treTX\t%reTX\tfasReTX\t%fasReTX\tlReTX\t%lReTX\tpktsQd\tdrop\t%drop"

files=$(ls $1/netstat-h[2-9]*-after.txt 2> /dev/null)
script=$(cat <<'RETX'
BEGIN {
  my $sent = 0;
  my $retrans = 0;
  my $fastretrans = 0;
  my $retrans_lost = 0;
}

/(\d+) segments send out/ && ($sent = $sent + $1);
/(\d+) segments retransmited/ && ($retrans = $retrans + $1);
/(\d+) fast retransmits/ && ($fastretrans = $fastretrans + $1);
/TCPLostRetransmit: (\d+)/ && ($retrans_lost = $retrans_lost + $1);

END {
  if($sent == 0) {
    printf("NA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\n");
    exit;
  }

  if($retrans == 0) {
    printf("%d\t%d\t%3.4f\t%d\t%3.4f\t%d\t%3.4f\t", $sent, 0, 0.0, 0, 0.0, 0, 0.0);
    exit;
  } else {
    my $percent_retrans = 100 * $retrans / $sent;
    printf("%d\t%d\t%3.4f\t", $sent, $retrans, $percent_retrans);
  }

  if($fastretrans == 0) {
    printf("%d\t%3.4f\t", 0, 0.0);
  } else {
    my $percent_fastretrans = 100 * $fastretrans / $retrans;
    printf("%d\t%3.4f\t", $fastretrans, $percent_fastretrans);
  }

  if($retrans_lost == 0) {
    printf("%d\t%3.4f\t", 0, 0.0);
  } else {
    my $percent_retrans_lost = 100 * $retrans_lost / $retrans;
    printf("%d\t%3.4f\t", $retrans_lost, $percent_retrans_lost);
  }
}
RETX
)

perl -ne "${script}" $files

#  Sent 2394923528 bytes 1581936 pkt (dropped 0, overlimits 255627 requeues 0) 
script=$(cat <<'DROP'
if (/Sent (\d+) bytes (\d+) pkt \(dropped (\d+)/) {
  printf("%d\t%d\t%3.4f\n", $2, $3, 100 * $3 / $2)
} else {
  printf("NA\tNA\tNA\n")
}
DROP
)

test -e $1/tc-stats-after.txt && \
grep -A1 "htb 5: dev s1-eth1" $1/tc-stats-after.txt | tail -1 | perl -ne "${script}"

