#!/usr/bin/env Rscript

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

iperf <- read.csv(iperfname, head=F, skip=1, col.names=c("Time", "server", "port", "Client", "clientport", "id", "interval", "bytes", "Rate"))

# start time from zero
iperf$Time <- as.numeric(iperf$Time) - min(as.numeric(iperf$Time))

# exclude intervals like 0.0-0.0 and 0.0-30.0
#print(iperf[grepl("(^0.0-[^1])|(^0.0-1[0-9]+)", iperf$interval, perl=TRUE), ])
iperf <- iperf[!grepl("(^0.0-[^1])|(^0.0-1[0-9]+)", iperf$interval), ]

# sort by time, then client
iperf <- iperf[with(iperf, order(Client)), ]

iperf$Client <- factor(as.numeric(iperf$Client))

#print(iperf)

colourCount = length(unique(iperf$Client))
getPalette = colorRampPalette(brewer.pal(9, "Set1"))

qplot(Time, Rate, data = iperf, fill = Client, geom = "bar", stat = "identity") +
	scale_fill_manual(values = getPalette(colourCount)) +
	ylab("Average Rate (Gbps)") +
	xlab("Time (s)") +
	ylim(0, max(iperf$Rate, na.rm=TRUE)) +
	scale_y_continuous(labels = function(x) format(x/1000000000)) +
	guides(fill = guide_legend(reverse = TRUE)) +
	#theme with white background
	theme_bw() +

	#eliminates background, gridlines, and chart border
	theme(
	plot.background = element_blank()
	,panel.grid.major = element_blank()
	,panel.grid.minor = element_blank()
	,panel.border = element_blank()
	) +

	#draws x and y axis line
	theme(axis.line = element_line(color = 'black'))

dev.off()
