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

#library(RColorBrewer)
# colors <- c("red", "darkolivegreen3", "cornflowerblue", "plum4", "darksalmon", "aquamarine", "darkgoldenrod1", "black")
#colors <- brewer.pal(11, "Paired")

colors = c("#C8C44A",
"#AB83CF",
"#66DCCA",
"#5F7651",
"#5EDF81",
"#6E738E",
"#C4D0C8",
"#63A138",
"#81E14C",
"#71C3DC",
"#C8B6DA",
"#6994D1",
"#548C89",
"#BEDF81",
"#77822B",
"#4F9960",
"#A6AE7D",
"#6ED79F",
"#CAE5B6",
"#CFE139")

ltys <- rep(1:20)
pchs <- rep(1:20)

srtt_min <- min(d1$SRTT, na.rm=TRUE)
srtt_max <- max(d1$SRTT, na.rm=TRUE)
srtt_99999th <- quantile(d1$SRTT, c(0.99999))
srtt_00001st <- quantile(d1$SRTT, c(0.00001))
print(paste(tcpprobename, "max", srtt_max))
print(paste(tcpprobename, "99th", quantile(d1$SRTT, c(0.99))))
print(paste(tcpprobename, "99.9th", quantile(d1$SRTT, c(0.999))))
print(paste(tcpprobename, "99.99th", quantile(d1$SRTT, c(0.9999))))
print(paste(tcpprobename, "99th latency index", rtt_min / quantile(d1$SRTT, c(0.99)) * rtt_scale))
print(paste(tcpprobename, "99th latency log index", log10(rtt_min * rtt_scale) / log10(quantile(d1$SRTT, c(0.99)))))

if (n > 1) {
	tcpprobename <- argv[3]
	d2 <- read.table(tcpprobename, head=F, col.names=probe_columns)
	d2tshifted <- d2$Time - min(d2$Time, na.rm=TRUE)
	maxt <- max(maxt, d2tshifted, na.rm=TRUE)
	srtt_max <- max(srtt_max, d2$SRTT, na.rm=TRUE)
	srtt_99999th <- max(srtt_99999th, quantile(d2$SRTT, c(0.99999)), na.rm=TRUE)
	srtt_00001st <- min(srtt_00001st, quantile(d2$SRTT, c(0.00001)), na.rm=TRUE)
        print(paste(tcpprobename, "max", max(d2$SRTT, na.rm=TRUE)))
	print(paste(tcpprobename, "99th", quantile(d2$SRTT, c(0.99))))
	print(paste(tcpprobename, "99.9th", quantile(d2$SRTT, c(0.999))))
	print(paste(tcpprobename, "99.99th", quantile(d2$SRTT, c(0.9999))))
	print(paste(tcpprobename, "99th latency index", rtt_min / quantile(d2$SRTT, c(0.99)) * rtt_scale))
        print(paste(tcpprobename, "99th latency log index", log10(rtt_min * rtt_scale) / log10(quantile(d2$SRTT, c(0.99)))))
}

if (n > 2) {
	tcpprobename <- argv[4]
	d3 <- read.table(tcpprobename, head=F, col.names=probe_columns)
	d3tshifted <- d3$Time - min(d3$Time)
	maxt <- max(maxt, d3tshifted)
	srtt_max <- max(srtt_max, d3$SRTT, na.rm=TRUE)
	srtt_99999th <- max(srtt_99999th, quantile(d3$SRTT, c(0.99999)), na.rm=TRUE)
	srtt_00001st <- min(srtt_00001st, quantile(d3$SRTT, c(0.00001)), na.rm=TRUE)
        print(paste(tcpprobename, "max", max(d3$SRTT, na.rm=TRUE)))
	print(paste(tcpprobename, "99th", quantile(d3$SRTT, c(0.99))))
	print(paste(tcpprobename, "99.9th", quantile(d3$SRTT, c(0.999))))
	print(paste(tcpprobename, "99.99th", quantile(d3$SRTT, c(0.9999))))
	print(paste(tcpprobename, "99th latency index", rtt_min / quantile(d3$SRTT, c(0.99)) * rtt_scale))
        print(paste(tcpprobename, "99th latency log index", log10(rtt_min * rtt_scale) / log10(quantile(d3$SRTT, c(0.99)))))
}

if (n > 3) {
	tcpprobename <- argv[5]
	d4 <- read.table(tcpprobename, head=F, col.names=probe_columns)
	d4tshifted <- d4$Time - min(d4$Time)
	maxt <- max(maxt, d4tshifted)
	srtt_max <- max(srtt_max, d4$SRTT, na.rm=TRUE)
	srtt_99999th <- max(srtt_99999th, quantile(d4$SRTT, c(0.99999)), na.rm=TRUE)
	srtt_00001st <- min(srtt_00001st, quantile(d4$SRTT, c(0.00001)), na.rm=TRUE)
        print(paste(tcpprobename, "max", max(d4$SRTT, na.rm=TRUE)))
	print(paste(tcpprobename, "99th", quantile(d4$SRTT, c(0.99))))
	print(paste(tcpprobename, "99.9th", quantile(d4$SRTT, c(0.999))))
	print(paste(tcpprobename, "99.99th", quantile(d4$SRTT, c(0.9999))))
	print(paste(tcpprobename, "99th latency index", rtt_min / quantile(d4$SRTT, c(0.99)) * rtt_scale))
        print(paste(tcpprobename, "99th latency log index", log10(rtt_min * rtt_scale) / log10(quantile(d4$SRTT, c(0.99)))))
}

if (n > 4) {
	tcpprobename <- argv[6]
	d5 <- read.table(tcpprobename, head=F, col.names=probe_columns)
	d5tshifted <- d5$Time - min(d5$Time)
	maxt <- max(maxt, d5tshifted)
	srtt_max <- max(srtt_max, d5$SRTT, na.rm=TRUE)
	srtt_99999th <- max(srtt_99999th, quantile(d5$SRTT, c(0.99999)), na.rm=TRUE)
	srtt_00001st <- min(srtt_00001st, quantile(d5$SRTT, c(0.00001)), na.rm=TRUE)
        print(paste(tcpprobename, "max", max(d5$SRTT, na.rm=TRUE)))
	print(paste(tcpprobename, "99th", quantile(d5$SRTT, c(0.99))))
	print(paste(tcpprobename, "99.99th", quantile(d5$SRTT, c(0.999))))
	print(paste(tcpprobename, "99.9th", quantile(d5$SRTT, c(0.9999))))
	print(paste(tcpprobename, "99th latency index", rtt_min / quantile(d5$SRTT, c(0.99)) * rtt_scale))
        print(paste(tcpprobename, "99th latency log index", log10(rtt_min * rtt_scale) / log10(quantile(d5$SRTT, c(0.99)))))
}

if (n > 5) {
	tcpprobename <- argv[7]
	d6 <- read.table(tcpprobename, head=F, col.names=probe_columns)
	d6tshifted <- d6$Time - min(d6$Time)
	maxt <- max(maxt, d6tshifted)
	srtt_max <- max(srtt_max, d6$SRTT, na.rm=TRUE)
	srtt_99999th <- max(srtt_99999th, quantile(d6$SRTT, c(0.99999)), na.rm=TRUE)
	srtt_00001st <- min(srtt_00001st, quantile(d6$SRTT, c(0.00001)), na.rm=TRUE)
        print(paste(tcpprobename, "max", max(d6$SRTT, na.rm=TRUE)))
	print(paste(tcpprobename, "99th", quantile(d6$SRTT, c(0.99))))
	print(paste(tcpprobename, "99.9th", quantile(d6$SRTT, c(0.999))))
	print(paste(tcpprobename, "99.99th", quantile(d6$SRTT, c(0.9999))))
	print(paste(tcpprobename, "99th latency index", rtt_min / quantile(d6$SRTT, c(0.99)) * rtt_scale))
        print(paste(tcpprobename, "99th latency log index", log10(rtt_min * rtt_scale) / log10(quantile(d6$SRTT, c(0.99)))))
}

if (n > 6) {
	tcpprobename <- argv[8]
	d7 <- read.table(tcpprobename, head=F, col.names=probe_columns)
	d7tshifted <- d7$Time - min(d7$Time)
	maxt <- max(maxt, d7tshifted)
	srtt_max <- max(srtt_max, d7$SRTT, na.rm=TRUE)
	srtt_99999th <- max(srtt_99999th, quantile(d7$SRTT, c(0.99999)), na.rm=TRUE)
	srtt_00001st <- min(srtt_00001st, quantile(d7$SRTT, c(0.00001)), na.rm=TRUE)
        print(paste(tcpprobename, "max", max(d7$SRTT, na.rm=TRUE)))
	print(paste(tcpprobename, "99th", quantile(d7$SRTT, c(0.99))))
	print(paste(tcpprobename, "99.9th", quantile(d7$SRTT, c(0.999))))
	print(paste(tcpprobename, "99.99th", quantile(d7$SRTT, c(0.9999))))
	print(paste(tcpprobename, "99th latency index", rtt_min / quantile(d7$SRTT, c(0.99)) * rtt_scale))
        print(paste(tcpprobename, "99th latency log index", log10(rtt_min * rtt_scale) / log10(quantile(d7$SRTT, c(0.99)))))
}

if (n > 7) {
	tcpprobename <- argv[9]
	d8 <- read.table(tcpprobename, head=F, col.names=probe_columns)
	d8tshifted <- d8$Time - min(d8$Time)
	maxt <- max(maxt, d8tshifted)
	srtt_max <- max(srtt_max, d8$SRTT, na.rm=TRUE)
	srtt_99999th <- max(srtt_99999th, quantile(d8$SRTT, c(0.99999)), na.rm=TRUE)
	srtt_00001st <- min(srtt_00001st, quantile(d8$SRTT, c(0.00001)), na.rm=TRUE)
        print(paste(tcpprobename, "max", max(d8$SRTT, na.rm=TRUE)))
	print(paste(tcpprobename, "99th", quantile(d8$SRTT, c(0.99))))
	print(paste(tcpprobename, "99.9th", quantile(d8$SRTT, c(0.999))))
	print(paste(tcpprobename, "99.99th", quantile(d8$SRTT, c(0.9999))))
	print(paste(tcpprobename, "99th latency index", rtt_min / quantile(d8$SRTT, c(0.99)) * rtt_scale))
        print(paste(tcpprobename, "99th latency log index", log10(rtt_min * rtt_scale) / log10(quantile(d8$SRTT, c(0.99)))))
}

if (n > 8) {
	tcpprobename <- argv[10]
	d9 <- read.table(tcpprobename, head=F, col.names=probe_columns)
	d9tshifted <- d9$Time - min(d9$Time)
	maxt <- max(maxt, d9tshifted)
	srtt_max <- max(srtt_max, d9$SRTT, na.rm=TRUE)
	srtt_99999th <- max(srtt_99999th, quantile(d9$SRTT, c(0.99999)), na.rm=TRUE)
	srtt_00001st <- min(srtt_00001st, quantile(d9$SRTT, c(0.00001)), na.rm=TRUE)
        print(paste(tcpprobename, "max", max(d9$SRTT, na.rm=TRUE)))
	print(paste(tcpprobename, "99th", quantile(d9$SRTT, c(0.99))))
	print(paste(tcpprobename, "99.9th", quantile(d9$SRTT, c(0.999))))
	print(paste(tcpprobename, "99.99th", quantile(d9$SRTT, c(0.9999))))
	print(paste(tcpprobename, "99th latency index", rtt_min / quantile(d9$SRTT, c(0.99)) * rtt_scale))
        print(paste(tcpprobename, "99th latency log index", log10(rtt_min * rtt_scale) / log10(quantile(d9$SRTT, c(0.99)))))
}

if (n > 9) {
	tcpprobename <- argv[11]
	d10 <- read.table(tcpprobename, head=F, col.names=probe_columns)
	d10tshifted <- d10$Time - min(d10$Time)
	maxt <- max(maxt, d10tshifted)
	srtt_max <- max(srtt_max, d10$SRTT, na.rm=TRUE)
	srtt_99999th <- max(srtt_99999th, quantile(d10$SRTT, c(0.99999)), na.rm=TRUE)
	srtt_00001st <- min(srtt_00001st, quantile(d10$SRTT, c(0.00001)), na.rm=TRUE)
        print(paste(tcpprobename, "max", max(d10$SRTT, na.rm=TRUE)))
	print(paste(tcpprobename, "99th", quantile(d10$SRTT, c(0.99))))
	print(paste(tcpprobename, "99.9th", quantile(d10$SRTT, c(0.999))))
	print(paste(tcpprobename, "99.99th", quantile(d10$SRTT, c(0.9999))))
	print(paste(tcpprobename, "99th latency index", rtt_min / quantile(d10$SRTT, c(0.99)) * rtt_scale))
        print(paste(tcpprobename, "99th latency log index", log10(rtt_min * rtt_scale) / log10(quantile(d10$SRTT, c(0.99)))))
}

if (n > 10) {
	tcpprobename <- argv[12]
	d11 <- read.table(tcpprobename, head=F, col.names=probe_columns)
	d11tshifted <- d11$Time - min(d11$Time)
	maxt <- max(maxt, d11tshifted)
	srtt_max <- max(srtt_max, d11$SRTT, na.rm=TRUE)
	srtt_99999th <- max(srtt_99999th, quantile(d11$SRTT, c(0.99999)), na.rm=TRUE)
	srtt_00001st <- min(srtt_00001st, quantile(d11$SRTT, c(0.00001)), na.rm=TRUE)
        print(paste(tcpprobename, "max", max(d11$SRTT, na.rm=TRUE)))
	print(paste(tcpprobename, "99th", quantile(d11$SRTT, c(0.99))))
	print(paste(tcpprobename, "99.9th", quantile(d11$SRTT, c(0.999))))
	print(paste(tcpprobename, "99.99th", quantile(d11$SRTT, c(0.9999))))
	print(paste(tcpprobename, "99th latency index", rtt_min / quantile(d11$SRTT, c(0.99)) * rtt_scale))
        print(paste(tcpprobename, "99th latency log index", log10(rtt_min * rtt_scale) / log10(quantile(d11$SRTT, c(0.99)))))
}

if (n > 11) {
	tcpprobename <- argv[13]
	d12 <- read.table(tcpprobename, head=F, col.names=probe_columns)
	d12tshifted <- d12$Time - min(d12$Time)
	maxt <- max(maxt, d12tshifted)
	srtt_max <- max(srtt_max, d12$SRTT, na.rm=TRUE)
	srtt_99999th <- max(srtt_99999th, quantile(d12$SRTT, c(0.99999)), na.rm=TRUE)
	srtt_00001st <- min(srtt_00001st, quantile(d12$SRTT, c(0.00001)), na.rm=TRUE)
        print(paste(tcpprobename, "max", max(d12$SRTT, na.rm=TRUE)))
	print(paste(tcpprobename, "99th", quantile(d12$SRTT, c(0.99))))
	print(paste(tcpprobename, "99.9th", quantile(d12$SRTT, c(0.999))))
	print(paste(tcpprobename, "99.99th", quantile(d12$SRTT, c(0.9999))))
	print(paste(tcpprobename, "99th latency index", rtt_min / quantile(d12$SRTT, c(0.99)) * rtt_scale))
        print(paste(tcpprobename, "99th latency log index", log10(rtt_min * rtt_scale) / log10(quantile(d12$SRTT, c(0.99)))))
}

if (n > 12) {
	tcpprobename <- argv[14]
	d13 <- read.table(tcpprobename, head=F, col.names=probe_columns)
	d13tshifted <- d13$Time - min(d13$Time)
	maxt <- max(maxt, d13tshifted)
	srtt_max <- max(srtt_max, d13$SRTT, na.rm=TRUE)
	srtt_99999th <- max(srtt_99999th, quantile(d13$SRTT, c(0.99999)), na.rm=TRUE)
	srtt_00001st <- min(srtt_00001st, quantile(d13$SRTT, c(0.00001)), na.rm=TRUE)
        print(paste(tcpprobename, "max", max(d13$SRTT, na.rm=TRUE)))
	print(paste(tcpprobename, "99th", quantile(d13$SRTT, c(0.99))))
	print(paste(tcpprobename, "99.9th", quantile(d13$SRTT, c(0.999))))
	print(paste(tcpprobename, "99.99th", quantile(d13$SRTT, c(0.9999))))
	print(paste(tcpprobename, "99th latency index", rtt_min / quantile(d13$SRTT, c(0.99)) * rtt_scale))
        print(paste(tcpprobename, "99th latency log index", log10(rtt_min * rtt_scale) / log10(quantile(d13$SRTT, c(0.99)))))
}

if (n > 13) {
	tcpprobename <- argv[15]
	d14 <- read.table(tcpprobename, head=F, col.names=probe_columns)
	d14tshifted <- d14$Time - min(d14$Time)
	maxt <- max(maxt, d14tshifted)
	srtt_max <- max(srtt_max, d14$SRTT, na.rm=TRUE)
	srtt_99999th <- max(srtt_99999th, quantile(d14$SRTT, c(0.99999)), na.rm=TRUE)
	srtt_00001st <- min(srtt_00001st, quantile(d14$SRTT, c(0.00001)), na.rm=TRUE)
        print(paste(tcpprobename, "max", max(d14$SRTT, na.rm=TRUE)))
	print(paste(tcpprobename, "99th", quantile(d14$SRTT, c(0.99))))
	print(paste(tcpprobename, "99.9th", quantile(d14$SRTT, c(0.999))))
	print(paste(tcpprobename, "99.99th", quantile(d14$SRTT, c(0.9999))))
	print(paste(tcpprobename, "99th latency index", rtt_min / quantile(d14$SRTT, c(0.99)) * rtt_scale))
        print(paste(tcpprobename, "99th latency log index", log10(rtt_min * rtt_scale) / log10(quantile(d14$SRTT, c(0.99)))))
}

if (n > 14) {
	tcpprobename <- argv[16]
	d15 <- read.table(tcpprobename, head=F, col.names=probe_columns)
	d15tshifted <- d15$Time - min(d15$Time)
	maxt <- max(maxt, d15tshifted)
	srtt_max <- max(srtt_max, d15$SRTT, na.rm=TRUE)
	srtt_99999th <- max(srtt_99999th, quantile(d15$SRTT, c(0.99999)), na.rm=TRUE)
	srtt_00001st <- min(srtt_00001st, quantile(d15$SRTT, c(0.00001)), na.rm=TRUE)
        print(paste(tcpprobename, "max", max(d15$SRTT, na.rm=TRUE)))
	print(paste(tcpprobename, "99th", quantile(d15$SRTT, c(0.99))))
	print(paste(tcpprobename, "99.9th", quantile(d15$SRTT, c(0.999))))
	print(paste(tcpprobename, "99.99th", quantile(d15$SRTT, c(0.9999))))
	print(paste(tcpprobename, "99th latency index", rtt_min / quantile(d15$SRTT, c(0.99)) * rtt_scale))
        print(paste(tcpprobename, "99th latency log index", log10(rtt_min * rtt_scale) / log10(quantile(d15$SRTT, c(0.99)))))
}

if (n > 15) {
	tcpprobename <- argv[17]
	d16 <- read.table(tcpprobename, head=F, col.names=probe_columns)
	d16tshifted <- d16$Time - min(d16$Time)
	maxt <- max(maxt, d16tshifted)
	srtt_max <- max(srtt_max, d16$SRTT, na.rm=TRUE)
	srtt_99999th <- max(srtt_99999th, quantile(d16$SRTT, c(0.99999)), na.rm=TRUE)
	srtt_00001st <- min(srtt_00001st, quantile(d16$SRTT, c(0.00001)), na.rm=TRUE)
        print(paste(tcpprobename, "max", max(d16$SRTT, na.rm=TRUE)))
	print(paste(tcpprobename, "99th", quantile(d16$SRTT, c(0.99))))
	print(paste(tcpprobename, "99.9th", quantile(d16$SRTT, c(0.999))))
	print(paste(tcpprobename, "99.99th", quantile(d16$SRTT, c(0.9999))))
	print(paste(tcpprobename, "99th latency index", rtt_min / quantile(d16$SRTT, c(0.99)) * rtt_scale))
        print(paste(tcpprobename, "99th latency log index", log10(rtt_min * rtt_scale) / log10(quantile(d16$SRTT, c(0.99)))))
}

png(file="srtt.png", height=900, width=1500, pointsize=12)
plot(d1tshifted, d1$SRTT / rtt_scale, type="o", col=colors[1], lty=0, pch=1, lwd=1, cex=0.5,
	axes=F, ann=T, xlab="Time (s)", ylab=paste("Log of Smoothed RTT", rtt_units),
	log="y", xlim=c(0, min(maxt, max(d1tshifted))), ylim=c(rtt_min, srtt_max / rtt_scale))

if (n > 1) {
	lines(d2tshifted, d2$SRTT / rtt_scale, type="o", lty=0, pch=2, lw=1, cex=0.5, col=colors[2])
}
if (n > 2) {
	lines(d3tshifted, d3$SRTT / rtt_scale, type="o", lty=0, pch=3, lw=1, cex=0.5, col=colors[3])
}
if (n > 3) {
	lines(d4tshifted, d4$SRTT / rtt_scale, type="o", lty=0, pch=4, lw=1, cex=0.5, col=colors[4])
}
if (n > 4) {
	lines(d5tshifted, d5$SRTT / rtt_scale, type="o", lty=0, pch=5, lw=1, cex=0.5, col=colors[5])
}
if (n > 5) {
	lines(d6tshifted, d6$SRTT / rtt_scale, type="o", lty=0, pch=6, lw=1, cex=0.5, col=colors[6])
}
if (n > 6) {
	lines(d7tshifted, d7$SRTT / rtt_scale, type="o", lty=0, pch=7, lw=1, cex=0.5, col=colors[7])
}
if (n > 7) {
	lines(d8tshifted, d8$SRTT / rtt_scale, type="o", lty=0, pch=8, lw=1, cex=0.5, col=colors[8])
}
if (n > 8) {
	lines(d9tshifted, d9$SRTT / rtt_scale, type="o", lty=0, pch=8, lw=1, cex=0.5, col=colors[9])
}
if (n > 9) {
	lines(d10tshifted, d10$SRTT / rtt_scale, type="o", lty=0, pch=8, lw=1, cex=0.5, col=colors[10])
}
if (n > 10) {
	lines(d11tshifted, d11$SRTT / rtt_scale, type="o", lty=0, pch=8, lw=1, cex=0.5, col=colors[11])
}
if (n > 11) {
	lines(d12tshifted, d12$SRTT / rtt_scale, type="o", lty=0, pch=8, lw=1, cex=0.5, col=colors[12])
}
if (n > 12) {
	lines(d13tshifted, d13$SRTT / rtt_scale, type="o", lty=0, pch=8, lw=1, cex=0.5, col=colors[12])
}
if (n > 13) {
	lines(d14tshifted, d14$SRTT / rtt_scale, type="o", lty=0, pch=8, lw=1, cex=0.5, col=colors[12])
}
if (n > 14) {
	lines(d15tshifted, d15$SRTT / rtt_scale, type="o", lty=0, pch=8, lw=1, cex=0.5, col=colors[12])
}
if (n > 15) {
	lines(d16tshifted, d16$SRTT / rtt_scale, type="o", lty=0, pch=8, lw=1, cex=0.5, col=colors[12])
}

legend("topright", tcpprobenames, cex=1.0, col=colors[1:n],
	lty=ltys[1:n], pch=pchs[1:n], lwd=3, bty="n");

axis(1, las=1, cex.axis=1.0)
axis(2, las=1, cex.axis=1.0)

# Turn off device driver (to flush output)
dev.off()

print(paste("rtt min, srtt_00001st srtt_99999th", rtt_min, srtt_00001st, srtt_99999th))

png(file="srtt-cdf.png", height=800, width=800, pointsize=18)
plot(1, 1, xlab=paste("Log of Smoothed RTT", rtt_units), ylab="ECDF(SRTT)", xlim=c(rtt_min, srtt_99999th / rtt_scale), ylim=c(0, 1),
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
if (n > 8) {
	lines(ecdf(d9$SRTT / rtt_scale), lw=2, lty=9, pch=9, col=colors[9])
}
if (n > 9) {
	lines(ecdf(d10$SRTT / rtt_scale), lw=2, lty=10, pch=10, col=colors[10])
}
if (n > 10) {
	lines(ecdf(d11$SRTT / rtt_scale), lw=2, lty=11, pch=11, col=colors[11])
}
if (n > 11) {
	lines(ecdf(d12$SRTT / rtt_scale), lw=2, lty=12, pch=12, col=colors[12])
}
if (n > 12) {
	lines(ecdf(d13$SRTT / rtt_scale), lw=2, lty=12, pch=12, col=colors[12])
}
if (n > 13) {
	lines(ecdf(d14$SRTT / rtt_scale), lw=2, lty=12, pch=12, col=colors[12])
}
if (n > 14) {
	lines(ecdf(d15$SRTT / rtt_scale), lw=2, lty=12, pch=12, col=colors[12])
}
if (n > 15) {
	lines(ecdf(d16$SRTT / rtt_scale), lw=2, lty=12, pch=12, col=colors[12])
}

axis(1, las=1, cex.axis=1.0)
axis(2, las=1, cex.axis=1.0)

legend("bottomright", tcpprobenames, cex=1.0,
	col=colors[1:n],
	lty=ltys[1:n], pch=pchs[1:n], lwd=3, bty="n");

# From Nathan:
# Putting the SRTTs into 1 DF:
#
# > tcpprobename <- "cdg+rcv_cc"
# > d1 <- read.table(tcpprobename, head=F, col.names=probe_columns)
# > tcpprobename <- "cubic+rcv_cc"
# > d2 <- read.table(tcpprobename, head=F, col.names=probe_columns)
# > d1$type="A"
# > d2$type="B"
# . . . for all small frames
# > d3 <- rbind(d1, d2) # this makes 1 big frame
#
# plot it as ECDF
# ggplot(d3, aes(SRTT/1000, colour=type)) + stat_ecdf(size=0.5)

dev.off()
