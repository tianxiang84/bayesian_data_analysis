# Theta is the vector of candidate values for the parameter data
# nThetaVals is the number of candidate theta values
# To produce the examples in the book, set nThetaVals to either 3 or 63

nThetaVals = 3 # number of theta values
Theta = seq(from=1/(nThetaVals+1), to=nThetaVals/(nThetaVals+1), by=1/(nThetaVals+1))

# Prior
pTheta = pmin(Theta, 1-Theta) # triangular prior believe
pTheta = pTheta / sum(pTheta)

# Likelihood
Data = c(1,1,1,0,0,0,0,0,0,0,0,0)
nHeads = sum(Data==1)
nTails = sum(Data==0)
pDataGivenTheta = Theta^nHeads * (1-Theta)^nTails

# Posterior
pData = sum(pDataGivenTheta * pTheta)
pDataGivenTheta = pDataGivenTheta * pTheta / pData

# Plotting
windows(7,10)
layout(matrix(c(1,2,3), nrows=3, ncol=1, byrow=FALSE))
par(mar=c(3,3,1,0))
par(mgp=c(2,1,0))
par(mai=c(0.5,0.5,0,3,0.1))

plot(Theta, pTheta, type='h', lwd=3, main='Prior', xlim=c(0,1), xlab=bquote(theta), ylim=c(c,1.1*max(pThetaGavinData)), ylab=bquote(p(theta)), cex.axis=1.2, cex.lab=1.5, cex.main=1.5)
