# Quantum/Probabilistic #

## Motivation ##

Quantum Computer können mehr Aufgaben effizient lösen als klassische Computer.

Quantum Computer können Quantum Systeme effizient simulieren.

Quantum Computer widerlegen die Extended Church Turing Hypothese:
"A probabilistic Turing machine can efficiently simulate any realistic model of computation."

Quantum Computing ist populär und es gibt viel ausgezeichnetes Material. Hier im Tutorial
stehen die Themen im Vordergrund:

* Gegenüberstellung zum klassichen Probabilistic Computing/Programming
* Funktionale Modellierung von QC, insbesondere in Haskell

### Timeline ###

Eine kurze Geschichte des QC: quantumcomputing-timeline.md

## Probability und Computing ##

### Randomisierte Algorithmen ###

RA nutzen Randomness, sollen aber möglichst sichere Aussagen liefern. Las Vegas Algorithmen dürfen z.B. keine  
falschen Positive liefern (falsche Negative sind erlaubt). Die Fehlerwahrscheinlichkeit
kann durch wiederholte Ausführung beliebig klein gemacht werden.

Beispiele: Quicksort / Primality Test

Es wird angenommen, dass P = BPP. (<https://en.wikipedia.org/wiki/BPP_(complexity>))

Die Fehlerwahrscheinlichkeit ist der Trade Off nicht das Ziel.

### Berechnung/Lernen von Wahrscheinlichkeitsverteilungen ###

Im Probabilistic Programming und Generative Modelling geht es um die Wahrscheinlichkeitsverteilung selbst.

Ziel ist eine Wahrscheinlichkeitsverteilung zu lernen, die eine Simulation bzw. die Generierung neuer Daten ermöglicht.
(Vorhersagen entsprechen bedingten Wahrscheinlichkeiten und sind daher auch möglich)

(siehe  statistics-learning.md)

## Quantum Probability und Computing ##

Demo: Shor's Algorithm (QIO Haskell)

Quantum Probability ist eine Verallgemeinerung klassischer Wahrscheinlichkeit (Generalized Probabilistic Theories).

* Operatoralgebren
* Kommutative Operatoren entsprechen klassischer Wahrscheinlichkeit
* Quantum  Probability und klassische Wahrscheinlichkeit sind in verwoben: Mixed State, Density Matrix

Eine realistische Intuition legt eher eine stärkere Abgrenzung Quantum/Klassich nahe:

* Quantum Probability ist intrinsisch, physikalisch, objektiv
* Klassiche Wahrscheinlichkeit ist (oft) epistemisch, subjektiv, quantifiziert Nicht-Wissen (Ensemble)

(siehe quantum-probabilistic.md)

ein weites Feld, z.B. [Rob Spekkens: Foundations Of Quantum Theory](<https://www.youtube.com/watch?v=0x5tXT1Y4is&list=PLaNkJORnlhZk9TDBI>, z.B. [Rob Spekkens: Foundations Of Quantum Theory](https://www.youtube.com/watch?v=0x5tXT1Y4is&list=PLaNkJORnlhZk9TDBIFJ49iQ2_f4PBzaS5)

Viele Themen wurden in die Quantum Kategorie gelifted:

* Quantum Algorithms
* Quantum Simulation
* Quantum Machine Learing
* Quantum ...

## Alphabit ##

* c-bit
* b-bit
* p-bit
* qubit

### Bayes Bit ###

Ein Bayes Bit ist ein noch nicht gemessenes klassisches Bit.
(noch nicht geworfene oder noch nicht gezeigte Münze)

Demo: Lernen der Wahrscheinlichkeitsverteilung eines Münzwurfes (Bayes, beta distribution)

[Probability Simplex](https://i.stack.imgur.com/pJCTO.jpg)

### p-bit ###

Ein p-bit ist ein fluktuierendes Bit: <https://www.purdue.edu/p-bit/>.

Die Wahrscheinlichkeitsverteilung hat im Gegensatz zum Bayes Bit eine physikalische Entsprechung.

* probabilistische Berechnungen sind möglich
* kein exponenentieller Speedup

### qubit ###

* Superposition

* α|0〉 + β|1〉

* relative Phase

* [Bloch Sphere](https://openclipart.org/image/2400px/svg_to_png/26565/gcross-qubit-bloch-sphere.png)

* Pauli-Matrizen

## Exponentieller Zustandsraum ##

### kombinatorische Explosion ###

n bits stellen 2^n Zahlen/Kombinationen dar

Das ermöglicht für viele Aufgaben (Additon, Multiplikation, ...) einen exponentiellen Speedup im Vergleich zur unären Darstellung.

### Joint Probability, Tensorprodukt ###

Die Komplexität der Joint Probability von n bits wächst exponentiell. Für jede Kombination ist eine Wahrscheinlichkeit definiert.

Das gilt entsprechend für qubits: die Dimension des Tensorprodukts von n qubits wächst exponentiell.

### Entanglement, Korrelation ###

* α|00〉 + β|11〉

### Marginalisierung, Partial Trace ###

* Entanglement -> Partial Trace -> Mixed State
* die andere Richtung: Purification

### Techniken und Möglichkeiten ###

* parametrisierte Darstellung (z.B. multinomiale Gauss erteilung, 2*n Koeffizienten)
* Monte Carlo Verfahren
* Probabilistic Graphical Model (Sparse Representation)
* NN als Generative Model
* Tensor Networks

Die Amplituden von qubits können nicht direkt gemessen werden. Eine Messung eines qubits liefert immer nur ein klassisches Bit an Information (Holevo Bound). Die Amplituden können aber effizient manipuliert werden. Quantenalgorithmen nutzen das, indem sie "interessante" Superpositionen erzeugen.

(die Amplituden können gelernt werden (Quantum State Tomography))

## QIO Tour ##

* Syntax Monade
* Alternative Syntax Monade
* Matrizen, Unitaries
* Klassiche Wahrscheinlichkeitsmonade
* Pure Quantum State Monade
* QIO Runtime
* Measurement/Split

### Ausblick Funktionales Quantum Computing ###

siehe quantum-abstractions.md
