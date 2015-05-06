#!/usr/bin/env Rscript
require(data.table)
require(hexbin)

argv <- commandArgs(TRUE)

usage <- function() {
	print("Usage: plot* <data1> <data2> <data3> <data4> <data5> <data6> <data7> <data8>")
	quit()
}

if (length(argv) < 1) {
	usage()
}

d1name <- argv[1]
d1 <- fread(d1name)
d1tshifted <- d1$V1 - min(d1$V1)
maxt <- max(d1tshifted)
hbinsd1 <- hexbin(d1tshifted, log(d1$V10), xbins=100)
srtt_min <- min(d1$V10)
srtt_max <- max(d1$V10)
srtt_max9999th <- quantile(d1$V10, c(0.9999))
srtt_min0001st <- quantile(d1$V10, c(0.0001))

if (length(argv) > 1) {
	d2name <- argv[2]
	d2 <- fread(d2name)
	d2tshifted <- d2$V1 - min(d2$V1)
	maxt <- max(maxt, d2tshifted)
	srtt_max <- max(srtt_max, d2$V10)
	srtt_max9999th <- max(srtt_max9999th, quantile(d2$V10, c(0.99)))
	srtt_min0001st <- min(srtt_min0001st, quantile(d2$V10, c(0.01)))
}

if (length(argv) > 2) {
	d3name <- argv[3]
	d3 <- fread(d3name)
	d3tshifted <- d3$V1 - min(d3$V1)
	maxt <- max(maxt, d3tshifted)
	srtt_max <- max(srtt_max, d3$V10)
	srtt_max9999th <- max(srtt_max9999th, quantile(d3$V10, c(0.99)))
	srtt_min0001st <- min(srtt_min0001st, quantile(d3$V10, c(0.01)))
}

if (length(argv) > 3) {
	d4name <- argv[4]
	d4 <- fread(d4name)
	d4tshifted <- d4$V1 - min(d4$V1)
	maxt <- max(maxt, d4tshifted)
	srtt_max <- max(srtt_max, d4$V10)
	srtt_max9999th <- max(srtt_max9999th, quantile(d4$V10, c(0.99)))
	srtt_min0001st <- min(srtt_min0001st, quantile(d4$V10, c(0.01)))
}

if (length(argv) > 4) {
	d5name <- argv[5]
	d5 <- fread(d5name)
	d5tshifted <- d5$V1 - min(d5$V1)
	maxt <- max(maxt, d5tshifted)
	srtt_max <- max(srtt_max, d5$V10)
	srtt_max9999th <- max(srtt_max9999th, quantile(d5$V10, c(0.99)))
	srtt_min0001st <- min(srtt_min0001st, quantile(d5$V10, c(0.01)))
}

if (length(argv) > 5) {
	d6name <- argv[6]
	d6 <- fread(d6name)
	d6tshifted <- d6$V1 - min(d6$V1)
	maxt <- max(maxt, d6tshifted)
	srtt_max <- max(srtt_max, d6$V10)
	srtt_max9999th <- max(srtt_max9999th, quantile(d6$V10, c(0.99)))
	srtt_min0001st <- min(srtt_min0001st, quantile(d6$V10, c(0.01)))
}

if (length(argv) > 6) {
	d7name <- argv[7]
	d7 <- fread(d7name)
	d7tshifted <- d7$V1 - min(d7$V1)
	maxt <- max(maxt, d7tshifted)
	srtt_max <- max(srtt_max, d7$V10)
	srtt_max9999th <- max(srtt_max9999th, quantile(d7$V10, c(0.99)))
	srtt_min0001st <- min(srtt_min0001st, quantile(d7$V10, c(0.01)))
}

if (length(argv) > 7) {
	d8name <- argv[8]
	d8 <- fread(d8name)
	d8tshifted <- d8$V1 - min(d8$V1)
	maxt <- max(maxt, d7tshifted)
	srtt_max <- max(srtt_max, d8$V10)
	srtt_max9999th <- max(srtt_max9999th, quantile(d8$V10, c(0.99)))
	srtt_min0001st <- min(srtt_min0001st, quantile(d8$V10, c(0.01)))
}

png(file="srtt.png", height=900, width=1500, pointsize=12)

plot(hbinsd1, xlab="Time (s)", ylab="Log of Smoothed RTT (us)")
 
# Turn off device driver (to flush output)
dev.off()

colors <- c("red", "darkolivegreen3", "cornflowerblue", "plum4", "darksalmon", "aquamarine", "darkgoldenrod1", "black")
ltys <- rep(1:8)
pchs <- rep(1:8)

png(file="srtt-cdf.png", height=800, width=800, pointsize=12)
plot(1, 1, xlab="Smoothed RTT (us)", ylab="Probability", xlim=c(max(1, srtt_min0001st), srtt_max9999th), ylim=c(0, 1),
	log="x", type="n", axes=F, ann=T)

lines(ecdf(d1$V10), lw=2, lty=1, pch=1, col=colors[1])
if (length(argv) > 1) {
	lines(ecdf(d2$V10), lw=2, lty=2, pch=2, col=colors[2])
}
if (length(argv) > 2) {
	lines(ecdf(d3$V10), lw=2, lty=3, pch=3, col=colors[3])
}
if (length(argv) > 3) {
	lines(ecdf(d4$V10), lw=2, lty=4, pch=4, col=colors[4])
}
if (length(argv) > 4) {
	lines(ecdf(d5$V10), lw=2, lty=5, pch=5, col=colors[5])
}
if (length(argv) > 5) {
	lines(ecdf(d6$V10), lw=2, lty=6, pch=6, col=colors[6])
}
if (length(argv) > 6) {
	lines(ecdf(d7$V10), lw=2, lty=7, pch=7, col=colors[7])
}
if (length(argv) > 7) {
	lines(ecdf(d8$V10), lw=2, lty=8, pch=8, col=colors[8])
}

axis(1, las=1, cex.axis=1.0)
axis(2, las=1, cex.axis=1.0)

legend("bottomright", argv, cex=1.0,
	col=colors[1:length(argv)],
	lty=ltys[1:length(argv)], pch=pchs[1:length(argv)], lwd=3, bty="n");

dev.off()
