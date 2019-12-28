#!/usr/bin/env RScript
# Goal: Use MCMC to estimate a single variable x, using ground truth uncertain data, 
# Confirm the variance of x will shrink no matter what.

# Start with a clean environment and import the R2OpenBUGS libraries
rm(list=ls(all=TRUE)) # remove all objects in environment
setwd('/home/rstudio/bayesian_data_analysis/C9/Gaussian') # In R, the default working directory is not the current folder
library(R2OpenBUGS) # load the R2OpenBUGS library

# Specify data
gt_mu <- 2    # ground truth average (x, the value we want to recover)
gt_std <- 2   # ground truth sd (std in the sample)
nObsTot <- 100 # number of observations
obsTot <- rnorm(nObsTot, gt_mu, gt_std) # ground truth observation data

# Add a Normal Curve (Thanks to Peter Dalgaard)
#hist(obsTot, freq=FALSE)
#x <- obsTot
#h<-hist(x, breaks=20, col="red", xlab="x", main="Histogram with Normal Curve")
#xfit<-seq(min(x),max(x),length=40)
#yfit<-dnorm(xfit,mean=mean(x),sd=sd(x))
#yfit <- yfit*diff(h$mids[1:2])*length(x)
#lines(xfit, yfit, col="blue", lwd=2)

# Specify model 1
modelString = "
model{
for (i in 1:nObsTot){
obsTot[i] ~ dnorm(x, measurement_precision) # Given x, what's the probability of an observation
}
x ~ dnorm(priorXMu,priorXPrecision) # Prior distribution
}
"
writeLines(modelString, con="model.txt")

measurement_precision <- 1.0/25.0
priorXMu <- 0.0
priorXPrecision <- 0.01
model.data <- list("nObsTot","obsTot","priorXMu","priorXPrecision","measurement_precision")

inits <- function()
{
  list(x=2)
}
parameters <- c("x") # variable to keep track of
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
print(mcmc.simulation)
hist(mcmc.simulation[["sims.matrix"]][,1])
#stop('stop at method 1')









# Specify model 2 and save it to a model text file
modelString="
model{
obs ~ dnorm(x, measurement_precision) # Likelihood
x ~ dnorm(prior_mu, prior_precision) # Prior
}
"
writeLines(modelString, con="model.txt")

# Perform MCMC simulation
nObs <- 1
measurement_precision <- 1.0/(gt_std^2)

prior_mu <- 0
prior_precision <- 1.0/(10.0*10.0)
inits <- function()
{
  list(x=0)
}
for (obsIdx in 1:nObsTot){
  obs <- obsTot[obsIdx]
  model.data <- list("nObs","obs","prior_mu","prior_precision","measurement_precision")
  parameters <- c("x") # variable to keep track of
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
  
  if (obsIdx %% 20 == 0){
    print(c(obsIdx, obs, mcmc.simulation[["summary"]][1,1], mcmc.simulation[["summary"]][1,2]))
    #print(mcmc.simulation)
  }

  prior_mu <- mcmc.simulation[["summary"]][1,1]
  prior_precision <- 1.0/(mcmc.simulation[["summary"]][1,2]^2)
  inits <- function()
  {
    list(x=mcmc.simulation[["summary"]][1,1])
  }
}





















# Specify model 3 and save it to a model text file
modelString="
model{
obs ~ dnorm(mu, precision) # Likelihood
precision <- 1.0/(sigma*sigma)
mu ~ dnorm(mu_mean, mu_precision)
sigma ~ dnorm(sigma_mean, sigma_precision)
}
"
writeLines(modelString, con="model.txt")

# Perform MCMC simulation
mu_mean = 0
mu_precision = 1
sigma_mean = 10
sigma_precision = 0.1
inits <- function()
{
  list(mu=0, sigma=10)
}
for (obsIdx in 1:nObsTot){
  obs <- obsTot[obsIdx]
  model.data <- list("obs","mu_mean","mu_precision","sigma_mean","sigma_precision")
  parameters <- c("mu","sigma") # variable to keep track of
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
  
  if (obsIdx %% 20 == 0){
    print(c(obsIdx, obs, mcmc.simulation[["summary"]][1,1], mcmc.simulation[["summary"]][1,2], mcmc.simulation[["summary"]][2,1], mcmc.simulation[["summary"]][2,2]))
    #print(mcmc.simulation)
  }
  
  mu_mean = mcmc.simulation[["summary"]][1,1]
  mu_precision = 1.0/(mcmc.simulation[["summary"]][1,2]*mcmc.simulation[["summary"]][1,2])
  sigma_mean = mcmc.simulation[["summary"]][2,1]
  sigma_precision = 1.0/(mcmc.simulation[["summary"]][2,2]*mcmc.simulation[["summary"]][2,2])
  inits <- function()
  {
    list(mu=mcmc.simulation[["summary"]][1,1], sigma=mcmc.simulation[["summary"]][2,1])
  }
}













# Specify the model 4 in BUGS language, but save it as a string in R:
modelString = "
model{
# Likelihood
for (i in 1:nObsTot) {
obsTot[i] ~ dnorm(mu, precision) # In BUGS, dnorm uses precision
}

# Prior
precision <- 1.0/(std*std)
mu ~ dnorm(0,1)
std ~ dnorm(1,1)
}
"
writeLines(modelString, con="model.txt")

## Data (Ground truth)
model.data <- list("nObsTot","obsTot")

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