
#10 hit, 10 miss
plot(dbeta(seq(0,1, length = 100), 10, 10), type="l")
#100 hit, 100 miss => sehr wahrscheinlich 50% Quote
plot(dbeta(seq(0,1, length = 100), 100, 100), type="l")
#
#10 Hit, 1 Miss
plot(dbeta(seq(0,1, length = 100), 10, 1), type="l")
#
# 1 Hit, 100 Miss
plot(dbeta(seq(0,1, length = 100), 1, 100), type="l")
library(extraDistr)
?rdirichlet
matplot(rdirichlet(50, c(50, 100, 150)))
matplot(rdirichlet(50, c(100, 50, 50, 1)))
savehistory("~/probabilisticprogramming/R/betadirichlet/beta_dirichlet.R")
