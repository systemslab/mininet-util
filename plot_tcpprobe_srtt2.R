#!/usr/bin/env Rscript

argv <- commandArgs(TRUE)

usage <- function() {
	print("Usage: plot* <data>+")
	quit()
}

if (length(argv) < 1) {
	usage()
}

argv <- commandArgs(TRUE)
n <- length(argv)

columns <- c("Time", "src", "dst", "length", "snd_next", "snd_una", "cwnd", "ssthresh", "snd_wnd", "SRTT", "rcv_wnd")

if (n >= 1) {
  d1 <- read.table(argv[1], header=F, col.names=columns)
  d1$type = argv[1]
  d1$op = "set"
  d1['Sequence'] <- rownames(d1)
  d1tshifted <- d1$Time - min(d1$Time, na.rm=TRUE)
  time_min <- min(d1$Time)
  time_max <- max(d1$Time)
  time_max999th <- quantile(d1$Time, c(0.999))
  d <- d1
  c1 <- d1

  print(summary(d1))
  print(paste("Sum of op measurements: ", sum(d1$Time)/1000000, " seconds"))
}

if (n >= 2) {
  d2 <- read.table(argv[2], header=F, col.names=columns)
  d2$type = "consensus2 sets"
  d2$op = "set"
  d2['Sequence'] <- rownames(d2)
  time_min <- min(time_min, d2$Time)
  time_max <- max(time_max, d2$Time)
  time_max999th <- max(time_max999th, quantile(d2$Time, c(0.999)), na.rm=TRUE)
  d <- rbind(d1, d2)
  c2 <- d2

  print(summary(d2))
  print(paste("Sum of op measurements: ", sum(d2$Time)/1000000, " seconds"))
}

if (n >= 3) {
  d3 <- read.table(argv[3], header=F, col.names=columns)
  d3$type = "consensus1 gets"
  d3$op = "get"
  d3['Sequence'] <- rownames(d3)
  time_min <- min(time_min, d3$Time)
  time_max <- max(time_max, d3$Time)
  time_max999th <- max(time_max999th, quantile(d3$Time, c(0.999)), na.rm=TRUE)
  d <- rbind(d1, d2, d3)
  c1 <- rbind(d1, d3)

  print(summary(d3))
  print(paste("Sum of op measurements: ", sum(d3$Time)/1000000, " seconds"))
}

if (n >= 4) {
  d4 <- read.table(argv[4], header=F, col.names=columns)
  d4$type = "consensus2 gets"
  d4$op = "get"
  d4['Sequence'] <- rownames(d4)
  time_min <- min(time_min, d4$Time)
  time_max <- max(time_max, d4$Time)
  time_max999th <- max(time_max999th, quantile(d4$Time, c(0.999)), na.rm=TRUE)
  d <- rbind(d1, d2, d3, d4)
  c2 <- rbind(d2, d4)

  print(summary(d4))
  print(paste("Sum of op measurements: ", sum(d4$Time)/1000000, " seconds"))
}

library(ggplot2)

png(file="consensus-cdf.png", height=800, width=800, pointsize=12)

xlabel <- expression(paste("Log of Op Latency (", mu, "s)"))
p <- ggplot(d, aes(Time, colour=type))
p + stat_ecdf(size=2) +
    ylab("Empirical CDF") +
    scale_x_log10(xlabel, limits=c(time_min, time_max999th))

dev.off()

png(file="consensus-pdf.png", height=800, width=800, pointsize=12)

xlabel <- expression(paste("Log of Op Latency (", mu, "s)"))
p <- ggplot(d, aes(Time, fill=factor(type)))
p + stat_density(size=2) +
    scale_fill_discrete(name = "Operation Type") +
    ylab("Empirical Density") +
    scale_x_log10(xlabel, limits=c(time_min, time_max999th))

dev.off()

png(file="consensus1-timeseries.png", height=800, width=800, pointsize=12)

ylabel <- expression(paste("Log of Op Latency (", mu, "s)"))
p <- ggplot(c1, aes(x=Sequence, y=Time, colour=factor(op)))
p + geom_point() +
    scale_y_log10(ylabel)

dev.off()

png(file="consensus2-timeseries.png", height=800, width=800, pointsize=12)

ylabel <- expression(paste("Log of Op Latency (", mu, "s)"))
p <- ggplot(c2, aes(x=Sequence, y=Time, colour=factor(op)))
p + geom_point() +
    scale_y_log10(ylabel)

dev.off()
