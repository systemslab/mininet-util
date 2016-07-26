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

pdf(file=paste("percent_reTX-rfd", ".pdf", sep=""), height=6, width=10, pointsize=18)
ggplot(data.m, aes(x = variable, y = value, fill = variable)) +
	geom_violin() +
	geom_boxplot(width=0.075, fill="white") +
	theme_minimal() +
	theme(plot.margin=unit(c(0,0,0,1.5),"cm")) +
	theme(axis.text.x = element_text(angle = 20, vjust = 1, hjust=1)) +
	theme(legend.position="none") +
	scale_x_discrete(limits=c("CUBIC", "CUBIC.RFD", "DCTCP.Loss", "DCTCP.Loss.With.Inigo.Receiver")) +
        scale_y_log10(breaks=c(0.001, 0.1, 1, 4)) +
	labs(title="",x="", y = "Percent of Segments Retransmitted")

dev.off()
