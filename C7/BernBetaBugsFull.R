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

modelCheck("model.txt")
