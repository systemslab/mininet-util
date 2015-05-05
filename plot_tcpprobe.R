#!/usr/bin/env Rscript

argv <- commandArgs(TRUE)

usage <- function() {
	print("Usage: plot* <data1> <data2> <data3> <data4> <data5> <data6> <data7> <data8>")
	quit()
}

if (length(argv) < 1) {
	usage()
}

t <- list()
srtts <- list()

d1name <- argv[1]
d1 <- read.table(d1name, sep=" ", header=F)
d1tshifted <- d1$V1 - min(d1$V1)
t$d1 <- d1tshifted
maxt <- max(d1tshifted)
srtts$d1 <- d1$V10
srtt_max <- max(d1$V10)

if (length(argv) > 1) {
	d2name <- argv[2]
	d2 <- read.table(d2name, sep=" ", header=F)
	d2tshifted <- d2$V1 - min(d2$V1)
	t$d2 <- d2tshifted
	maxt <- max(maxt, d2tshifted)
	srtts$d2 <- d2$V10
	srtt_max <- max(srtt_max, d2$V10)
}

if (length(argv) > 2) {
	d3name <- argv[3]
	d3 <- read.table(d3name, sep=" ", header=F)
	d3tshifted <- d3$V1 - min(d3$V1)
	maxt <- max(maxt, d3tshifted)
	t$d3 <- d3tshifted
	srtts$d3 <- d3$V10
	srtt_max <- max(srtt_max, d3$V10)
}

if (length(argv) > 3) {
	d4name <- argv[4]
	d4 <- read.table(d4name, sep=" ", header=F)
	d4tshifted <- d4$V1 - min(d4$V1)
	maxt <- max(maxt, d4tshifted)
	t$d4 <- d4tshifted
	srtts$d4 <- d4$V10
	srtt_max <- max(srtt_max, d4$V10)
}

if (length(argv) > 4) {
	d5name <- argv[5]
	d5 <- read.table(d5name, sep=" ", header=F)
	d5tshifted <- d5$V1 - min(d5$V1)
	maxt <- max(maxt, d5tshifted)
	t$d5 <- d5tshifted
	srtts$d5 <- d5$V10
	srtt_max <- max(srtt_max, d5$V10)
}

if (length(argv) > 5) {
	d6name <- argv[6]
	d6 <- read.table(d6name, sep=" ", header=F)
	d6tshifted <- d6$V1 - min(d6$V1)
	maxt <- max(maxt, d6tshifted)
	t$d6 <- d6tshifted
	srtts$d6 <- d6$V10
	srtt_max <- max(srtt_max, d6$V10)
}

if (length(argv) > 6) {
	d7name <- argv[7]
	d7 <- read.table(d7name, sep=" ", header=F)
	d7tshifted <- d7$V1 - min(d7$V1)
	maxt <- max(maxt, d7tshifted)
	t$d7 <- d7tshifted
	srtts$d7 <- d7$V10
	srtt_max <- max(srtt_max, d7$V10)
}

if (length(argv) > 7) {
	d8name <- argv[8]
	d8 <- read.table(d8name, sep=" ", header=F)
	d8tshifted <- d8$V1 - min(d8$V1)
	maxt <- max(maxt, d7tshifted)
	t$d8 <- d8tshifted
	srtts$d8 <- d8$V10
	srtt_max <- max(srtt_max, d8$V10)
}

png(file="srtt.png", height=900, width=1500, pointsize=12)

colors <- c("red", "darkolivegreen3", "cornflowerblue", "plum4", "darksalmon", "aquamarine", "darkgoldenrod1", "black")

# Trim off excess margin space (bottom, left, top, right)
#par(mar=c(4.2, 3.8, 0.2, 0.2))

plot(d1tshifted, d1$V10, type="o", col=colors[1], lty=1, pch=1, lwd=1, cex=0.5,
	axes=F, ann=T, xlab="Time (s)", ylab="Smoothed RTT (us)",
	log="y", xlim=c(0, min(maxt, max(d1tshifted))), ylim=c(0, srtt_max))

for (i in 2:length(argv)) {
	lines(unlist(t[i]), unlist(srtts[i]), type="o", lty=i, pch=i, lw=1, cex=0.5, col=colors[i])
}

#abline(h=maxrate, col="gray60")
#text(1, maxrate+0.15, format(maxrate, digits=2))
 
axis(1, las=1, cex.axis=1.0)
axis(2, las=1, cex.axis=1.0)

ltys <- rep(1:8)
pchs <- rep(1:8)
legend("left", argv, cex=1.0,
	col=colors[1:length(argv)], 
	lty=ltys[1:length(argv)], pch=pchs[1:length(argv)], lwd=3, bty="n");
  
# Turn off device driver (to flush output)
dev.off()

png(file="srtt-cdf.png", height=800, width=800, pointsize=12)
plot(0, 0, xlab="Smoothed RTT (us)", ylab="Probability", xlim=c(0, srtt_max), ylim=c(0, 1),
	log="x", type="n", axes=F, ann=T)
for (i in 1:length(argv)) {
	lines(ecdf(unlist(srtts[i])), lty=i, pch=i, lw=2, col=colors[i])
}

axis(1, las=1, cex.axis=1.0)
axis(2, las=1, cex.axis=1.0)

legend("bottomright", argv, cex=1.0,
	col=colors[1:length(argv)],
	lty=ltys[1:length(argv)], pch=pchs[1:length(argv)], lwd=3, bty="n");

dev.off()
