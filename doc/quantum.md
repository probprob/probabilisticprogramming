

# Quantum/Probabilistic #

## Timeline Quantum Computing ##

1980 Yuri Manin: "Computable and uncomputable"

1984 Bennet, Brassard: BB84 (Quantum cryptography Protocol)

1993 Simon's problem: exponential speedup

1994 Shor's algorithm

1995 Shor: Quantum Error Correction

1995 Cirac, Zoller: Quantum Computations with Cold Trapped Ions (Theory)

1998 Jones, Mosca: First experimental demonstration of a quantum algorithm 

2007 D-Wave: quantum annealing computer

2018 Ewin Tang: A quantum-inspired classical algorithm for recommendation systems 

2019+ Sycamore, SyJiuzhang: Quantum Advantage?

## Pure und Mixed States #

Pure State: komplexe Amplituden - deterministische Zeitentwicklung (Schrödinger)

Mixed State: klassisch statistisches Ensemble von Pure States - stochastische Zeitentwicklung (master equation in Lindblad form)

Pure: Closed System

Mixed: Open System

Pure States sind die Extrempunkte (qubit: Bloch Surface) - Mixed States Linearkombinationen davon (qubit: Bloch Sphere)

## Analogien ##

### Joint Distribution ~ Hilbert Product Space ###

technisch: Tensor Produkt (klassisch wie quantum)

exponentiell wachsende Komplexität (klassisch wie quantum)

### Dependence - Entanglement ###

independent ~ separable

dependent ~ entangled

### Conditional Distribution - Measurement ###

### Bayes Rule 

siehe Korotkov (Quantum Bayes Measurement)

## Links ##


[Wikipedia Timeline](https://en.wikipedia.org/wiki/Timeline_of_quantum_computing_and_communication)


### John Preskill: Quantum computing 40 years later ###

Ein guter Überblick:

[Quantum computing 40 years later](https://arxiv.org/abs/2106.10522)


### Dorit Aharonov: Quantum Computation ###

Da war QC neu und aufregend.

"I will devote much attention to understanding what the origins of the quantum computational power are, and what the limits of this power are"


[QUANTUM COMPUTATION](https://arxiv.org/pdf/quant-ph/9812037.pdf)

### Artur Ekert: Lectures ###

Eine prägnante Darstellung des klassischen Materials.

<https://www.youtube.com/c/ArturEkert/playlists>

Auf den Punkt gebracht:

[IQIS Lecture 1.6 — Deterministic, probabilistic, and quantum computation](https://www.youtube.com/watch?v=v6-tQj--yoI)

### Quantum Probabiliy ###

[Greg Kuperberg: An introduction to quantum probability, quantum mechanics, and quantumvcomputation](https://www.math.ucdavis.edu/~greg/intro.pdf)


"To summarize, quantum probability is the most
natural non-commutative generalization of classical
probability."


### Probabilistische Hardware ###

Historische Referenzen:

[Mansinghka, Jonas, Tenenbaum: Stochastic Digital Circuits for Probabilistic Inference (2008](https://dspace.mit.edu/bitstream/handle/1721.1/43712/MIT-CSAIL-TR-2008-069.pdf)


Hübsch gemacht:

[Purdue P](https://www.purdue.edu/p-bit/)


[Massively Parallel Probabilistic Computing with Sparse Ising Machines](https://arxiv.org/abs/2110.02481v1)


"The sIM in this paper is based on a Field Programmable
Gate Array (FPGA) implementation however the architecture
is general and it can have different implementations."


Sanity Check:
    
[p-bit Google Scholar](https://scholar.google.de/scholar?hl=de&as_sdt=0,5&q=%22p-bit%22&scisbd=1)


###  Epistemic, aleatoric, ontic, intrinsic ###


[Leifer: Is the quantum state real? An extended review of ψ-ontology theorems](https://arxiv.org/abs/1409.1570)


[Hüllermeier, Waegeman:Aleatoric and epistemic uncertainty in machine learning: an introduction to concepts and methods](https://link.springer.com/content/pdf/10.1007/s10994-021-05946-3.pdf)



[Aldous: Is it practical and useful to distinguish aleatoric and epistemic uncertainty? ](https://www.stat.berkeley.edu/~aldous/Real_World/ale_epi.html)

"In classical frequentist statistics one can regard the likelihood function as describing the the aleatoric uncertainty and the parameters as epistemic uncertainty, implicitly indicating a distinction between them, whereas a Bayesian puts a prior distribution on the parameters, implicitly rejecting a distinction."



Kuperberg: "In the frequentist interpretation, the state of an object is always a configuration a ∈ A, although you may not know which one; and a distribution ρ is a summary of which configuration you witness in repeated trials.
In the Bayesian interpretation, the state of an ob-
ject is a probabilistic state ρ ∈ ∆A, which however is
observer-dependent; it represents the observer’s ra-
tional belief about which configuration a ∈ A will be
witnessed, whether or not repeated trials are possi-
ble. 
...
However, quantum probability required a de-
gree of Bayesianism. Although frequentism will re-
main valid in some contexts, strict frequentism is un-
tenable as the fundamental interpretation of quan-
tum probability."


[Klaas Landsman: Foundations of Quantum Theory]
(https://link.springer.com/book/10.1007%2F978-3-319-51777-3)

Die ersten beiden Kapitel und Anhang C vertiefen Kuperberg.

Measurement und Quantum Bayes Rule:

[Korotkov: Measurement of superconducting
qubits and causality](https://intra.ece.ucr.edu/~Korotkov/presentations/15-MichSU.pdf)