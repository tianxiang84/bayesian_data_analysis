##!/usr/bin/R
## -*- coding: utf-8 -*-

rm(list=ls()) # clear out the memory from previous data
par(mfrow = c(1,1)) # one plot per page
options(digits=7) # number of digits to print on screen


#### LOAD R2OPENBUGS LIBRARY:
library(R2OpenBUGS)
#### =================================================


# Specify the model in BUGS language, but save it as a string in R:
modelString = "
model{
# Likelihood
for (t in 1:nTrialTotal) {
y[t] ~ dbern( theta[coin[t]] )
}

# Prior
for (j in 1:nCoins) {
theta[j] ~ dbeta(a, b)I(0.0001, 0.9999)
}

a <- mu*kappa
b <- (1.0-mu)*kappa
mu ~ dbeta(Amu, Bmu)
kappa ~ dgamma(Skappa, Rkappa)
Amu <- 2.0
Bmu <- 2.0
Skappa <- pow(10,2)/pow(10,2)
Rkappa <- 10/pow(10,2)
}
"
writeLines(modelString, con="model.txt")
#### =================================================



N = c(10,10,10) # 3 coins, each toss 10 times
z = c(1,5,9) # times comes up head for each coins
coin = NULL; y = NULL
for(coinIdx in 1:length(N)){
coin = c(coin, rep(coinIdx, N[coinIdx])) # coin id for each toss
y = c(y, rep(1,z[coinIdx]), rep(0, N[coinIdx]-z[coinIdx])) # head/tail for each coin
}
nTrialTotal = length(y)
nCoins = length(unique(coin))
model.data <- list("y","coin","nTrialTotal","nCoins")
#### =================================================


#### LOAD INITIAL VALUES
inits <- function()
{
  #list(delta=0, taudelta=1)
  list(theta=c(0.5,0.5,0.5), mu=0.5, kappa=10)
}

#### SPECIFY, WHICH PARAMETERS TO TRACE:
parameters <- c("mu", "kappa", "theta")
#### =================================================

mcmc.simulation =
  bugs(model.data,
       inits,
       model.file="model.txt",
       parameters=parameters,
       n.chains=1,
       n.iter=10000,
       n.burnin=1000,
       n.thin=1,
       codaPkg=FALSE)

#### =================================================
print(mcmc.simulation)
