
# Moggi 1991: Notions of computation and monads #
  
Bei Moggi geht es um semantische Analyse.  

* Partielle Berechnung 
* Nicht Determinismus
  
  
Haskell implementiert die Monaden:  

* Maybe
* List


# Wahrscheinlichkeitsmonade #

* Lawvere 1962
* Zufallsberechnung
* liefert keinen festen Wert sondern Verteilung
* Kleisli Pfeil:  a -> Dist b
* liefert die bedingte Wahrscheinlichkeit

# Markov Kernel #


* Olav Kallenberg: Foundations of Modern Probability  


"Kernels play an important role in probability theory, where they may appear in
the guises of random measures, conditional distributions, Markov transition
functions, and potentials."


# Komposition #

* Analogie zu Maybe (ghci Demo)  

* zusammengesetztes Zufallsexperiment
* Mischverteilung  
* wahrscheinlich wahrscheinlich ~> wahrscheinlich  
* wahrscheinlich unwahrscheinlich ~> unwahrscheinlich


# Semantik für Probabilistische Programme
* https://arxiv.org/abs/1701.02547  

* A Convenient Category for Higher-Order Probability Theory  

* "Thus quasi-Borel spaces form semantics for a  probabilistic  programming  language  in  the  monadic style"

