

## Entwurf: Mathematik <-> Funktionale Programmierung ##

Mathematik erstmal im Alltagssinne: naive Mengentheorie, higher order logic

Mathematik ist offensichtlich mehr als gängige funktionale Programmierung: 
es werden Theorien entwickelt und bewiesen.

Funktionen und Higher Order Funktionen sind aber überall zu finden.

Relationen werden in funkt. Sprachen durch Datenstrukturen dargestellt, aber auch funktional aufgebaut:
Äquivalenzrelation:  equals, groupBy
Ordnungsrelation -> sort + compare, anamorphismus für Listen und Bäume)
(Difference List: funktionale Repräsentation einer Liste (eher exotisch))
(Lambda Calculus: Funktionen für alles (auch exotisch))

Haskell zumindest kann schon ein bisschen beweisen: [Proving Stuff in Haskell](https://blog.madsbuch.com/proving-stuff-in-haskell/)

Letztlich sind Typtheorien Synthesen von Mathematik und funktionaler Programmierung.
[Martin-Löf 1979: eine Variante](http://archive-pml.github.io/martin-lof/pdfs/Constructive-mathematics-and-computer-programming-1979.pdf)

### Funktionale Mathematik ###

	* Ableitung: f -> f'
	* Stammfunktion: f -> F
	* Integral: f, a, b -> R
	* Funktional: f -> R
	* Integraltransformation: f, kernel -> g
	* Variationsrechnung: Funktionenraum, Funktional ->  f (optimale Funktion bezüglich Funktional)
	* Decision Rule: Data, Loss function -> value
	*
	* der ganze Algebra Zoo
	* Lineare Abbildungen
	* Homomorphismen, Isomorphismen


#### denotation/computing ~ extensional/intensional ~ total/partiell ####

(Funktion: Mathematik, function: Computing)


Funktionen sind Mengen (Funktionsgraph). Eine Funktion rechnet nicht, das Ergebnis ist einfach da.
Andererseits: Funktionsvorschrift ist intensional: wie wird das Ergebnis berechnet

Ableitungsfunktion ist einfach eine Funktion. Ableitungsregeln hingegen sind syntaktisch/intensional.

Gleichheit von Funktionen ist extensional: Funktionen sind gleich, wenn sie gleiche Ergebnisse liefern

(keine Effekte hier)

functions rechnen und liefern eventuell Ergebnis. Eine function ist eine Implementierung und kann z.B. automatisch differenziert werden.

Naive Mengensemantik ist naiv wegen: Divergenz (Turing komplett hier) und ??

functions sind allgemein rekursiv (Fix Point Combinator, PCF)

Weniger naive Mengensemantik: Domain Theory 

(cool, gerade Real PCF entdeckt: https://www.cs.bham.ac.uk/~mhe/papers/RNC3.pdf)

##### Gleichheit von functions #####

Ist im allgemeinen undefiniert. Wenn doch dann intensional (gleiche Implementierung):

C Function Pointer: Funktionen sind gleich, wenn sie auf den identischen Code verweisen

(http://www.iso-9899.info/n1570.html : 6.5.9.6)

Two Methods are the same if they were declared by the same class and have the same name and formal parameter types and return type.
(https://docs.oracle.com/en/java/javase/13/docs/api/java.base/java/lang/reflect/Method.html)


### Computing - mathematische Semantik ###

Denotationale Semantik ist mathematische Semantik für Computing.

Der Lambda Calculus ist die Objektsprache, Mathematik ist die Metasprache.
(analog Komplexitätstheorie - auch wenn da Turingmaschinen beliebter sind)

(hat für mich ein wenig naturwissenschaftlichen Charakter: Computer sind physikalische Objekte, analog Quantum Computing https://en.m.wikipedia.org/wiki/Quantum_computing)

Der Stochastic Lambda Calculus ist eine einfache probabilistische Programmiersprache. Die mathematische Semantik ist wahrscheinlichkeitstheoretisch.

[A Domain Theory for Statistical Probabilistic Programming](https://arxiv.org/abs/1811.04196)

### Computing + Logik ###

Naive Mathematik rechnet nicht (siehe oben). 

Typtheorie als Grundlage hingegen ist computional und logisch stark genug um mathematische Theorien zu entwickeln.

[type theory (nlab)](https://ncatlab.org/nlab/show/type+theory):

> From a foundational point of view, type theory can also be regarded as the language in which mathematics is written.

Die Unterscheidung Objekt/Metasprache wird recht subtil, wenn die Objektsprache bereits metasprachenfähig ist.
(siehe nlab, die verstehen das)


#### Typtheorie (Church, Martin-Löf): ####

funktionaler Kern: Lambda Calculus (aber getypt, keine beliebigen Expressions)

Computation = Ausdruck vereinfachen (Beta Reduction) 


##### Propositions as Types #####

Typtheorie hat logischen Charakter (Curry-Howard und so). Dependent Types sind prädikatenlogisch. 
Typregeln entsprechen logischen Regeln.

Ein Term ist ein Beweis für seinen Typ. Dass 3 die natürlichen Zahlen beweist wirkt sonderbar.
Weniger sonderbar: zu jeder natürlichen Zahl n gibt es einen String mit der Länge n.
Beweis ist ein Funktionsterm, der für n einen String der Länge n liefert.
Gleichheitsaussagen haben einen Identitätstyp (refl am Ende des Beweises ist der Beweisterm). 


(Kategoriale Semantik, wird beliebig kompliziert (Higher Topos))


##### Typtheorie: intensional/extensional #####

http://eprints.nottingham.ac.uk/28941/1/Nuo%2520Li%2527s_Thesis.pdf

Ziel ist möglichst viel (extensionale) Mathematik darstellen zu können: extensionale Funktionengleichheit und Quotientenmengen.

Vorteile sollen aber bleiben: 
	* formal mit entscheidbaren Beweisen
	* konstruktiv: für jede Existenzaussage kann auch geliefert werden
	* computational: man kann rechnen und effiziente Programme extrahieren (Proof Irrelevance)
	
	

Konflikt zwischen Features/Ausdrucksstärke und Gutartigkeit (Confluence, Kanonizität, Decidable Type/Proof Checking:
z.B. https://jesper.sikanda.be/files/AIMXXIX.html)

Design Space ist groß und unübersichtlich und wird aktiv erforscht.

Ein wichtiger Aspekt ist, welche Art von Gleichheit der Typechecker berücksichtigt. Gleiche Definition von Termen (intensionale Gleichheit)
(aber hier ist auch schon eine gewisse Vereinfachung der Definitionen erlaubt, recht subtil hier) als Kriterium ist entscheidbar. Bewiesene Gleichheit
von Terminen (=extensional) hingegen ist nicht entscheidbar (Proofsearch verliert sich).

Setoids: Quotientenmengen selbst gemacht (warum eigentlich setoid hell?).


Agda: recht aufgeräumt und zugänglich mit Haskell Background 
	- erst mal intensional
	- kann aber gepimpt werden: https://jesper.sikanda.be/files/AIMXXIX.html#/adding-an-equational-theory


Frisch aus der Presse:

[Synthetic topology in Homotopy Type Theory for probabilistic programming](https://arxiv.org/abs/1912.07339)


> ALEA can only prove its versionof the Giry monad to adhere to the monad laws pointwise and resorts to setoids because neither function extensionality nor quotients are part of standard Coq.This is not a problem in homotopy type theory, where function extensionality is provable and quotients of sets can be constructed as a special case of higher inductive types. Sets in HoTT form a ΠW-pretopos with a (externally) countable hierarchy universes; that is, it is a model predicative constructivemathematics2
> including quotients and universes (Rijke and Spitters, 2014). 


[Equations for HoTT](https://hott.github.io/HoTT-2019/conf-slides/Sozeau.pdf)

[Abgefahren: Coq im Browser](http://mattam82.github.io/Coq-Equations/assets/jsexamples/equations_intro.html)


Lean:

Ähnlich wie Agda kann Lean mit extensionalen Axiomen erweitert werden:

[Lean: AXIOMS AND COMPUTATION](https://leanprover.github.io/theorem_proving_in_lean/theorem_proving_in_lean.pdf)

> But Lean erases types and propositional information when compiling definitions to bytecode for its virtual machine evaluator, and since these axioms only add new propositions, they are compatible withthat computational interpretation. Even computationally inclined users may wish to use the classical law of the excludedmiddle to reason about computation. This also blocks evaluation in the kernel, but it is compatible with compilation tobytecode.

?? Man verliert Kanonizität (Kernel rechnet nicht weiter) aber man kann Berechnung/Bytecode trotzdem ausführen ??


### Nächste Schritte ###

Typtheorie lernen.

Mit Lean Mathlib experimentieren: 
[Diskrete Wahrscheinlichkeitsmonade](https://github.com/leanprover-community/mathlib/blob/master/src/measure_theory/probability_mass_function.lean)


Coq/HoTT mit Equations zum Laufen bringen








	
