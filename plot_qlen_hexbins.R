#!/usr/bin/env Rscript

argv <- commandArgs(TRUE)
          
usage <- function() {
        print("Usage: plot* <qlen1>")
        quit()
}

if (length(argv) < 1) {
        usage()
}

qlenname <- argv[1]

library(ggplot2)
library(RColorBrewer)

qlen <- read.csv(qlenname, head=F, col.names=c("Time", "Depth1"))
maxq <- max(qlen$Depth, na.rm=TRUE)
sample_count <- length(qlen$Depth)
queue_count = length(argv)

getPalette = colorRampPalette(brewer.pal(9, "Set1"))
hexColours <- getPalette(queue_count)

if (queue_count > 1) {
	newqname <- argv[2]
	newq <- read.csv(newqname, head=F, col.names=c("Time", "Depth"))
	qlen$Depth2 <- newq$Depth[1:sample_count]
	maxq <- max(maxq, qlen$Depth2, na.rm=TRUE)
}

if (queue_count > 2) {
	newqname <- argv[3]
	newq <- read.csv(newqname, head=F, col.names=c("Time", "Depth"))
	qlen$Depth3 <- newq$Depth[1:sample_count]
	maxq <- max(maxq, qlen$Depth3, na.rm=TRUE)
}

if (queue_count > 3) {
	newqname <- argv[4]
	newq <- read.csv(newqname, head=F, col.names=c("Time", "Depth"))
	qlen$Depth4 <- newq$Depth[1:sample_count]
	maxq <- max(maxq, qlen$Depth4, na.rm=TRUE)
}

if (queue_count > 4) {
	newqname <- argv[5]
	newq <- read.csv(newqname, head=F, col.names=c("Time", "Depth"))
	qlen$Depth5 <- newq$Depth[1:sample_count]
	maxq <- max(maxq, qlen$Depth5, na.rm=TRUE)
}

if (queue_count > 5) {
	newqname <- argv[6]
	newq <- read.csv(newqname, head=F, col.names=c("Time", "Depth"))
	qlen$Depth6 <- newq$Depth[1:sample_count]
	maxq <- max(maxq, qlen$Depth6, na.rm=TRUE)
}

if (queue_count > 6) {
	newqname <- argv[7]
	newq <- read.csv(newqname, head=F, col.names=c("Time", "Depth"))
	qlen$Depth7 <- newq$Depth[1:sample_count]
	maxq <- max(maxq, qlen$Depth7, na.rm=TRUE)
}

if (queue_count > 7) {
	newqname <- argv[8]
	newq <- read.csv(newqname, head=F, col.names=c("Time", "Depth"))
	qlen$Depth8 <- newq$Depth[1:sample_count]
	maxq <- max(maxq, qlen$Depth8, na.rm=TRUE)
}

if (queue_count > 8) {
	newqname <- argv[9]
	newq <- read.csv(newqname, head=F, col.names=c("Time", "Depth"))
	qlen$Depth9 <- newq$Depth[1:sample_count]
	maxq <- max(maxq, qlen$Depth9, na.rm=TRUE)
}

if (queue_count > 9) {
	newqname <- argv[10]
	newq <- read.csv(newqname, head=F, col.names=c("Time", "Depth"))
	qlen$Depth10 <- newq$Depth[1:sample_count]
	maxq <- max(maxq, qlen$Depth10, na.rm=TRUE)
}

# start time from zero
qlen$Time <- as.numeric(qlen$Time) - min(as.numeric(qlen$Time))
maxt <- max(qlen$Time)

p1 <- ggplot(data=qlen) +
	stat_binhex(bins=60, aes(x=Time, y=Depth1, alpha=..count..), fill=hexColours[1]) +
	guides(fill=FALSE, alpha=FALSE)

annx <- maxt - 2.5
anny <- maxq - 10
p1 <- p1 + annotate("text", x = annx, y = anny, label = argv[1], colour = hexColours[1])

if (queue_count > 1) {
	anny <- anny - 20
	p1 <- p1 + annotate("text", x = annx, y = anny, label = argv[2], colour = hexColours[2])
	p1 <- p1 + stat_binhex(bins=60, aes(x=Time, y=Depth2, alpha=..count..), fill=hexColours[2])
}

if (queue_count > 2) {
	anny <- anny - 20
	p1 <- p1 + annotate("text", x = annx, y = anny, label = argv[3], colour = hexColours[3])
	p1 <- p1 + stat_binhex(bins=60, aes(x=Time, y=Depth3, alpha=..count..), fill=hexColours[3])
}

if (queue_count > 3) {
	anny <- anny - 20
	p1 <- p1 + annotate("text", x = annx, y = anny, label = argv[4], colour = hexColours[4])
	p1 <- p1 + stat_binhex(bins=60, aes(x=Time, y=Depth4, alpha=..count..), fill=hexColours[4])
}

if (queue_count > 4) {
	anny <- anny - 20
	p1 <- p1 + annotate("text", x = annx, y = anny, label = argv[5], colour = hexColours[5])
	p1 <- p1 + stat_binhex(bins=60, aes(x=Time, y=Depth5, alpha=..count..), fill=hexColours[5])
}

if (queue_count > 5) {
	anny <- anny - 20
	p1 <- p1 + annotate("text", x = annx, y = anny, label = argv[6], colour = hexColours[6])
	p1 <- p1 + stat_binhex(bins=60, aes(x=Time, y=Depth6, alpha=..count..), fill=hexColours[6])
}

if (queue_count > 6) {
	anny <- anny - 20
	p1 <- p1 + annotate("text", x = annx, y = anny, label = argv[7], colour = hexColours[7])
	p1 <- p1 + stat_binhex(bins=60, aes(x=Time, y=Depth7, alpha=..count..), fill=hexColours[7])
}

if (queue_count > 7) {
	anny <- anny - 20
	p1 <- p1 + annotate("text", x = annx, y = anny, label = argv[8], colour = hexColours[8])
	p1 <- p1 + stat_binhex(bins=60, aes(x=Time, y=Depth8, alpha=..count..), fill=hexColours[8])
}

if (queue_count > 8) {
	anny <- anny - 20
	p1 <- p1 + annotate("text", x = annx, y = anny, label = argv[9], colour = hexColours[9])
	p1 <- p1 + stat_binhex(bins=60, aes(x=Time, y=Depth9, alpha=..count..), fill=hexColours[9])
}

if (queue_count > 9) {
	anny <- anny - 20
	p1 <- p1 + annotate("text", x = annx, y = anny, label = argv[10], colour = hexColours[10])
	p1 <- p1 + stat_binhex(bins=60, aes(x=Time, y=Depth10, alpha=..count..), fill=hexColours[10])
}

p1 <- p1 +
	ylab("Queue Depth (Packets)") +
	xlab("Time (s)") +
	ylim(0, maxq) +

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

ggsave(plot=p1, filename="qlen-hexbin.png", height=6, width=6)
