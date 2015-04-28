#!/usr/bin/env Rscript

argv <- commandArgs(TRUE)

usage <- function() {
	print("Usage: plot* <maxrate> <timeshift> <data1> <data2>")
	quit()
}

if (length(argv) < 4) {
	usage()
}

maxrate <- as.numeric(argv[1])
tshift <- as.numeric(argv[2])
data1name <- argv[3]
data2name <- argv[4]

png(file="iperf.png", height=600, width=600, pointsize=12)

data1 <- read.table(data1name, sep=",", header=F)
data2 <- read.table(data2name, sep=",", header=F)

rates1 <- c(data1$V9, rep(0, tshift))
rates2 <- c(rep(0, tshift), data2$V9)
total <- rates1 + rates2

rates1 <- c(data1$V9, rep(NA, tshift))
rates2 <- c(rep(NA, tshift), data2$V9)

colors <- c("darkolivegreen3", "cornflowerblue", "plum4")

# Trim off excess margin space (bottom, left, top, right)
#par(mar=c(4.2, 3.8, 0.2, 0.2))

plot(total / 1000000, type="o", col=colors[1], lty=1, pch=1, lwd=4,
	axes=F, ann=T, xlab="Time (s)", ylab="Rate (Mbps)",
	xlim=c(0, length(total)), ylim=c(0, maxrate))
lines(rates1 / 1000000, type="o", col=colors[2], lty=2, pch=2, lwd=4)
lines(rates2 / 1000000, type="o", col=colors[3], lty=3, pch=3, lwd=4)
 
axis(1, las=1, cex.axis=1.0)
axis(2, las=1, cex.axis=1.0)

# Create a legend in the bottom-right corner that is slightly  
# smaller and has no border
legend("bottomright", c("total", "client1", "client2"), cex=1.0,
	col=c(colors[1], colors[2], colors[3]), 
	lty=c(1, 2, 3), pch=c(1, 2, 3), lwd=3, bty="n");
  
# Turn off device driver (to flush output)
dev.off()
