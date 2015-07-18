#!/usr/bin/env Rscript
#require(data.table)

argv <- commandArgs(TRUE)

usage <- function() {
	print("Usage: plot* <server> <rtt_min (us)> <tcp_probe data>")
	quit()
}

if (length(argv) < 3) {
	usage()
}

server <- argv[1]
rtt_min <- as.numeric(argv[2])
rtt_scale <- 1
rtt_units <- "(us)"

tcp_probe_name <- argv[3]

library(ggplot2)
library(RColorBrewer)

# CWND, SSTHRESH, and WND are all from the sender's perspective
probe_columns <- c("t", "Client", "Server", "length", "snd_next", "snd_una", "CWND", "SSTHRESH", "WND", "SRTT", "rcv_wnd")

tcp_probe <- read.table(tcp_probe_name, head=F, col.names=probe_columns)

if (rtt_min >= 500) {
	rtt_scale <- 1000
	rtt_min <- rtt_min / rtt_scale
	rtt_units <- "(ms)"
	tcp_probe$SRTT <- tcp_probe$SRTT / rtt_scale
}

srtt_min <- min(tcp_probe$SRTT, na.rm=TRUE)
srtt_max <- max(tcp_probe$SRTT, na.rm=TRUE)
srtt_0_99999th <- quantile(tcp_probe$SRTT, c(0.99999))
srtt_0_00001st <- quantile(tcp_probe$SRTT, c(0.00001))

#print(paste("x <- [", rtt_min, srtt_min, srtt_0_00001st, srtt_0_99999th, srtt_max, "]"))

cwnd_min <- min(tcp_probe$CWND, na.rm=TRUE)
cwnd_max <- max(tcp_probe$CWND, na.rm=TRUE)
cwnd_limits <- c(cwnd_min, cwnd_max)

tcp_probe$SSTHRESH[tcp_probe$SSTHRESH >= 2.147e+09] <- NA
tcp_probe$WND[tcp_probe$WND >= 2962944] <- NA
tcp_probe$rcv_wnd[tcp_probe$rcv_wnd >= 2962944] <- NA

Time <- tcp_probe$t - min(tcp_probe$t, na.rm=TRUE)
maxt <- max(Time, na.rm=TRUE)
tcp_probe <- cbind(tcp_probe, Time)

# sort by Time, then Client
tcp_probe <- tcp_probe[with(tcp_probe, order(Time, Client)), ]
tcp_probe$Client <- factor(as.numeric(tcp_probe$Client) - 1)

tcp_probe <- tcp_probe[grepl(server, tcp_probe$Server), ]

#print(tcp_probe)

colourCount = length(unique(tcp_probe$Client))
getPalette = colorRampPalette(brewer.pal(9, "Set1"))

print("cwnd+ssthresh+wnd")

plot(tcp_probe$Time, tcp_probe$CWND, type="l", log="y")
breaks <- axTicks(side=2)

png(file=paste("cwnd+ssthresh+wnd-", server, ".png", sep=""), height=1024, width=1024, pointsize=12)

qplot(Time, CWND, data = tcp_probe, colour = Client, geom = "line") +
	geom_point(data = tcp_probe, aes_string(x="Time", y="SSTHRESH"), shape = 0, size = 2) +
	geom_point(data = tcp_probe, aes_string(x="Time", y="WND"), shape = 1, size = 2) +
	scale_fill_manual(values = getPalette(colourCount)) +
	ylab("log CWND line, SSTHRESH square, WND circle (segments)") +
	xlab("Time (s)") +
	scale_y_log10(limits=cwnd_limits, breaks=breaks) +
	guides(fill = guide_legend(reverse = TRUE)) +
	theme_bw()

dev.off()

print("cwnd+ssthresh")
png(file=paste("cwnd+ssthresh-", server, ".png", sep=""), height=1024, width=1024, pointsize=12)

qplot(Time, CWND, data = tcp_probe, colour = Client, geom = "line") +
	geom_point(data = tcp_probe, aes_string(x="Time", y="SSTHRESH"), shape = 0, size = 2) +
	ylab("log CWND line, SSTHRESH point (segments)") +
	xlab("Time (s)") +
	scale_y_log10(limits=cwnd_limits, breaks=breaks) +
	guides(fill = guide_legend(reverse = TRUE)) +
	theme_bw()

dev.off()

print("cwnd")

png(file=paste("cwnd-", server, ".png", sep=""), height=1024, width=1024, pointsize=12)

qplot(Time, CWND, data = tcp_probe, colour = Client, geom = "line") +
	scale_fill_manual(values = getPalette(colourCount)) +
	ylab("log CWND (segments)") +
	xlab("Time (s)") +
	scale_y_log10(limits=cwnd_limits, breaks=breaks) +
	guides(fill = guide_legend(reverse = TRUE)) +
	theme_bw()

print("wnd")
png(file=paste("wnd-", server, ".png", sep=""), height=1024, width=1024, pointsize=12)

qplot(Time, WND, data = tcp_probe, colour = Client, geom = "line") +
	ylab("log WND (segments)") +
	xlab("Time (s)") +
	scale_y_log10(limits=c(min(tcp_probe$WND, na.rm=TRUE), max(tcp_probe$WND, na.rm=TRUE))) +
	guides(fill = guide_legend(reverse = TRUE)) +
	theme_bw()

dev.off()

print("ssthresh")

plot(tcp_probe$Time, tcp_probe$SSTHRESH, type="l", log="y")
breaks <- axTicks(side=2)

png(file=paste("ssthresh-", server, ".png", sep=""), height=1024, width=1024, pointsize=12)

qplot(Time, SSTHRESH, data = tcp_probe, colour = Client, geom = "line") +
	ylab("log SSTHRESH (segments)") +
	xlab("Time (s)") +
	scale_y_log10(limits=c(min(tcp_probe$SSTHRESH, na.rm=TRUE), max(tcp_probe$SSTHRESH, na.rm=TRUE)), breaks=breaks) +
	guides(fill = guide_legend(reverse = TRUE)) +
	theme_bw()

dev.off()

print("srtt")

plot(tcp_probe$Time, tcp_probe$SRTT, type="l", log="y")
breaks <- axTicks(side=2)

png(file=paste("srtt-", server, ".png", sep=""), height=1024, width=1024, pointsize=12)

srtt_max <- max(tcp_probe$SRTT, na.rm=TRUE)
qplot(Time, SRTT, data = tcp_probe, colour = Client, geom = "jitter") +
	ylab(paste("log SRTT", rtt_units)) +
	xlab("Time (s)") +
	scale_y_log10(limits=c(rtt_min, srtt_max), breaks=breaks) +
	guides(fill = guide_legend(reverse = TRUE)) +
	theme_bw()

dev.off()

print("srtt-cdf")
png(file=paste("srtt-cdf-", server, ".png", sep=""), height=1024, width=1024, pointsize=12)

qplot(SRTT, data = tcp_probe, colour = Client, stat = "ecdf", geom = "step") +
	ylab("CDF(SRTT)") +
	xlab(paste("log SRTT", rtt_units)) +
	scale_x_log10(limits=c(rtt_min, srtt_max), breaks=breaks) +
	guides(fill = guide_legend(reverse = TRUE)) +
	theme_bw() +
	theme(panel.grid.minor = element_line(colour="grey", linetype="dotted"))

dev.off()
