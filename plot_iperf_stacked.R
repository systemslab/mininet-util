#!/usr/bin/env Rscript

# This script requires iperf's output to be fixed with something like:
# grep -Ev ",(0.0-[^1])|,(0.0-1[0-9]+)" iperf_h1.txt | sed 's/-/,/' > iperf_h1.txt.fixed
#
# This is because that the initial time column can have huge gaps that don't really exist,
# at least in Mininet experiments.

argv <- commandArgs(TRUE)
          
usage <- function() {
        print("Usage: plot* <iperf>")
        quit()
}

if (length(argv) < 1) {
        usage()
}

iperfname <- argv[1]

library(ggplot2)
library(RColorBrewer)

png(file="iperf-stacked.png", height=600, width=600, pointsize=12)

iperf <- read.csv(iperfname, head=F, skip=1, col.names=c("Time", "server", "port", "Client", "clientport", "id", "Start", "Stop", "bytes", "Rate"))

# sort by start time, then client
iperf <- iperf[with(iperf, order(Start, Client)), ]

iperf$Client <- factor(as.numeric(iperf$Client))

#print(iperf)

colourCount = length(unique(iperf$Client))
getPalette = colorRampPalette(brewer.pal(9, "Set1"))

qplot(Start, Rate, data = iperf, fill = Client, geom = "bar", stat = "identity") +
	ylab("Average Rate (Gbps)") +
	xlab("Time (s)") +
	scale_fill_manual(values = getPalette(colourCount)) +
	scale_y_continuous(labels = function(x) format(x/1000000000)) +
	guides(fill = guide_legend(reverse = TRUE)) +
	theme_bw() +
	theme(panel.grid.minor = element_line(colour="grey", linetype="dotted"))

dev.off()
