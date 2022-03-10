xv <- seq(0, 1, 0.02)
kopf <- 0
zahl <- 0

#die "echte" Wahrscheinlichkeit
probmodel <- 0.8

#(toss <- rbinom(n=1,size=1, prob=probmodel))
#runif(1, 0, 1) das ist eine Zufallszahl (uniform verteilt) zwischen  0 und 1
(toss <- floor(runif(1, 0, 1) + probmodel))
kopf <- kopf + toss
zahl <- zahl + !toss

# das aktuelle Wissen über die Wahrscheinlichkeit
posterior <- dbeta(xv, shape1 = 1+kopf, shape2 = 1+zahl)
plot(xv, posterior, main = paste(zahl, kopf))
