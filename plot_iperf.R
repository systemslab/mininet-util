#!/usr/bin/env Rscript

argv <- commandArgs(TRUE)

usage <- function() {
	print("Usage: plot* <maxy> <timeshift> <iperf>+")
	quit()
}

if (length(argv) < 3) {
	usage()
}

maxy <- as.numeric(argv[1])
tshift <- as.numeric(argv[2])

iperfname <- argv[3]
clients <- rep(2:(length(argv)-1))
n <- length(clients)
iperf <- read.table(iperfname, sep=",", header=F)
totals <- c(rep(0, length(iperf$V9)+tshift*(n-1)))

png(file="iperf.png", height=600, width=600, pointsize=12)

colors <- c("darkolivegreen3", "cornflowerblue", "plum4", "darksalmon", "aquamarine", "darkgoldenrod1", "black")

# Trim off excess margin space (bottom, left, top, right)
#par(mar=c(4.2, 3.8, 0.2, 0.2))

timesteps <- rep(0:(length(totals)-1))

plot(0, pch='', axes=F, ann=T, xlab="Time (s)", ylab="Rate (Mbps)",
	xlim=c(0, length(timesteps)), ylim=c(0, maxy))

for (i in clients) {
  name <- argv[1+i]
  iperf <- read.table(name, sep=",", header=F)
  lines(x=iperf$V7 + tshift*(i-2), y=iperf$V9 / 1000000, type="o", col=colors[i-1], lty=i-1, pch=i-1, lwd=4)
}

axis(1, las=1, cex.axis=1.0)
axis(2, las=1, cex.axis=1.0)

# Create a legend in the bottom-right corner that is slightly  
# smaller and has no border
legend("bottomright", c(paste("h", clients)), cex=1.0, col=colors, lty=c(clients), pch=c(clients), lwd=3, bty="n")

dev.off()
