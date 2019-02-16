# erstes Bernoulli Exp. bestimmt das zweite Exp:
# Anzahl Erfolge von 2 oder 3 Versuchen
#
# Bernoulli
rbern <- function(n) rbinom(n, 1, prob=0.5)
#
rcountsucc <- function(n, nr) rbinom(n, nr, prob=0.5)
#
#Mixture von rcountsucc(n, 2) und rcountsucc(n,3)
rmix <- function(n) ifelse(rbern(n), rcountsucc(n,2), rcountsucc(n, 3))
n=10000
table(rmix(n))
#
library(ggplot2)
# für ggplot: 2 Erfolge, 3 Erfolge und Mixture in einen DataFrame
dat <- data.frame(xx = c(rcountsucc(n,2),rcountsucc(n,3),rmix(n)),yy = rep(c("Succ2", "Succ3", "Mix"),each = n))
#
ggplot(dat, aes(x=xx, fill=yy)) +
geom_histogram(binwidth=.5, colour="black", position="dodge") +
scale_fill_manual(values=c("green", "blue","yellow"))
rbern <- function(n) rbinom(n, 1, prob=0.5)
rcountsucc <- function(n, nr) rbinom(n, nr, prob=0.5)
bern <- function() rbinom(1, 1, prob=0.5)
mix <- function(b) if(b) rcountsucc(1,2) else rcountsucc(1, 3)
machine <- function() {b <- bern();c(b, mix(b))}
machine()
dfmachine <- data.frame(t(replicate(n, machine())))
colnames(dfmachine) <- c("hidden", "count")
str(dfmachine)
machinetable <- table(dfmachine)
machinetable
library(vcd)
mosaic(machinetable, shade = T)
assoc(machinetable, shade = T)
#
# mix liefert ein Sample der Joint Distribution
# table berechnet die contingency table
# vcd: "Visualizing Categorical Data"
savehistory("~/probabilisticprogramming/R/machine/history.R")
