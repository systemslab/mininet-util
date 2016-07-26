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
library(grid)

data <- read.table(filename, header=T)
data.m <- reshape2::melt(data, id.vars = NULL)

pdf(file=paste("jfi", ".pdf", sep=""), height=6, width=10, pointsize=18)
ggplot(data.m, aes(x = variable, y = value, fill = variable)) +
	geom_violin() +
	geom_boxplot(width=0.075, fill="white") +
	theme_minimal() +
	theme(plot.margin=unit(c(0,0,0,1.5),"cm")) +
	theme(axis.text.x = element_text(angle = 20, vjust = 1, hjust=1)) +
	theme(legend.position="none") +
	scale_x_discrete(limits=c("DCTCP.Middle.Configured", "Inigo.Middle.Configured", "DCTCP.Middle.Configured.With.Inigo.Receiver", "Inigo.Middle.Configured.With.Inigo.Receiver", "DCTCP.Loss.With.Inigo.Receiver", "Inigo.Sender.With.Inigo.Receiver", "DCTCP.Loss", "Inigo.Sender", "DCTCP.Middle.Unconfigured", "Inigo.Sender.With.Inigo.Receiver")) +
	labs(title="",x="", y = "Jain's Fairness Index")

dev.off()

# sender, network, receiver
pdf(file=paste("jfi-snr", ".pdf", sep=""), height=6, width=10, pointsize=18)
ggplot(data.m, aes(x = variable, y = value, fill = variable)) +
	geom_violin() +
	geom_boxplot(width=0.075, fill="white") +
	theme_minimal() +
	theme(plot.margin=unit(c(0,0,0,1.5),"cm")) +
	theme(axis.text.x = element_text(angle = 20, vjust = 1, hjust=1)) +
	theme(legend.position="none") +
	scale_x_discrete(limits=c("DCTCP.Middle.Configured", "Inigo.Middle.Configured", "DCTCP.Middle.Configured.With.Inigo.Receiver", "Inigo.Middle.Configured.With.Inigo.Receiver")) +
	labs(title="",x="", y = "Jain's Fairness Index")

dev.off()

# sender, receiver
pdf(file=paste("jfi-sr", ".pdf", sep=""), height=6, width=10, pointsize=18)
ggplot(data.m, aes(x = variable, y = value, fill = variable)) +
	geom_violin() +
	geom_boxplot(width=0.075, fill="white") +
	theme_minimal() +
	theme(plot.margin=unit(c(0,0,0,1.5),"cm")) +
	theme(axis.text.x = element_text(angle = 20, vjust = 1, hjust=1)) +
	theme(legend.position="none") +
	scale_x_discrete(limits=c("DCTCP.Middle.Unconfigured", "Inigo.Sender.With.Inigo.Receiver")) +
	labs(title="",x="", y = "Jain's Fairness Index")

dev.off()

# sender
pdf(file=paste("jfi-s", ".pdf", sep=""), height=6, width=10, pointsize=18)
ggplot(data.m, aes(x = variable, y = value, fill = variable)) +
	geom_violin() +
	geom_boxplot(width=0.075, fill="white") +
	theme_minimal() +
	theme(plot.margin=unit(c(0,0,0,1.5),"cm")) +
	theme(axis.text.x = element_text(angle = 20, vjust = 1, hjust=1)) +
	theme(legend.position="none") +
	scale_x_discrete(limits=c("DCTCP.Loss", "Inigo.Sender")) +
	labs(title="",x="", y = "Jain's Fairness Index")

dev.off()

# receiver
pdf(file=paste("jfi-r", ".pdf", sep=""), height=6, width=10, pointsize=18)
ggplot(data.m, aes(x = variable, y = value, fill = variable)) +
	geom_violin() +
	geom_boxplot(width=0.075, fill="white") +
	theme_minimal() +
	theme(plot.margin=unit(c(0,0,0,1.5),"cm")) +
	theme(axis.text.x = element_text(angle = 20, vjust = 1, hjust=1)) +
	theme(legend.position="none") +
	scale_x_discrete(limits=c("DCTCP.Loss", "DCTCP.Loss.With.Inigo.Receiver")) +
	labs(title="",x="", y = "Jain's Fairness Index")

dev.off()
warnings()
