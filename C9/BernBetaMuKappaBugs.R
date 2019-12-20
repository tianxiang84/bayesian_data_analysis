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
