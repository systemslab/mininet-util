#!/usr/bin/env Rscript

argv <- commandArgs(TRUE)
          
usage <- function() {
        print("Usage: plot* <tcpprobe1>")
        quit()
}

if (length(argv) < 1) {
        usage()
}

tcpprobename <- argv[1]

library(ggplot2)
library(RColorBrewer)

probe_columns <- c("Time", "src", "dst", "length", "snd_next", "snd_una", "cwnd", "ssthresh", "snd_wnd", "SRTT", "rcv_wnd")

tcpprobe <- read.csv(tcpprobename, head=F, sep=" ", col.names=probe_columns)
tcpprobe$SRTT <- log(tcpprobe$SRTT)
maxsrtt <- max(tcpprobe$SRTT, na.rm=TRUE)
sample_count <- length(tcpprobe$SRTT)
probe_count = length(argv)

getPalette = colorRampPalette(brewer.pal(9, "Set1"))
hexColours <- getPalette(probe_count)

if (probe_count > 1) {
	newprobename <- argv[2]
	newprobe <- read.csv(newprobename, head=F, sep=" ", col.names=probe_columns)
	tcpprobe$SRTT2 <- log(newprobe$SRTT[1:sample_count])
	maxsrtt <- max(maxsrtt, tcpprobe$SRTT2, na.rm=TRUE)
}

if (probe_count > 2) {
	newprobename <- argv[3]
	newprobe <- read.csv(newprobename, head=F, sep=" ", col.names=probe_columns)
	tcpprobe$SRTT3 <- log(newprobe$SRTT[1:sample_count])
	maxsrtt <- max(maxsrtt, tcpprobe$SRTT3, na.rm=TRUE)
}

if (probe_count > 3) {
	newprobename <- argv[4]
	newprobe <- read.csv(newprobename, head=F, sep=" ", col.names=probe_columns)
	tcpprobe$SRTT4 <- log(newprobe$SRTT[1:sample_count])
	maxsrtt <- max(maxsrtt, tcpprobe$SRTT4, na.rm=TRUE)
}

if (probe_count > 4) {
	newprobename <- argv[5]
	newprobe <- read.csv(newprobename, head=F, sep=" ", col.names=probe_columns)
	tcpprobe$SRTT5 <- log(newprobe$SRTT[1:sample_count])
	maxsrtt <- max(maxsrtt, tcpprobe$SRTT5, na.rm=TRUE)
}

if (probe_count > 5) {
	newprobename <- argv[6]
	newprobe <- read.csv(newprobename, head=F, sep=" ", col.names=probe_columns)
	tcpprobe$SRTT6 <- log(newprobe$SRTT[1:sample_count])
	maxsrtt <- max(maxsrtt, tcpprobe$SRTT6, na.rm=TRUE)
}

if (probe_count > 6) {
	newprobename <- argv[7]
	newprobe <- read.csv(newprobename, head=F, sep=" ", col.names=probe_columns)
	tcpprobe$SRTT7 <- log(newprobe$SRTT[1:sample_count])
	maxsrtt <- max(maxsrtt, tcpprobe$SRTT7, na.rm=TRUE)
}

if (probe_count > 7) {
	newprobename <- argv[8]
	newprobe <- read.csv(newprobename, head=F, sep=" ", col.names=probe_columns)
	tcpprobe$SRTT8 <- log(newprobe$SRTT[1:sample_count])
	maxsrtt <- max(maxsrtt, tcpprobe$SRTT8, na.rm=TRUE)
}

if (probe_count > 8) {
	newprobename <- argv[9]
	newprobe <- read.csv(newprobename, head=F, sep=" ", col.names=probe_columns)
	tcpprobe$SRTT9 <- log(newprobe$SRTT[1:sample_count])
	maxsrtt <- max(maxsrtt, tcpprobe$SRTT9, na.rm=TRUE)
}

if (probe_count > 9) {
	newprobename <- argv[10]
	newprobe <- read.csv(newprobename, head=F, sep=" ", col.names=probe_columns)
	tcpprobe$SRTT10 <- log(newprobe$SRTT[1:sample_count])
	maxsrtt <- max(maxsrtt, tcpprobe$SRTT10, na.rm=TRUE)
}

# start time from zero
tcpprobe$Time <- as.numeric(tcpprobe$Time) - min(as.numeric(tcpprobe$Time))
maxt <- max(tcpprobe$Time)

head(tcpprobe)

p1 <- ggplot(data=tcpprobe) +
	stat_binhex(bins=60, aes(x=Time, y=SRTT, alpha=..count..), fill=hexColours[1]) +
	guides(fill=FALSE, alpha=FALSE)

annx <- maxt - 2.5
anny <- maxsrtt - 1
p1 <- p1 + annotate("text", x = annx, y = anny, label = argv[1], colour = hexColours[1])

if (probe_count > 1) {
	anny <- anny - 2
	p1 <- p1 + annotate("text", x = annx, y = anny, label = argv[2], colour = hexColours[2])
	p1 <- p1 + stat_binhex(bins=60, aes(x=Time, y=SRTT2, alpha=..count..), fill=hexColours[2])
}

if (probe_count > 2) {
	anny <- anny - 2
	p1 <- p1 + annotate("text", x = annx, y = anny, label = argv[3], colour = hexColours[3])
	p1 <- p1 + stat_binhex(bins=60, aes(x=Time, y=SRTT3, alpha=..count..), fill=hexColours[3])
}

if (probe_count > 3) {
	anny <- anny - 2
	p1 <- p1 + annotate("text", x = annx, y = anny, label = argv[4], colour = hexColours[4])
	p1 <- p1 + stat_binhex(bins=60, aes(x=Time, y=SRTT4, alpha=..count..), fill=hexColours[4])
}

if (probe_count > 4) {
	anny <- anny - 2
	p1 <- p1 + annotate("text", x = annx, y = anny, label = argv[5], colour = hexColours[5])
	p1 <- p1 + stat_binhex(bins=60, aes(x=Time, y=SRTT5, alpha=..count..), fill=hexColours[5])
}

if (probe_count > 5) {
	anny <- anny - 2
	p1 <- p1 + annotate("text", x = annx, y = anny, label = argv[6], colour = hexColours[6])
	p1 <- p1 + stat_binhex(bins=60, aes(x=Time, y=SRTT6, alpha=..count..), fill=hexColours[6])
}

if (probe_count > 6) {
	anny <- anny - 2
	p1 <- p1 + annotate("text", x = annx, y = anny, label = argv[7], colour = hexColours[7])
	p1 <- p1 + stat_binhex(bins=60, aes(x=Time, y=SRTT7, alpha=..count..), fill=hexColours[7])
}

if (probe_count > 7) {
	anny <- anny - 2
	p1 <- p1 + annotate("text", x = annx, y = anny, label = argv[8], colour = hexColours[8])
	p1 <- p1 + stat_binhex(bins=60, aes(x=Time, y=SRTT8, alpha=..count..), fill=hexColours[8])
}

if (probe_count > 8) {
	anny <- anny - 2
	p1 <- p1 + annotate("text", x = annx, y = anny, label = argv[9], colour = hexColours[9])
	p1 <- p1 + stat_binhex(bins=60, aes(x=Time, y=SRTT9, alpha=..count..), fill=hexColours[9])
}

if (probe_count > 9) {
	anny <- anny - 2
	p1 <- p1 + annotate("text", x = annx, y = anny, label = argv[10], colour = hexColours[10])
	p1 <- p1 + stat_binhex(bins=60, aes(x=Time, y=SRTT10, alpha=..count..), fill=hexColours[10])
}

p1 <- p1 +
	ylab(expression(paste("Log of SRTT (", mu, "s)"))) +
	xlab("Time (s)") +
	ylim(0, maxsrtt) +

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

ggsave(plot=p1, filename="srtt-hexbin.png", height=6, width=6)
