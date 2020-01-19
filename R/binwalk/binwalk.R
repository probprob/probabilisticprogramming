#Mini Demo Bernoulli Random Walk
#Rekursion und Higher Order
#Wahrscheinlichkeitskernel
#monadisches Bind für Kernel
#Pfadwahrscheinlichkeit

#10 Bernoulli Schritte simuliert
bern <- function(n) rbinom(n, 1, 0.5);
plot(cumsum(bern(10)), type="s")

#Rekursion geht auch
bwalk <- function(n, path) if (n == 0) path else bwalk(n -1, append(path, tail(path, n=1) + bern(1)))

points(bwalk(10, c(0)), type="s", col="red")

#binomialer Wahrscheinlichkeitskernel
# n Erfolge , ein weiteres Experiment: 
#0.5 Wahrscheinlichkeit für n Erfolge
#0.5 Wahrscheinlichkeit für n+1 Erfolge

m <- 10
bstep <- function (n) { p <- rep(0, m + 1);p[n] = 0.5; p[n+1] = 0.5;p}

#Wahrscheinlichkeit für n ist in p[n + 1] 

#das ist das monadische bind: 
#k ist ein Wahrscheinlichkeitskernel
#
#k wird für jeden Wert ausgeführt, das Ergebnis mit der Wahrscheinlichkeit des Wertes gewichtet
#Ergebnisse von k sind jeweils Spaltenvektor
#die Zeilensummen sind dann die neuen Wahrscheinlickeiten für Anzahl Erfolge

bind <- function(p, k) {rowSums(sapply(1:m, function(i) {(p[i]* k(i))}))}

#Am Anfang ist die Wahrscheinlichkeit von 0 Erfolgen 1
p= c(1,0,0,0,0,0,0,0,0,0,0)
p1 <- bind(p, bstep)
p2 <- bind(p1, bstep) 
p3 <- bind(p2, bstep)
p4 <- bind(p3, bstep)
p5 <- bind(p4, bstep); 
#plot(p5)
p5CheckDbinom <- dbinom(0:10, size=5, prob=0.5)

#Pfadwahrscheinlickeit (Länge 5) hier wirklich einfach
#2^5 mögliche Pfade, jeder gleichwahrscheinlich

#Simulation ueber Pfade - rel. Häufigkeit nach 5 Schritten
plot(prop.table(table(sapply(1:100000, function(i) cumsum(bern(5)))[5,])))
#Check gegen Binomialverteilung
points(0:5, dbinom(0:5, size=5, p=0.5), col="red")
