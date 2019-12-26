library(R2OpenBUGS)

graphics.off()
rm(list=ls(all=TRUE))

fileNameRoot = 'flipCoin'

modelString = "a"
writeLines(modelString,"model.txt")
nSubj = 1

