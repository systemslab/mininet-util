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
library(RColorBrewer)
require(grid)

png(file="iperf-stacked.png", height=600, width=600, pointsize=12)

iperf <- read.csv(iperfname, head=F, skip=1, col.names=c("Time", "server", "port", "Client", "clientport", "id", "Start", "Stop", "bytes", "Rate"))

# sort by start time, then client
iperf <- iperf[with(iperf, order(Start, Client)), ]

iperf$Client <- factor(as.numeric(iperf$Client))

#print(iperf)

colourCount = length(unique(iperf$Client))
getPalette = colorRampPalette(brewer.pal(9, "Set1"))

qplot(Start, Rate, data = iperf, fill = Client, geom = "bar", stat = "identity") +
	ylim(0, maxbw * 1000000) +
	scale_fill_manual(values = getPalette(colourCount)) +
	labs(x=NULL, y=NULL) +
	theme_bw() +
	theme(axis.line=element_blank(),axis.text=element_blank(),axis.ticks=element_blank(),
              legend.position="none",
              panel.margin=unit(0, "lines"),
              plot.margin=unit(c(-10, -10, -12.5, -12.5), "mm"),
              panel.grid=element_blank(),panel.border=element_blank(),
              plot.background=element_blank())

dev.off()
