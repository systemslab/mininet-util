#!/usr/bin/env Rscript

argv <- commandArgs(TRUE)

usage <- function() {
	print("Usage: plot* <data>")
	quit()
}

if (length(argv) < 1) {
	usage()
}

filename <- argv[1]

library(ggplot2)

data <- read.table(filename, header=T)
data.m <- reshape2::melt(data, id.vars = NULL)

png(file=paste("percent_reTX", ".png", sep=""), height=1080, width=1920, pointsize=40)
ggplot(data.m, aes(x = variable, y = value, fill = variable)) +
	geom_violin() +
	geom_boxplot(width=0.075, fill="white") +
	theme_minimal() +
	theme(legend.position="none") +
	scale_x_discrete(limits=c("DCTCP", "Inigo", "DCTCP.RFD", "Inigo.RFD", "DCTCP.Reno.RFD", "Inigo.RTT.RFD", "DCTCP.Reno", "Inigo.RTT", "DCTCP.switch.unconfigured", "Inigo.RTT.RFD")) +
        scale_y_log10(breaks=c(0.001, 0.1, 1, 4)) +
	labs(title="",x="", y = "Percent of Segments Retransmitted")

dev.off()

# sender, network, receiver
png(file=paste("percent_reTX-snr", ".png", sep=""), height=600, width=1000, pointsize=40)
ggplot(data.m, aes(x = variable, y = value, fill = variable)) +
	geom_violin() +
	geom_boxplot(width=0.075, fill="white") +
	theme_minimal() +
	theme(legend.position="none") +
	scale_x_discrete(limits=c("DCTCP", "Inigo", "DCTCP.RFD", "Inigo.RFD")) +
	labs(title="",x="", y = "Percent of Segments Retransmitted")

dev.off()

# sender, receiver
png(file=paste("percent_reTX-sr", ".png", sep=""), height=600, width=1000, pointsize=40)
ggplot(data.m, aes(x = variable, y = value, fill = variable)) +
	geom_violin() +
	geom_boxplot(width=0.075, fill="white") +
	theme_minimal() +
	theme(legend.position="none") +
	scale_x_discrete(limits=c("DCTCP.switch.unconfigured", "Inigo.RTT.RFD")) +
	labs(title="",x="", y = "Percent of Segments Retransmitted")

dev.off()

# sender
png(file=paste("percent_reTX-s", ".png", sep=""), height=600, width=1000, pointsize=40)
ggplot(data.m, aes(x = variable, y = value, fill = variable)) +
	geom_violin() +
	geom_boxplot(width=0.075, fill="white") +
	theme_minimal() +
	theme(legend.position="none") +
	scale_x_discrete(limits=c("DCTCP.Reno", "Inigo.RTT")) +
	labs(title="",x="", y = "Percent of Segments Retransmitted")

dev.off()

# receiver
png(file=paste("percent_reTX-r", ".png", sep=""), height=600, width=1000, pointsize=40)
ggplot(data.m, aes(x = variable, y = value, fill = variable)) +
	geom_violin() +
	geom_boxplot(width=0.075, fill="white") +
	theme_minimal() +
	theme(legend.position="none") +
	scale_x_discrete(limits=c("DCTCP.Reno", "DCTCP.Reno.RFD")) +
	labs(title="",x="", y = "Percent of Segments Retransmitted")

dev.off()
warnings()
