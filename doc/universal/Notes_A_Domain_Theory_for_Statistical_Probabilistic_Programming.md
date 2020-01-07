

# wirklich nur Notizen #


(1) [A Domain Theory for Statistical Probabilistic Programming](https://arxiv.org/abs/1811.04196)

frühere vorbereitende Paper

(2) [A Convenient Category for Higher-Order Probability Theory](https://arxiv.org/pdf/1701.02547.pdf)

(2 a) [Folien dazu](https://www.cs.ox.ac.uk/people/ohad.kammar/talks/lics2017-qbs.pdf)

und

(3) [Commutative semantics for probabilistic programming](http://www.cs.ox.ac.uk/people/samuel.staton/papers/esop2017.pdf)

---

"Commutative semantics for probabilistic programming" ist didaktisch und ein guter Einstieg.

---

Das Standard Setup in der Wahrscheinlichkeitstheorie ist ein Wahrscheinlichkeitsraum (Omega) mit messbaren Elementen. Gemessen wird die Wahrscheinlichkeit.

Ein Measure bildet die Elemente eines messbaren Raums X auf die positiven reellen Zahlen ab (Volumenwert). Das Measure einer Teilmenge von X ist
die Summe der Measures ihrer Elemente. (Einschränkung auf sigma-Algebra geschenkt).
(ein normiertes Measure ist eine Wahrscheinlichkeitsverteilung)

Standard Beispiel für einen messbaren Raum sind die reellen Zahlen mit Intervall Länge als Grundlage für das Measure (Lebesgue Measure).

Eine messbare Funktion f zwischen zwei messbaren Räumen X -> Y induziert das Measure von X in den Zielraum. (Measure in Y = Measure des Urbildes von Y in X)
Manchmal (Radon-Nikodym) kann eine Wahrscheinlichkeitsdichte p für f definiert werden. Das Integral der Dichtefunktion liefert das Maß des Urbildes des integrierten Intervalls. f ist eine reellwertige Zufallsvariable.

Ein Kernel k: X ~> Y berechnet für Elemente aus X eine Wahrscheinlichkeitsverteilung in Y. Das ist bedingte Wahrscheinlichkeit: x ist die Bedingung.

( ~> weil: als Funktion ist k komplizierter, Latex wäre gut. k ist aber ein Morphismus in der Kleisli Kategorie der Messbaren Räume, Giry Monade entsprechend)
(ein Kernel ist also eine probabilistische Berechnung (Notion of Computing, Moggi))

siehe 2.1 in (3)

---

1.1 und 3.2 in (3) Denotational Semantics

ein Typ ist ein messbarer Raum A

ein Wert ist ein Element von A

es gibt deterministische Variablen

ein deterministischer Term ist eine Funktion in einen messbaren Raum (Ergebnistyp)

P(A) ist der Typ der Wahrscheinlichkeitsverteilungen über A
( P(A) ist als Typ selbst wieder wahrscheinlichkeitsverteilt, Endofunktor, Monade P(P(A)) -> P(A) über Integration/Marginalisierung)
("return a" lifted a von A nach P(a) (dirac Measure))

Wahrscheinlichkeitsverteilung ist hier Measure, d.h. muss nicht normiert sein.


ein stochastischer Term ist ein Kernel (probabilistische Berechnung) und berechnet für Werte der freien Variablen eine Wahrscheinlichkeitsverteilung

ein Programm ist ein Term ohne freie Variablen und bedeutet eine Wahrscheinlichverteilung
(ein Programm berechnet also nicht einen Wert, sondern die Wahrscheinlichkeiten möglicher Ergebniswerte)

Sequencing ist monadische Komposition, siehe P(P(A).

es gibt ein Normalisierungskonstrukt norm für P(A), das dann eine echte Wahrscheinlichkeitsverteilung liefert.

es gibt Funktionskonstanten für Wahrscheinlichkeitsverteilungen (z.B. gauss(mu, sigma))

Wahrscheinlichkeitsverteilungen können können konditioniert werden (observe, score in sample Ausdrücken)

Konditionierung ist Bayesian inspiriert -> das vorherige Maß des (Parameter-)Wertes wird mit der Likelihood des Beobachtungswertes multipliziert
(Likelihood des Beobachtungswertes für einen Parameterwert: wie gut passt mein Beobachtungswert zu dem Parameterwert)

aposteriori ~ likelihood * prior  (proportional zu)

(sprich: die prior Wahrscheinlichkeit wird mit der Likelihood des beobachteten Messwertes gewichtet)

??
können beliebige Wahrscheinlichkeitsverteilungen konditioniert werden, oder nur explizite Prior Verteilungen?
??
score bezieht sich auf einen trace (Lauf), das ist operational. Wo ist bewiesen, dass diese Simulationssemantik tatsächlich gegen die
aposteriori Verteilung nach Bayes konvergiert (a la MCMC)?



### Higher Order Functions ###

(1) stellt ein semantisches Problem mit HOF vor:

> The  Category Meas is  not cartesian closed: there is no space of functions R→R.

[Borel Structures in Function Spaces](http://www.ma.huji.ac.il/raumann/pdf/66.pdf)

Es gibt natürlich den Funktionenraum R->R, aber dieser ist kein Objekt von Meas, da er selbst keine Borel-Struktur aufweist.
(Aumann zeigt dann welche Bedingungen/Einschränkungen notwendig sind, damit der Funktionenraum doch admissible wird)



### Quasi Borel Spaces ###

[275A, Notes 0: Foundations of probability theory](https://terrytao.wordpress.com/2015/09/29/275a-notes-0-foundations-of-probability-theory/)

> The foundations of probability theory are usually presented (almost by default) using the last of the above three approaches; namely, one talks almost exclusively about sample space models for probabilistic concepts such as events and random variables, and only occasionally dwells on the need to extend or otherwise modify the sample space when one needs to introduce new sources of randomness (or to forget about some existing sources of randomness). However, much as in differential geometry one tends to work with manifolds without specifying any given atlas of coordinate charts, in probability one usually manipulates events and random variables without explicitly specifying any given sample space. For a student raised exclusively on concrete sample space foundations of probability, this can be a bit confusing, for instance it can give the misconception that any given random variable is somehow associated to its own unique sample space, with different random variables possibly living on different sample spaces, which often leads to nonsense when one then tries to combine those random variables together. Because of such confusions, we will try to take particular care in these notes to separate probabilistic concepts from their sample space models. 

und

[Remark 3](https://terrytao.wordpress.com/2014/06/28/algebraic-probability-spaces/)

Ein QBS ist ein Paar (X, Raum  messbarer, "einfacher" Funktionen f von R nach X)
(Measure auf X wird f induziert)

Ähnlich wie bei Aumann werden die erlaubten Funktionen R -> X aus einfachen konstanten Basisfunktionen konstruiert:
Definition 7:
konstante Funktionen sind OK
Prepend einer messbaren Funktion ist OK
stückweise admissible auf (Überdeckung mit) Borelmengen ist auch OK  (Induktionsschritt)



Entscheidend ist Proposition 18: QBS ist cartesian closed.

Das QBS Funktionsobjekt ist das Paar (Y^X, uncurry(alpha) Element von QBS(Produkt(R,X), Y))

Ahem, welche Funktionen sind das? Was genau soll QBS(Produkt(R,X), Y)) sein?
Ist das etwa induktiv gemeint?

(die Funktionen von R -> Y^X , für die ??? )

uncurry:
(a -> b -> c) -> (a,b) -> c



QBS ist eine Erweiterung von Meas.

Soll ähnlich wie eine Presheaf Konstruktion sein, da gehen die Pfeile aber in die andere Richtung (Funktor nach Set) (Appendix A).



----------
Die Ausgangsobjektsprache (nicht probabilistisch) entspricht FPC:

[PFPL Kapitel 20](https://www.cs.cmu.edu/~rwh/pfpl/2nded.pdf)

> In this chapter we study FPC,  a language with products,  sums,  partial functions,  and recursivetypes. 

SFPC ist eine Erweiterung mit reellen Zahlen, einem Zufallszahlengenerator sample und einer score Funktion.
score gewichtet Beobachtungen entsprechend der Likelihood.


## Domain Theory ##

Mathematisches Modell für (universelles, rekursives) Computing.
Berechnungen sind partiell und rekursiv und können nicht naiv mengentheoretisch modelliert werden. Eine Domain ist kein einfacher Funktionsgraph, sondern eine (üblicherweise) unendliche Kette von Teilfunktionsgraphen (wcpo) mit Supremum. Ein größeres Element der Kette enthält mehr Information (mehr Input/Output Paare).

Domains sind topologisch und können analog zur Maßtheorie (Sigma Algebra) gemessen werden (Valuation, meist gleich Measure).


Damit sind jedoch keine Higher Order Probabilistic Functions möglich, das Setup ist nicht cartesian closed:

## Omega Quasi Borel Space ##

[The Jung-Tix Problem](https://arxiv.org/pdf/1202.2287.pdf)

Deshalb all die Mühe in (1).

> We circumventthe Jung-Tix problem, without solving it, by keeping the two structures, the domain-theoretic and the measurable, separate but compatible. Doing so also allows us to replace the measure-theoretic structure, which is usually incompatible with higher-order structure, with a quasi-Borel spacestructure.

Das Konstrukt nennt sich dann wQbs (Omega Quasi Borel Space).
Der Ansatz ist, sowohl die Gültigkeit der (bzw. von) Axiome(n) der Domain Theory nachzuweisen, als auch die der Synthetischen Maßtheorie.
(also eine Topostheorie, bzw. Quasitopos-Theorie)

Puh










