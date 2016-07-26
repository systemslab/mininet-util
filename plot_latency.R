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

pdf(file=paste("latency", ".pdf", sep=""), height=6, width=10, pointsize=18)
ggplot(data.m, aes(x = variable, y = value, fill = variable)) +
	geom_violin() +
	geom_violin(scale = "width") +
	geom_boxplot(width=0.075, fill="white") +
	theme_minimal() +
	theme(plot.margin=unit(c(0,0,0,1.5),"cm")) +
	theme(axis.text.x = element_text(angle = 20, vjust = 1, hjust=1)) +
	theme(legend.position="none") +
	scale_x_discrete(limits=c("DCTCP.Middle.Configured", "Inigo.Middle.Configured", "DCTCP.Middle.Configured.With.Inigo.Receiver", "Inigo.Middle.Configured.With.Inigo.Receiver", "DCTCP.Loss.With.Inigo.Receiver", "Inigo.Sender.With.Inigo.Receiver", "DCTCP.Loss", "Inigo.Sender", "DCTCP.Middle.Unconfigured", "Inigo.Sender.With.Inigo.Receiver")) +
	labs(title="",x="", y = "99th Percentile Latency Index", size=18)

dev.off()

# example
pdf(file=paste("latency-example", ".pdf", sep=""), height=6, width=3, pointsize=18)
ggplot(data.m, aes(x = variable, y = value, fill = variable)) +
	geom_violin() +
	geom_violin(scale = "width") +
	geom_boxplot(width=0.075, fill="white") +
	theme_minimal() +
	theme(axis.text.x = element_blank()) +
	theme(legend.position="none") +
	scale_x_discrete(limits=c("DCTCP.Middle.Configured")) +
	labs(title="",x="Probability Density", y = "Index", size=18)

dev.off()

# dctcp
pdf(file=paste("latency-dctcp", ".pdf", sep=""), height=6, width=6, pointsize=18)
ggplot(data.m, aes(x = variable, y = value, fill = variable)) +
	geom_violin() +
	geom_violin(scale = "width") +
	geom_boxplot(width=0.075, fill="white") +
	theme_minimal() +
	theme(plot.margin=unit(c(0,0,0,1.5),"cm")) +
	theme(axis.text.x = element_text(angle = 20, vjust = 1, hjust=1)) +
	theme(legend.position="none") +
	scale_x_discrete(limits=c("DCTCP.Middle.Configured", "DCTCP.Loss", "DCTCP.Middle.Unconfigured")) +
	labs(title="",x="", y = "99th Percentile Latency Index", size=18)

dev.off()

# sender, network, receiver
pdf(file=paste("latency-snr", ".pdf", sep=""), height=6, width=10, pointsize=18)
ggplot(data.m, aes(x = variable, y = value, fill = variable)) +
	geom_violin() +
	geom_violin(scale = "width") +
	geom_boxplot(width=0.075, fill="white") +
	theme_minimal() +
	theme(plot.margin=unit(c(0,0,0,1.5),"cm")) +
	theme(axis.text.x = element_text(angle = 20, vjust = 1, hjust=1)) +
	theme(legend.position="none") +
	scale_x_discrete(limits=c("DCTCP.Middle.Configured", "Inigo.Middle.Configured", "DCTCP.Middle.Configured.With.Inigo.Receiver", "Inigo.Middle.Configured.With.Inigo.Receiver")) +
	labs(title="",x="", y = "99th Percentile Latency Index")

dev.off()

# sender, receiver
pdf(file=paste("latency-sr", ".pdf", sep=""), height=6, width=10, pointsize=18)
ggplot(data.m, aes(x = variable, y = value, fill = variable)) +
	geom_violin() +
	geom_violin(scale = "width") +
	geom_boxplot(width=0.075, fill="white") +
	theme_minimal() +
	theme(plot.margin=unit(c(0,0,0,1.5),"cm")) +
	theme(axis.text.x = element_text(angle = 20, vjust = 1, hjust=1)) +
	theme(legend.position="none") +
	scale_x_discrete(limits=c("DCTCP.Middle.Unconfigured", "Inigo.Sender.With.Inigo.Receiver")) +
	labs(title="",x="", y = "99th Percentile Latency Index")

dev.off()

# sender
pdf(file=paste("latency-s", ".pdf", sep=""), height=6, width=10, pointsize=18)
ggplot(data.m, aes(x = variable, y = value, fill = variable)) +
	geom_violin() +
	geom_violin(scale = "width") +
	geom_boxplot(width=0.075, fill="white") +
	theme_minimal() +
	theme(plot.margin=unit(c(0,0,0,1.5),"cm")) +
	theme(axis.text.x = element_text(angle = 20, vjust = 1, hjust=1)) +
	theme(legend.position="none") +
	scale_x_discrete(limits=c("DCTCP.Loss", "Inigo.Sender")) +
	labs(title="",x="", y = "99th Percentile Latency Index")

dev.off()

# receiver
pdf(file=paste("latency-r", ".pdf", sep=""), height=6, width=10, pointsize=18)
ggplot(data.m, aes(x = variable, y = value, fill = variable)) +
	geom_violin() +
	geom_violin(scale = "width") +
	geom_boxplot(width=0.075, fill="white") +
	theme_minimal() +
	theme(plot.margin=unit(c(0,0,0,1.5),"cm")) +
	theme(axis.text.x = element_text(angle = 20, vjust = 1, hjust=1)) +
	theme(legend.position="none") +
	scale_x_discrete(limits=c("DCTCP.Loss", "DCTCP.Loss.With.Inigo.Receiver")) +
	labs(title="",x="", y = "99th Percentile Latency Index")

dev.off()
warnings()
