

### Frequentistische Verfahren (parametrisch) ###

Das Verfahren rechnet deterministisch (z.B. Mittelwert), der Input ist zufällig (Messwerte). 
Das Verfahren selbst ist also hinsichtlich wiederholter Experimente eine Zufallsvariable, deren Eigenschaften (Bias, Varianz, ...) untersucht werden können.
Das probabilistische Modell spielt zur Laufzeit keine Rolle, die Verfahren werden aber oft vom Modell abgeleitet
(Maximum Likelihood).

[Frequentist and Bayesian Quantum Phase Estimation ](https://www.mdpi.com/1099-4300/20/9/628/htm)

"In the frequentist paradigm, the phase (assumed having a fixed but unknown value θ0) is estimated via an arbitrarily chosen function of the measurement results, θest(μ), called the estimator. Typically, θest(μ) is chosen by maximizing the likelihood ... "


### Probabilistic Programming (Bayes Statistik) ###

Das probabilistische Modell wird explizit programmiert, die Parameter sind als Wahrscheinlichkeitsverteilungen implementiert.
Das Programm lernt aus den Messdaten die Parameterverteilungen. 

Das Programm implementiert eine Wahrscheinlichkeitsverteilung und liefert entsprechend verteilte Samples.

### Generative Modelle allgemein ###

https://en.wikipedia.org/wiki/Generative_model

(Beispiel Naive Bayes: Lernen der Joint Probability)
(Beispiel Graphical Model (PGM) in Hakaru10: Sprinkler, Regen, nasser Rasen)

Variational Auto Encoder

#### nicht parametrische Verfahren ####

Beispiel Gauss Prozesse


### Diskriminative Modelle ###

Hier wird ohne Joint Probability gearbeitet. 

Typisches Beispiel: Klassifikation mit Hilfe logistischer Regression: Kreditausfall

https://en.wikipedia.org/wiki/Discriminative_model

