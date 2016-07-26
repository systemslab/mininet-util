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

pdf(file=paste("jfi", ".pdf", sep=""), height=6, width=10, pointsize=18)
ggplot(data.m, aes(x = variable, y = value, fill = variable)) +
	geom_violin() +
	geom_boxplot(width=0.075, fill="white") +
	theme_minimal() +
	theme(legend.position="none") +
	scale_x_discrete(limits=c("DCTCP", "Inigo", "DCTCP.RFD", "Inigo.RFD", "DCTCP.Reno.RFD", "Inigo.RTT.RFD", "DCTCP.Reno", "Inigo.RTT", "DCTCP.switch.unconfigured", "Inigo.RTT.RFD")) +
	labs(title="",x="", y = "Jain's Fairness Index")

dev.off()

# sender, network, receiver
pdf(file=paste("jfi-snr", ".pdf", sep=""), height=3, width=5, pointsize=40)
ggplot(data.m, aes(x = variable, y = value, fill = variable)) +
	geom_violin() +
	geom_boxplot(width=0.075, fill="white") +
	theme_minimal() +
	theme(legend.position="none") +
	scale_x_discrete(limits=c("DCTCP", "Inigo", "DCTCP.RFD", "Inigo.RFD")) +
	labs(title="",x="", y = "Jain's Fairness Index")

dev.off()

# sender, receiver
pdf(file=paste("jfi-sr", ".pdf", sep=""), height=3, width=5, pointsize=40)
ggplot(data.m, aes(x = variable, y = value, fill = variable)) +
	geom_violin() +
	geom_boxplot(width=0.075, fill="white") +
	theme_minimal() +
	theme(legend.position="none") +
	scale_x_discrete(limits=c("DCTCP.switch.unconfigured", "Inigo.RTT.RFD")) +
	labs(title="",x="", y = "Jain's Fairness Index")

dev.off()

# sender
pdf(file=paste("jfi-s", ".pdf", sep=""), height=3, width=5, pointsize=40)
ggplot(data.m, aes(x = variable, y = value, fill = variable)) +
	geom_violin() +
	geom_boxplot(width=0.075, fill="white") +
	theme_minimal() +
	theme(legend.position="none") +
	scale_x_discrete(limits=c("DCTCP.Reno", "Inigo.RTT")) +
	labs(title="",x="", y = "Jain's Fairness Index")

dev.off()

# receiver
pdf(file=paste("jfi-r", ".pdf", sep=""), height=3, width=5, pointsize=40)
ggplot(data.m, aes(x = variable, y = value, fill = variable)) +
	geom_violin() +
	geom_boxplot(width=0.075, fill="white") +
	theme_minimal() +
	theme(legend.position="none") +
	scale_x_discrete(limits=c("DCTCP.Reno", "DCTCP.Reno.RFD")) +
	labs(title="",x="", y = "Jain's Fairness Index")

dev.off()
warnings()
