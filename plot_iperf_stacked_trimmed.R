#!/usr/bin/env Rscript

# This script requires iperf's output to be fixed with something like:
# grep -Ev ",(0.0-[^1])|,(0.0-1[0-9]+)" iperf_h1.txt | sed 's/-/,/' > iperf_h1.txt.fixed
#
# This is because that the initial time column can have huge gaps that don't really exist,
# at least in Mininet experiments.

argv <- commandArgs(TRUE)
          
usage <- function() {
        print("Usage: plot* <maxbw mbps> <iperf>")
        quit()
}

if (length(argv) < 2) {
        usage()
}

maxbw <- as.numeric(argv[1])
iperfname <- argv[2]

library(ggplot2)
require(grid)

png(file="iperf-stacked.png", height=600, width=600, pointsize=12)

iperf <- read.csv(iperfname, head=F, skip=1, col.names=c("Time", "server", "port", "Client", "clientport", "id", "Start", "Stop", "bytes", "Rate"))

# sort by start time, then client
iperf <- iperf[with(iperf, order(Start, Client)), ]

nclients <- length(unique(iperf$Client))
iperf$Client <- factor(as.numeric(iperf$Client))
#print(unique(iperf$Client))

#print(iperf)

# http://colorbrewer2.org/?type=diverging&scheme=BrBG&n=6
# ['#8c510a','#d8b365','#f6e8c3','#c7eae5','#5ab4ac','#01665e']
# ['#762a83','#af8dc3','#e7d4e8','#d9f0d3','#7fbf7b','#1b7837']
# ['#b2182b','#ef8a62','#fddbc7','#d1e5f0','#67a9cf','#2166ac']
# ['#d73027','#fc8d59','#fee090','#e0f3f8','#91bfdb','#4575b4']

# and fiddled with http://tools.medialab.sciences-po.fr/iwanthue/
# mycolors = c('#8c510a','#d8b365','#f6e8c3','#c7eae5','#5ab4ac','#01665e',
#          '#762a83','#af8dc3','#e7d4e8','#d9f0d3','#7fbf7b','#1b7837',
#          '#50823B','#BDF099','#fee090','#e0f3f8','#91bfdb','#4575b4',
#          '#444444','#aaaaaa')

mycolors = c("#C2DF73",
"#C488DB",
"#54A9B7",
"#68DB98",
"#C4D5BB",
"#DBBADA",
"#969149",
"#65DF65",
"#5FA047",
"#699977",
"#E2E140",
"#878B94",
"#639ED2",
"#67DECF",
"#97DC39",
"#B4D3E1",
"#9E80AF",
"#B3AF34",
"#CAD696",
"#8C92DD")

mycolors = c("#C8C44A",
"#AB83CF",
"#66DCCA",
"#5F7651",
"#5EDF81",
"#6E738E",
"#C4D0C8",
"#63A138",
"#81E14C",
"#71C3DC",
"#C8B6DA",
"#6994D1",
"#548C89",
"#BEDF81",
"#77822B",
"#4F9960",
"#A6AE7D",
"#6ED79F",
"#CAE5B6",
"#CFE139")

library(RColorBrewer)
colourCount = length(unique(iperf$Client))
getPalette = colorRampPalette(brewer.pal(9, "Set1"))
mycolors = getPalette(colourCount)

qplot(Start, Rate, data = iperf, fill = Client, geom = "bar", stat = "identity") +
	ylim(0, maxbw * 1000000) +
	scale_fill_manual(values = mycolors) +
	labs(x=NULL, y=NULL) +
	theme_bw() +
	theme(axis.line=element_blank(),axis.text=element_blank(),axis.ticks=element_blank(),
              legend.position="none",
              panel.margin=unit(0, "lines"),
              plot.margin=unit(c(-10, -10, -12.5, -12.5), "mm"),
              panel.grid=element_blank(),panel.border=element_blank(),
              plot.background=element_blank())

dev.off()
