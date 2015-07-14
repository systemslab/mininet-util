#!/usr/bin/env Rscript
#require(data.table)

argv <- commandArgs(TRUE)

usage <- function() {
	print("Usage: plot* <rtt_min (us)> <data>+")
	quit()
}

if (length(argv) < 2) {
	usage()
}

rtt_min <- as.numeric(argv[1])
rtt_scale <- 1
rtt_units <- "(us)"

if (rtt_min > 1000) {
	rtt_scale <- 1000
	rtt_min <- rtt_min / rtt_scale
	rtt_units <- "(ms)"
}

tcpprobenames <- argv[-1]
n <- length(tcpprobenames)

probe_columns <- c("Time", "src", "dst", "length", "snd_next", "snd_una", "cwnd", "ssthresh", "snd_wnd", "SRTT", "rcv_wnd")

tcpprobename <- argv[2]
d1 <- read.table(tcpprobename, head=F, col.names=probe_columns)
d1tshifted <- d1$Time - min(d1$Time, na.rm=TRUE)
maxt <- max(d1tshifted, na.rm=TRUE)

colors <- c("red", "darkolivegreen3", "cornflowerblue", "plum4", "darksalmon", "aquamarine", "darkgoldenrod1", "black")
ltys <- rep(1:8)
pchs <- rep(1:8)

if (n == 1) {
	require(hexbin)
	hbinsd1 <- hexbin(d1tshifted, d1$SRTT / rtt_scale, xbins=100)
	png(file="srtt-hex.png", height=900, width=1500, pointsize=12)
	plot(hbinsd1, xlab="Time (s)", ylab=paste("SRTT\n", rtt_units))
}

srtt_min <- min(d1$SRTT, na.rm=TRUE) / rtt_scale
srtt_max <- max(d1$SRTT, na.rm=TRUE) / rtt_scale
srtt_max99999th <- quantile(d1$SRTT, c(0.99999)) / rtt_scale
srtt_min00001st <- quantile(d1$SRTT, c(0.00001)) / rtt_scale

if (n > 1) {
	tcpprobename <- argv[3]
	d2 <- read.table(tcpprobename, head=F, col.names=probe_columns)
	d2tshifted <- d2$Time - min(d2$Time, na.rm=TRUE)
	maxt <- max(maxt, d2tshifted, na.rm=TRUE)
	srtt_max <- max(srtt_max, d2$SRTT, na.rm=TRUE) / rtt_scale
	srtt_max99999th <- max(srtt_max99999th, quantile(d2$SRTT, c(0.99999)), na.rm=TRUE) / rtt_scale
	srtt_min00001st <- min(srtt_min00001st, quantile(d2$SRTT, c(0.00001)), na.rm=TRUE) / rtt_scale
}

if (n > 2) {
	tcpprobename <- argv[4]
	d3 <- read.table(tcpprobename, head=F, col.names=probe_columns)
	d3tshifted <- d3$Time - min(d3$Time)
	maxt <- max(maxt, d3tshifted)
	srtt_max <- max(srtt_max, d3$SRTT, na.rm=TRUE) / rtt_scale
	srtt_max99999th <- max(srtt_max99999th, quantile(d3$SRTT, c(0.99999)), na.rm=TRUE) / rtt_scale
	srtt_min00001st <- min(srtt_min00001st, quantile(d3$SRTT, c(0.00001)), na.rm=TRUE) / rtt_scale
}

if (n > 3) {
	tcpprobename <- argv[5]
	d4 <- read.table(tcpprobename, head=F, col.names=probe_columns)
	d4tshifted <- d4$Time - min(d4$Time)
	maxt <- max(maxt, d4tshifted)
	srtt_max <- max(srtt_max, d4$SRTT, na.rm=TRUE) / rtt_scale
	srtt_max99999th <- max(srtt_max99999th, quantile(d4$SRTT, c(0.99999)), na.rm=TRUE) / rtt_scale
	srtt_min00001st <- min(srtt_min00001st, quantile(d4$SRTT, c(0.00001)), na.rm=TRUE) / rtt_scale
}

if (n > 4) {
	tcpprobename <- argv[6]
	d5 <- read.table(tcpprobename, head=F, col.names=probe_columns)
	d5tshifted <- d5$Time - min(d5$Time)
	maxt <- max(maxt, d5tshifted)
	srtt_max <- max(srtt_max, d5$SRTT, na.rm=TRUE) / rtt_scale
	srtt_max99999th <- max(srtt_max99999th, quantile(d5$SRTT, c(0.99999)), na.rm=TRUE) / rtt_scale
	srtt_min00001st <- min(srtt_min00001st, quantile(d5$SRTT, c(0.00001)), na.rm=TRUE) / rtt_scale
}

if (n > 5) {
	tcpprobename <- argv[7]
	d6 <- read.table(tcpprobename, head=F, col.names=probe_columns)
	d6tshifted <- d6$Time - min(d6$Time)
	maxt <- max(maxt, d6tshifted)
	srtt_max <- max(srtt_max, d6$SRTT, na.rm=TRUE) / rtt_scale
	srtt_max99999th <- max(srtt_max99999th, quantile(d6$SRTT, c(0.99999)), na.rm=TRUE) / rtt_scale
	srtt_min00001st <- min(srtt_min00001st, quantile(d6$SRTT, c(0.00001)), na.rm=TRUE) / rtt_scale
}

if (n > 6) {
	tcpprobename <- argv[8]
	d7 <- read.table(tcpprobename, head=F, col.names=probe_columns)
	d7tshifted <- d7$Time - min(d7$Time)
	maxt <- max(maxt, d7tshifted)
	srtt_max <- max(srtt_max, d7$SRTT, na.rm=TRUE) / rtt_scale
	srtt_max99999th <- max(srtt_max99999th, quantile(d7$SRTT, c(0.99999)), na.rm=TRUE) / rtt_scale
	srtt_min00001st <- min(srtt_min00001st, quantile(d7$SRTT, c(0.00001)), na.rm=TRUE) / rtt_scale
}

if (n > 7) {
	tcpprobename <- argv[9]
	d8 <- read.table(tcpprobename, head=F, col.names=probe_columns)
	d8tshifted <- d8$Time - min(d8$Time)
	maxt <- max(maxt, d7tshifted)
	srtt_max <- max(srtt_max, d8$SRTT, na.rm=TRUE) / rtt_scale
	srtt_max99999th <- max(srtt_max99999th, quantile(d8$SRTT, c(0.99999)), na.rm=TRUE) / rtt_scale
	srtt_min00001st <- min(srtt_min00001st, quantile(d8$SRTT, c(0.00001)), na.rm=TRUE) / rtt_scale
}

png(file="srtt.png", height=900, width=1500, pointsize=12)
plot(d1tshifted, d1$SRTT / rtt_scale, type="o", col=colors[1], lty=0, pch=1, lwd=1, cex=0.5,
	axes=F, ann=T, xlab="Time (s)", ylab=paste("Log of Smoothed RTT", rtt_units),
	log="y", xlim=c(0, min(maxt, max(d1tshifted))), ylim=c(rtt_min, srtt_max))

if (n > 1) {
	lines(d2tshifted, d2$SRTT / rtt_scale, type="o", lty=2, pch=2, lw=1, cex=0.5, col=colors[2])
}
if (n > 2) {
	lines(d3tshifted, d3$SRTT / rtt_scale, type="o", lty=3, pch=3, lw=1, cex=0.5, col=colors[3])
}
if (n > 3) {
	lines(d4tshifted, d4$SRTT / rtt_scale, type="o", lty=4, pch=4, lw=1, cex=0.5, col=colors[4])
}
if (n > 4) {
	lines(d5tshifted, d5$SRTT / rtt_scale, type="o", lty=5, pch=5, lw=1, cex=0.5, col=colors[5])
}
if (n > 5) {
	lines(d6tshifted, d6$SRTT / rtt_scale, type="o", lty=6, pch=6, lw=1, cex=0.5, col=colors[6])
}
if (n > 6) {
	lines(d7tshifted, d7$SRTT / rtt_scale, type="o", lty=7, pch=7, lw=1, cex=0.5, col=colors[7])
}
if (n > 7) {
	lines(d8tshifted, d8$SRTT / rtt_scale, type="o", lty=8, pch=8, lw=1, cex=0.5, col=colors[8])
}

legend("topright", tcpprobenames, cex=1.0, col=colors[1:n],
	lty=ltys[1:n], pch=pchs[1:n], lwd=3, bty="n");

axis(1, las=1, cex.axis=1.0)
axis(2, las=1, cex.axis=1.0)

# Turn off device driver (to flush output)
dev.off()

png(file="srtt-cdf.png", height=800, width=800, pointsize=12)
plot(1, 1, xlab=paste("Log of Smoothed RTT", rtt_units), ylab="Probability", xlim=c(rtt_min, srtt_max99999th), ylim=c(0, 1),
	log="x", type="n", axes=F, ann=T)

lines(ecdf(d1$SRTT / rtt_scale), lw=2, lty=1, pch=1, col=colors[1])
if (n > 1) {
	lines(ecdf(d2$SRTT / rtt_scale), lw=2, lty=2, pch=2, col=colors[2])
}
if (n > 2) {
	lines(ecdf(d3$SRTT / rtt_scale), lw=2, lty=3, pch=3, col=colors[3])
}
if (n > 3) {
	lines(ecdf(d4$SRTT / rtt_scale), lw=2, lty=4, pch=4, col=colors[4])
}
if (n > 4) {
	lines(ecdf(d5$SRTT / rtt_scale), lw=2, lty=5, pch=5, col=colors[5])
}
if (n > 5) {
	lines(ecdf(d6$SRTT / rtt_scale), lw=2, lty=6, pch=6, col=colors[6])
}
if (n > 6) {
	lines(ecdf(d7$SRTT / rtt_scale), lw=2, lty=7, pch=7, col=colors[7])
}
if (n > 7) {
	lines(ecdf(d8$SRTT / rtt_scale), lw=2, lty=8, pch=8, col=colors[8])
}

axis(1, las=1, cex.axis=1.0)
axis(2, las=1, cex.axis=1.0)

legend("bottomright", tcpprobenames, cex=1.0,
	col=colors[1:n],
	lty=ltys[1:n], pch=pchs[1:n], lwd=3, bty="n");

dev.off()
