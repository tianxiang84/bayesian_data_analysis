#!/usr/bin/env Rscript
# The goal of this exercise is to estimate a Gaussian distribution from data

## Preparation
rm(list=ls()) # clear out the memory from previous data
setwd("~/bayesian_data_analysis/C9/E9p2") # set current path
library(R2OpenBUGS)

# Specify the model in BUGS language, but save it as a string in R:
modelString = "
model{
# Likelihood
for (i in 1:N) {
obs[i] ~ dnorm(mu, precision) # In BUGS, dnorm uses precision
}

# Prior
precision <- 1.0/(std*std)
mu ~ dnorm(0,1)
std ~ dnorm(1,1)
}
"
writeLines(modelString, con="model.txt")

## Data (Ground truth)
N <- 1000 # number of observation
obs = rnorm(N,2,5) # Ground truth observation
model.data <- list("N","obs")

## SPECIFY, WHICH PARAMETERS TO TRACE:
parameters <- c("mu","std")

#### LOAD INITIAL VALUES
inits <- function()
{
  #list(delta=0, taudelta=1)
  list(mu=0, std=1)
}

#### =================================================
mcmc.simulation =
  bugs(model.data,
       inits,
       model.file="model.txt",
       parameters=parameters,
       n.chains=1,
       n.iter=20000,
       n.burnin=500,
       n.thin=1,
       codaPkg=FALSE)

#### =================================================
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
for(p_ in parameters[1])
{
  hist(chain[[p_]], main=p_,
       ylab=NA, xlab=NA,
       nclas=50, col="red")
}
dev.off()
