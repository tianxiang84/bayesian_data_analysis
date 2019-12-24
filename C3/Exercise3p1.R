#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

# Goal: Toss a coin N times and compute the running proportion of heads
#N = 500 # Specify the total number of flips, denoted as N
N = as.integer(args[1])

flipsequence = sample(x=c(0,1), prob=c(0.1,0.9), size=N, replace=TRUE)
sprintf("%d", flipsequence)

n = 1:N
runprop = cumsum(flipsequence) / n

png('runprop.png')
plot(n, runprop, type='o', log='x', xlim=c(1,N), ylim=c(0,1), cex.axis=1.5, xlab='Flipped id', ylab='Prop head', cex.lab=1.5, main='Running prob', cex.main=1.5)
lines(c(1,N),c(0.9,0.9),lty=3)
dev.off()
