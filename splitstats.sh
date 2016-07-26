for stat in goodput jfi latency percent_reTX; do
  cut -f1,2,3,4 -d"	" ${stat}.txt >> ${stat}-cdg.txt
  cut -f5,6,7,8 -d"	" ${stat}.txt >> ${stat}-cubic.txt

  echo '"DCTCP Reno"	"DCTCP"	"DCTCP RFD"	"DCTCP switch unconfigured"	"DCTCP Reno RFD"' > ${stat}-dctcp.txt
  cut -f9,10,11,12,13 -d"	" ${stat}.txt | grep -v dctcp >> ${stat}-dctcp.txt

  echo '"Inigo RTT"	"Inigo"	"Inigo RFD"	"Inigo switch unconfigured"	"Inigo RTT RFD"' > ${stat}-inigo.txt
  cut -f14,15,16,17,18 -d"	" ${stat}.txt | grep -v inigo >> ${stat}-inigo.txt

  echo '"DCTCP Reno"	"DCTCP"	"DCTCP RFD"	"DCTCP switch unconfigured"	"DCTCP Reno RFD"	"Inigo RTT"	"Inigo"	"Inigo RFD"	"Inigo switch unconfigured"	"Inigo RTT RFD"' > ${stat}-dctcp-inigo.txt
  cut -f9,10,11,12,13,14,15,16,17,18 -d"	" ${stat}.txt | grep -v inigo >> ${stat}-dctcp-inigo.txt
done
