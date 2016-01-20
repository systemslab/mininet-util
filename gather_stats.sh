#!/bin/bash

datadirs=$*
firstdir=$(echo ${datadirs} | cut -f1 -d" ")
techs=$(ls -1 ${firstdir}/iperf/)

outdir=statistics/bytech
mkdir -p $outdir/indices
mkdir -p $outdir/retrans

for tech in ${techs}; do
  echo -e "JFI\tGoodput\tLatency" > $outdir/indices/$tech

  echo -e "segTX\treTX\tpercent_reTX\tfasReTX\tpercent_fasReTX\tlReTX\tpercent_lReTX\tpktsQd\tdrop\tpercent_drop" > $outdir/retrans/$tech

  techesc=$(echo $tech | perl -pe 's/\+/\\\+/g')
  for datadir in ${datadirs}; do
    bwstats=${datadir}/bw_stats.txt
    latencystats=${datadir}/latency_index.txt
    pktstats=${datadir}/pkt_stats.txt

    perl -ne "/${techesc}: JFI (\d+\.\d+)/ && print \"\$1\t\"; /${techesc}: fraction of ideal aggregate bandwidth (\d+\.\d+)/ && print \"\$1\t\";" $bwstats >> $outdir/indices/$tech
    # what am I doing wrong?
    #perl -ne "/${techesc}\s+(\d+\.\d+)/ && print \"\$1\" && exit;" $latencystats >> $outdir/indices/$tech
    grep  -m1 $tech $latencystats | cut -f2 -d" " >> $outdir/indices/$tech

    grep "${tech}-" $pktstats | perl -pe "s/${techesc}-//; s/> 0/0.0000/;" >> $outdir/retrans/$tech
  done
done

outdir=statistics/bystat
rm -rf $outdir
mkdir -p $outdir

jfi=$outdir/jfi.txt
goodput=$outdir/goodput.txt
latency=$outdir/latency.txt
percent_reTX=$outdir/percent_reTX.txt
percent_fasReTX=$outdir/percent_fasReTX.txt
percent_lReTX=$outdir/percent_lReTX.txt
percent_drop=$outdir/percent_drop.txt

for tech in ${techs}; do
  echo -ne "${tech}\t" >> $jfi
done
echo >> $jfi

cp $jfi $goodput
cp $jfi $latency
cp $jfi $percent_reTX
cp $jfi $percent_fasReTX
cp $jfi $percent_lReTX
cp $jfi $percent_drop

for datadir in ${datadirs}; do
  bwstats=${datadir}/bw_stats.txt
  latencystats=${datadir}/latency_index.txt
  pktstats=${datadir}/pkt_stats.txt

  for tech in ${techs}; do
    techesc=$(echo $tech | perl -pe 's/\+/\\\+/g')

    perl -ne "/${techesc}: JFI (\d+\.\d+)/ && print \"\$1\t\"" $bwstats >> $jfi
    perl -ne "/${techesc}: fraction of ideal aggregate bandwidth (\d+\.\d+)/ && print \"\$1\t\";" $bwstats >> $goodput
    grep  -m1 $tech $latencystats | perl -ne '/\w+\s(\d+.\d+)/ && print "$1\t"' >> $latency
    # segTX   reTX    percent_reTX    fasReTX percent_fasReTX lReTX   percent_lReTX   pktsQd  drop    percent_drop
    grep "${tech}-" $pktstats | perl -pe "s/${techesc}-//; s/> 0/0.0000/;" | cut -f3 | awk '{printf("%s",$0);}' >> $percent_reTX
    echo -ne "\t" >> $percent_reTX
    grep "${tech}-" $pktstats | perl -pe "s/${techesc}-//; s/> 0/0.0000/;" | cut -f5 | awk '{printf("%s",$0);}' >> $percent_fasReTX
    echo -ne "\t" >> $percent_fasReTX
    grep "${tech}-" $pktstats | perl -pe "s/${techesc}-//; s/> 0/0.0000/;" | cut -f7 | awk '{printf("%s",$0);}' >> $percent_lReTX
    echo -ne "\t" >> $percent_lReTX
    grep "${tech}-" $pktstats | perl -pe "s/${techesc}-//; s/> 0/0.0000/;" | cut -f10 | awk '{printf("%s",$0);}' >> $percent_drop
    echo -ne "\t" >> $percent_drop
  done

  echo >> $jfi
  echo >> $goodput
  echo >> $latency
  echo >> $percent_reTX
  echo >> $percent_fasReTX
  echo >> $percent_lReTX
  echo >> $percent_drop
done
