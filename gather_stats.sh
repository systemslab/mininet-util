#!/bin/bash

onlytech="inigo\+ecn"

datadirs=$*
firstdir=$(echo ${datadirs} | cut -f1 -d" ")
#techs=$(find ${firstdir}/*/iperf/ -type f -exec basename {} \; | sort | uniq | grep -E "$onlytech")
techs=$(find ${firstdir}/*/iperf/ -type f -exec basename {} \; | sort | uniq)

echo datadirs: $datadirs
echo
echo techs: $techs
echo

outdir_prefix=.

outdir=$outdir_prefix/statistics/bytechstat
mkdir -p $outdir

for tech in ${techs}; do
  techesc=$(echo $tech | perl -pe 's/\+/\\\+/g')
  for datadir in ${datadirs}; do
    subdatadirs=$(find ${datadir}/*/ -type d -name iperf -exec dirname {} \;)
    for subdatadir in ${subdatadirs}; do
      bwstats=${subdatadir}/bw_stats.txt
      latencystats=${subdatadir}/latency_index.txt
      pktstats=${subdatadir}/pkt_stats.txt

      perl -ne "/${techesc}: JFI (\d+\.\d+)/ && print \"\$1\n\"" $bwstats >> $outdir/${tech}-jfi.txt
      perl -ne "/${techesc}: fraction of ideal aggregate bandwidth (\d+\.\d+)/ && print \"\$1\n\";" $bwstats >> $outdir/${tech}-goodput.txt
      # what am I doing wrong?
      #perl -ne "/${techesc}\s+(\d+\.\d+)/ && print \"\$1\" && exit;" $latencystats >> $outdir/indices/$tech
      grep  -m1 "$tech " $latencystats | perl -ne '/\w+\s(\d+.\d+)/ && print "$1\n"' >> $outdir/${tech}-latency.txt

      grep "${tech}-" $pktstats | perl -pe "s/> 0/0.0000/;" | perl -ne '/^[^\s]+\s+\d+\s+(\d+\.\d+)/ && print "$1\n"' >> $outdir/${tech}-percent_reTX.txt
    done
  done
done

jfi=jfi.txt
goodput=goodput.txt
latency=latency.txt
percent_reTX=percent_reTX.txt

cd $outdir

for tech in ${techs}; do
  echo -ne "${tech}\t" >> $jfi
done
echo >> $jfi

cp $jfi $goodput
cp $jfi $latency
cp $jfi $percent_reTX

techfiles=$(echo $techs | perl -pe 's/ /-jfi.txt /g')-jfi.txt
echo "paste -- $techfiles >> $jfi"
paste -- $techfiles >> $jfi

techfiles=$(echo $techs | perl -pe 's/ /-goodput.txt /g')-goodput.txt
echo "paste -- $techfiles >> $goodput"
paste -- $techfiles >> $goodput

techfiles=$(echo $techs | perl -pe 's/ /-latency.txt /g')-latency.txt
echo "paste -- $techfiles >> $latency"
paste -- $techfiles >> $latency

techfiles=$(echo $techs | perl -pe 's/ /-percent_reTX.txt /g')-percent_reTX.txt
echo "paste -- $techfiles >> $percent_reTX"
paste -- $techfiles >> $percent_reTX

cd -


outdir=$outdir_prefix/statistics/bytech
mkdir -p $outdir/indices
mkdir -p $outdir/retrans

for tech in ${techs}; do
  echo -ne "JFI\tGoodput\tLatency" > $outdir/indices/$tech

  echo -e "segTX\treTX\tpercent_reTX\tfasReTX\tpercent_fasReTX\tlReTX\tpercent_lReTX\tpktsQd\tdrop\tpercent_drop" > $outdir/retrans/$tech

  techesc=$(echo $tech | perl -pe 's/\+/\\\+/g')
  for datadir in ${datadirs}; do
    subdatadirs=$(find ${datadir}/*/ -type d -name iperf -exec dirname {} \;)
    for subdatadir in ${subdatadirs}; do
      bwstats=${subdatadir}/bw_stats.txt
      latencystats=${subdatadir}/latency_index.txt
      pktstats=${subdatadir}/pkt_stats.txt

      perl -ne "/${techesc}: JFI (\d+\.\d+)/ && print \"\n\$1\t\"" $bwstats >> $outdir/indices/$tech
      perl -ne "/${techesc}: fraction of ideal aggregate bandwidth (\d+\.\d+)/ && print \"\$1\t\";" $bwstats >> $outdir/indices/$tech
      # what am I doing wrong?
      #perl -ne "/${techesc}\s+(\d+\.\d+)/ && print \"\$1\" && exit;" $latencystats >> $outdir/indices/$tech
      grep  -m1 "$tech " $latencystats | perl -ne '/\w+\s(\d+.\d+)/ && print "$1\t"' >> $outdir/indices/$tech

      grep "${tech}-" $pktstats | perl -pe "s/${techesc}-//; s/> 0/0.0000/;" >> $outdir/retrans/$tech
    done
  done
done

outdir=$outdir_prefix/statistics/bystat
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
  subdatadirs=$(find ${datadir}/*/ -type d -name iperf -exec dirname {} \;)
  for subdatadir in ${subdatadirs}; do
    bwstats=${subdatadir}/bw_stats.txt
    latencystats=${subdatadir}/latency_index.txt
    pktstats=${subdatadir}/pkt_stats.txt

    #echo subdatadir: $subdatadir
    for tech in ${techs}; do
      #echo tech: $tech
      techesc=$(echo $tech | perl -pe 's/\+/\\\+/g')

      perl -ne "/${techesc}: JFI (\d+\.\d+)/ && print \"\$1\t\"" $bwstats >> $jfi
      perl -ne "/${techesc}: fraction of ideal aggregate bandwidth (\d+\.\d+)/ && print \"\$1\t\";" $bwstats >> $goodput
      grep  -m1 "$tech " $latencystats | perl -ne '/\w+\s(\d+.\d+)/ && print "$1\t"' >> $latency
      #grep  -m1 "$tech " $latencystats | perl -ne '/\w+\s(\d+.\d+)/ && print "$1\t"'
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
  done

  echo >> $jfi
  echo >> $goodput
  echo >> $latency
  echo >> $percent_reTX
  echo >> $percent_fasReTX
  echo >> $percent_lReTX
  echo >> $percent_drop
done
