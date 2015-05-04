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
allrates <- cbind(totals)

png(file="iperf.png", height=600, width=600, pointsize=12)

for (i in clients) {
  name <- argv[1+i]
  iperf <- read.table(name, sep=",", header=F)
  rates <- c(rep(0, tshift*(i-2) - (i-2)), iperf$V9, rep(0, tshift*(n+1-i) + (i-2)))
  totals <- totals + rates
  allrates <- cbind(allrates, rates)
  print(allrates)
}

maxy <- max(maxy, totals / 1000000)
maxtotal <- max(totals[tshift:length(totals)-tshift] / 1000000)

d <- data.frame(allrates)
d$totals <- totals

colors <- c("red", "darkolivegreen3", "cornflowerblue", "plum4", "darksalmon", "aquamarine", "darkgoldenrod1", "black")

# Trim off excess margin space (bottom, left, top, right)
#par(mar=c(4.2, 3.8, 0.2, 0.2))

timesteps <- rep(0:(length(totals)-1))

plot(x=timesteps, y=totals / 1000000, type="o", col=colors[1], lty=1, pch=1, lwd=4,
	axes=F, ann=T, xlab="Time (s)", ylab="Rate (Mbps)",
	xlim=c(0, length(timesteps)), ylim=c(0, maxy))

for (i in clients) {
  lines(x=timesteps, y=d[i]$rates / 1000000, type="o", col=colors[i], lty=i, pch=i, lwd=4)
}

abline(h=maxtotal, col="grey")
text(max(timesteps), maxtotal, col="black", format(maxtotal, digits=2))
mintotal <- min(totals[tshift:length(totals)-tshift] / 1000000)
abline(h=mintotal, col="grey")
text(max(timesteps), mintotal, col="black", format(mintotal, digits=2))

axis(1, las=1, cex.axis=1.0)
axis(2, las=1, cex.axis=1.0)

# Create a legend in the bottom-right corner that is slightly  
# smaller and has no border
legend("bottomright", c("total", paste("h", clients)), cex=1.0, col=colors, lty=c(1, clients), pch=c(1, clients), lwd=3, bty="n")

dev.off()
