#   http://theanalysisofdata.com/probability/7_3.html
#
library(mvtnorm)
#
# random walk
plot(cumsum(rnorm(10000)), type="l")
# n + 1 = n + rnorm(1)
# offensichtlich Markov
# Martingal: aktueller Wert bestimmt Erwartungswert
# Monadisch: Komposition von RV ergibt wieder RV
# Grenzübergang -> Wiener Prozess
# Stochastisches Integral, Ito und so
#
#
#
# Random Walk ist ein Gauß Prozess: beliebige Teilmenge der Zufallsvariablen sind mulitvariat Gauss verteilt, hier im besonderen "nicht korrelliert"
# Wahrscheinlichkeitsverteilung auf Realisierungen/Pfaden -> Pfadintegral
#   http://theanalysisofdata.com/probability/7_3.html
library(mvtnorm)
X = seq(-3, 3, length.out = 100)
m = sin(X)
n = 30
I = diag(1, nrow = 100, ncol = 100)
Y1 = rmvnorm(n, m, X %o% X/100 + I/1000)
par(cex.main = 1.5, cex.axis = 1.2, cex.lab = 1.5)
plot(X, Y1[1, ], type = "n", xlab = "$t$", ylab = "$X_t$",
main = "first term dominant with low variance")
for (s in 1:n) lines(X, Y1[s, ], col = rgb(0, 0, 0,
alpha = 0.5))
#
#
#
# Function Fitting
# Bayesian Optimization: Nando de Freitas (youtube)
# non parametric Bayes
# deep gaussian processes
savehistory("~/probabilisticprogramming/R/randomprocess/processes.R")
