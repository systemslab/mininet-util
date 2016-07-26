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

pdf(file=paste("percent_reTX", ".pdf", sep=""), height=6, width=10, pointsize=18)
ggplot(data.m, aes(x = variable, y = value, fill = variable)) +
	geom_violin() +
	geom_boxplot(width=0.075, fill="white") +
	theme_minimal() +
	theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1)) +
	theme(legend.position="none") +
	scale_x_discrete(limits=c("DCTCP.Middle.Configured", "Inigo.Middle.Configured", "DCTCP.Middle.Configured.With.Inigo.Receiver", "Inigo.Middle.Configured.With.Inigo.Receiver", "DCTCP.Loss.With.Inigo.Receiver", "Inigo.Sender.With.Inigo.Receiver", "DCTCP.Loss", "Inigo.Sender", "DCTCP.Middle.Unconfigured", "Inigo.Sender.With.Inigo.Receiver")) +
        scale_y_log10(breaks=c(0.001, 0.1, 1, 4)) +
	labs(title="",x="", y = "Percent of Segments Retransmitted")

dev.off()

# sender, network, receiver
pdf(file=paste("percent_reTX-snr", ".pdf", sep=""), height=6, width=10, pointsize=18)
ggplot(data.m, aes(x = variable, y = value, fill = variable)) +
	geom_violin() +
	geom_boxplot(width=0.075, fill="white") +
	theme_minimal() +
	theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1)) +
	theme(legend.position="none") +
	scale_x_discrete(limits=c("DCTCP.Middle.Configured", "Inigo.Middle.Configured", "DCTCP.Middle.Configured.With.Inigo.Receiver", "Inigo.Middle.Configured.With.Inigo.Receiver")) +
	labs(title="",x="", y = "Percent of Segments Retransmitted")

dev.off()

# sender, receiver
pdf(file=paste("percent_reTX-sr", ".pdf", sep=""), height=6, width=10, pointsize=18)
ggplot(data.m, aes(x = variable, y = value, fill = variable)) +
	geom_violin() +
	geom_boxplot(width=0.075, fill="white") +
	theme_minimal() +
	theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1)) +
	theme(legend.position="none") +
	scale_x_discrete(limits=c("DCTCP.Middle.Unconfigured", "Inigo.Sender.With.Inigo.Receiver")) +
	labs(title="",x="", y = "Percent of Segments Retransmitted")

dev.off()

# sender
pdf(file=paste("percent_reTX-s", ".pdf", sep=""), height=6, width=10, pointsize=18)
ggplot(data.m, aes(x = variable, y = value, fill = variable)) +
	geom_violin() +
	geom_boxplot(width=0.075, fill="white") +
	theme_minimal() +
	theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1)) +
	theme(legend.position="none") +
	scale_x_discrete(limits=c("DCTCP.Loss", "Inigo.Sender")) +
	labs(title="",x="", y = "Percent of Segments Retransmitted")

dev.off()

# receiver
pdf(file=paste("percent_reTX-r", ".pdf", sep=""), height=6, width=10, pointsize=18)
ggplot(data.m, aes(x = variable, y = value, fill = variable)) +
	geom_violin() +
	geom_boxplot(width=0.075, fill="white") +
	theme_minimal() +
	theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1)) +
	theme(legend.position="none") +
	scale_x_discrete(limits=c("DCTCP.Loss", "DCTCP.Loss.With.Inigo.Receiver")) +
	labs(title="",x="", y = "Percent of Segments Retransmitted")

dev.off()
warnings()
