-- "Sampling" einer Funktion aus einem indeterministischen Prozess

-- 3 mögliche Ergebnisse jeweils
lf :: Num a => a -> [a]
lf n = [ n, 2 * n, 3 * n ]

-- Sampling
lf_to_f :: (Int -> [a]) -> Int -> a
lf_to_f lf = \n -> (lf n) !! (mod n 3)


f :: Int -> Int
f = lf_to_f lf

main = do
  print $ map f [1..12]

--ghc lf_to_f && ./lf_to_f
-- [2,6,3,8,15,6,14,24,9,20,33,12]
