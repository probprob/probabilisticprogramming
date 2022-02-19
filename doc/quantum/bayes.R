xv <- seq(0, 1, 0.02)
kopf <- 0
zahl <- 0

probmodel <- 0.8

(toss <- rbinom(n=1,size=1, prob=probmodel))
kopf <- kopf + toss
zahl <- zahl + !toss

posterior <- dbeta(xv, shape1 = 1+kopf, shape2 = 1+zahl)
plot(xv, posterior, main = paste(zahl, kopf))
