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

t <- list()
srtts <- list()
hbins <- list()

d1name <- argv[1]
d1 <- fread(d1name)
d1tshifted <- d1$V1 - min(d1$V1)
t$d1 <- d1tshifted
maxt <- max(d1tshifted)
srtts$d1 <- d1$V10
hbinsd1 <- hexbin(d1tshifted, d1$V10, xbins=40)
srtt_min <- min(d1$V10)
srtt_max <- max(d1$V10)
srtt_max99th <- quantile(d1$V10, c(0.99))
srtt_min1st <- quantile(d1$V10, c(0.01))

if (length(argv) > 1) {
	d2name <- argv[2]
	d2 <- fread(d2name)
	d2tshifted <- d2$V1 - min(d2$V1)
	t$d2 <- d2tshifted
	maxt <- max(maxt, d2tshifted)
	srtts$d2 <- d2$V10
	srtt_max <- max(srtt_max, d2$V10)
	srtt_max99th <- max(srtt_max99th, quantile(d2$V10, c(0.99)))
	srtt_min1st <- min(srtt_min1st, quantile(d2$V10, c(0.01)))
}

if (length(argv) > 2) {
	d3name <- argv[3]
	d3 <- fread(d3name)
	d3tshifted <- d3$V1 - min(d3$V1)
	maxt <- max(maxt, d3tshifted)
	t$d3 <- d3tshifted
	srtts$d3 <- d3$V10
	srtt_max <- max(srtt_max, d3$V10)
	srtt_max99th <- max(srtt_max99th, quantile(d3$V10, c(0.99)))
	srtt_min1st <- min(srtt_min1st, quantile(d3$V10, c(0.01)))
}

if (length(argv) > 3) {
	d4name <- argv[4]
	d4 <- fread(d4name)
	d4tshifted <- d4$V1 - min(d4$V1)
	maxt <- max(maxt, d4tshifted)
	t$d4 <- d4tshifted
	srtts$d4 <- d4$V10
	srtt_max <- max(srtt_max, d4$V10)
	srtt_max99th <- max(srtt_max99th, quantile(d4$V10, c(0.99)))
	srtt_min1st <- min(srtt_min1st, quantile(d4$V10, c(0.01)))
}

if (length(argv) > 4) {
	d5name <- argv[5]
	d5 <- fread(d5name)
	d5tshifted <- d5$V1 - min(d5$V1)
	maxt <- max(maxt, d5tshifted)
	t$d5 <- d5tshifted
	srtts$d5 <- d5$V10
	srtt_max <- max(srtt_max, d5$V10)
	srtt_max99th <- max(srtt_max99th, quantile(d5$V10, c(0.99)))
	srtt_min1st <- min(srtt_min1st, quantile(d5$V10, c(0.01)))
}

if (length(argv) > 5) {
	d6name <- argv[6]
	d6 <- fread(d6name)
	d6tshifted <- d6$V1 - min(d6$V1)
	maxt <- max(maxt, d6tshifted)
	t$d6 <- d6tshifted
	srtts$d6 <- d6$V10
	srtt_max <- max(srtt_max, d6$V10)
	srtt_max99th <- max(srtt_max99th, quantile(d6$V10, c(0.99)))
	srtt_min1st <- min(srtt_min1st, quantile(d6$V10, c(0.01)))
}

if (length(argv) > 6) {
	d7name <- argv[7]
	d7 <- fread(d7name)
	d7tshifted <- d7$V1 - min(d7$V1)
	maxt <- max(maxt, d7tshifted)
	t$d7 <- d7tshifted
	srtts$d7 <- d7$V10
	srtt_max <- max(srtt_max, d7$V10)
	srtt_max99th <- max(srtt_max99th, quantile(d7$V10, c(0.99)))
	srtt_min1st <- min(srtt_min1st, quantile(d7$V10, c(0.01)))
}

if (length(argv) > 7) {
	d8name <- argv[8]
	d8 <- fread(d8name)
	d8tshifted <- d8$V1 - min(d8$V1)
	maxt <- max(maxt, d7tshifted)
	t$d8 <- d8tshifted
	srtts$d8 <- d8$V10
	srtt_max <- max(srtt_max, d8$V10)
	srtt_max99th <- max(srtt_max99th, quantile(d8$V10, c(0.99)))
	srtt_min1st <- min(srtt_min1st, quantile(d8$V10, c(0.01)))
}

png(file="srtt.png", height=900, width=1500, pointsize=12)

plot(hbinsd1, xlab="Time (s)", ylab="Smoothed RTT (us)", legend=1.5)
 
# Turn off device driver (to flush output)
dev.off()

colors <- c("red", "darkolivegreen3", "cornflowerblue", "plum4", "darksalmon", "aquamarine", "darkgoldenrod1", "black")
ltys <- rep(1:8)
pchs <- rep(1:8)

png(file="srtt-cdf.png", height=800, width=800, pointsize=12)
plot(1, 1, xlab="Smoothed RTT (us)", ylab="Probability", xlim=c(max(1, srtt_min1st), srtt_max99th), ylim=c(0, 1),
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
