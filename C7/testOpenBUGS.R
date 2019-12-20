##!/usr/bin/R
## -*- coding: utf-8 -*-

rm(list=ls()) # clear out the memory from previous data
par(mfrow = c(1,1)) # one plot per page
options(digits=7) # number of digits to print on screen


#### LOAD R2OPENBUGS LIBRARY:
library(R2OpenBUGS)
#### =================================================

#### LOAD THE DATA FOR THE MODEL FROM A DAT FILE:
#in.data  <- read.table("hemodialysis.dat", header = FALSE)
#prepre  <- in.data[[3]]
#postpre <- in.data[[4]]
#N <- length(postpre)
#model.data <- list("prepre","postpre","N")
y = c(1,1,1,1,1,1,1,1,1,1,1,0,0,0)
nFlips = 14
model.data <- list("y","nFlips")

#### LOAD INITIAL VALUES
inits <- function()
{
  #list(delta=0, taudelta=1)
  list(theta=0.5)
}

#### SPECIFY, WHICH PARAMETERS TO TRACE:
#parameters <- c("delta","taudelta","sigma","pH0")
parameters <- c("theta")

#### ACTUALLY GENERATE THE CHAIN:
# Specify the model in BUGS language, but save it as a string in R:
modelString = "
model{
# Likelihood:
for (i in 1:nFlips){
y[i] ~ dbern(theta)
}

# Prior distribution
theta ~ dbeta(priorA, priorB)
priorA <- 1
priorB <- 1
}
"

writeLines(modelString, con="model.txt")

mcmc.simulation =
  bugs(model.data,
       inits,
       model.file="model.txt",
       parameters=parameters,
       n.chains=1,
       n.iter=20000,
       n.burnin=1000,
       n.thin=1,
       codaPkg=FALSE)


#### SHOW POSTERIOR STATISTICS
print(mcmc.simulation)

png('mcmc_simulation.png')
plot(mcmc.simulation)
dev.off()

#### MCMC CHAIN IN ONE DATA FRAME
png('mcmc_simulation2.png')
chain=mcmc.simulation$sims.list

par(mfrow = c(2,2)) # plot 4 plots per pa
par(mar=c(3,3,4,1)); # set marging of the plots

#### PLOT THE MCMC CHAINS:
png('mcmc_simulation3.png')
for(p_ in parameters)
  {
    plot(chain[[p_]][1:300], main=p_, type="l",
         ylab=NA, xlab=NA, col="red")
  }
dev.off()


#### PLOT AUTOCORRELATIONS:
png('mcmc_simulation4.png')
for(p_ in parameters)
  {
    acf(chain[[p_]], main=p_,lwd=4,col="red")
  }
dev.off()

#### PLOT THE HISTOGRAMS OF THE SAMPLED VALUES
png('mcmc_simulation5.png')
for(p_ in parameters)
  {
    hist(chain[[p_]], main=p_,
         ylab=NA, xlab=NA,
         nclas=50, col="red")
  }
dev.off()
