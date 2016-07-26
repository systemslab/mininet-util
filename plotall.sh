#!/bin/bash

for stat in goodput jfi latency percent_reTX; do 
  ../../../bin/plot_${stat}.R ${stat}-dctcp-inigo.txt
done

../../../bin/plot_percent_reTX-rfd.R percent_reTX-rfd.txt
