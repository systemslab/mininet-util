#!/usr/bin/env Rscript
#require(data.table)

argv <- commandArgs(TRUE)

usage <- function() {
	print("Usage: plot* <nclients> <data>")
	quit()
}

if (length(argv) < 2) {
	usage()
}

library(ggplot2)
library(RColorBrewer)

probe_columns <- c("t", "Client", "Server", "length", "snd_next", "snd_una", "cwnd", "ssthresh", "snd_wnd", "cwnd", "rcv_wnd")

server <- argv[1]
tcpprobename <- argv[2]

png(file="cwnd.png", height=1024, width=1024, pointsize=12)

d1 <- read.table(tcpprobename, head=F, col.names=probe_columns)

Time <- d1$t - min(d1$t, na.rm=TRUE)
maxt <- max(Time, na.rm=TRUE)
d1 <- cbind(d1, Time)

# sort by Time, then Client
d1 <- d1[with(d1, order(Time, Client)), ]
d1$Client <- factor(as.numeric(d1$Client) - 1)

d1 <- d1[grepl(server, d1$Server), ]

#print(d1)

colourCount = length(unique(d1$Client))
getPalette = colorRampPalette(brewer.pal(9, "Set1"))

qplot(Time, cwnd, data = d1, colour = Client, geom = "line") +
	scale_fill_manual(values = getPalette(colourCount)) +
	ylab("cwnd (packets)") +
	xlab("Time (s)") +
	ylim(0, max(d1$cwnd, na.rm=TRUE)) +
	scale_y_continuous(labels = function(x) format(x)) +
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
