{-# Language ExistentialQuantification, NoMonomorphismRestriction, GADTs, StandaloneDeriving, FlexibleInstances #-}


module CoSi where

import Control.Applicative
import qualified Data.Map as M
import System.Random


type Prob = Double

class Monad d => Dist d where
  bern :: Prob -> d Bool
  failure :: d a         -- we see the need for this when it comes to
                         -- conditioning


--Beispiel aus Wiki, True entspricht Kopf
coin = bern 0.5

--mehrfacher Münzwurf
toss :: Dist m => Int -> m [Bool]
toss n = sequence $ replicate n coin

--runSample 2 $ toss 3
--[[False,True,False],[False,True,False]]

-- runExact $ toss 2
--[([False,False],0.25),([False,True],0.25),([True,False],0.25),([True,True],0.25)]


--liefert Distribution ueber Anzahl Köpfe bei n Würfen
headcount :: Dist f => Int -> f Int
headcount n = fmap (length . filter (\x -> x)) $ toss n


composeCoinHeadCount = do
  x <- coin
  if x then headcount 2 else headcount 1


--wenn die Anzahl Köpfe bekannt ist -> nicht passende Samples werden verworfen
condCoinHeadCount observedCount = do
  x <- coin
  hc <- if x then headcount 2 else headcount 1  
  if hc /= observedCount then failure
    else return x



--zaehlt trues, gesamtanzahl, anteil_trues
true_all_prop :: (Foldable t1, Fractional t) => t1 Bool -> (t, t, t)

true_all_prop bools = foldr upd (0,0,0) bools
  where upd b (t,a,p) = (nt, a+1, nt / (a+1))
          where nt = if b then t+1 else t


--map (true_all_prop  . runSample 1000 . condCoinHeadCount ) [0..3]
--[(142.0,384.0,0.3697916666666667),
-- (235.0,509.0,0.46168958742632615),
-- (107.0,107.0,1.0),
-- (0.0,0.0,0.0)]

--Anzahl 3 gibt's nicht, Bei Anzahl 2 ist Anteil Kopf 100 Prozent
--Wahrscheinlichkeit Kopf ist bei Anzahl 0 am geringsten

-- Implementing grass model

grass_fwd = do
  rain         <- bern 0.3
  sprinkler    <- bern 0.5
  grass_is_wet <- nor 0.9 0.8 0.1 rain sprinkler
  return grass_is_wet

-- noisy-or function
nor :: Double -> Double -> Double -> Bool -> Bool -> Dst Bool
nor strengthX strengthY noise x y =
  bern $ 1 - nnot (1-strengthX) x * nnot (1-strengthY) y * (1-noise)

-- noisy not function
nnot :: Num a => a -> Bool -> a
nnot p True  = p
nnot p False = 1

_ = runExact grass_fwd
--[(False,0.3942),(True,0.6058)]

-- Implement uniformly given bern
-- Demonstrate that the implementation is correct
-- Prove it
-- Point: recursive implementation

uniformly :: Ord a => [a] -> Dst a
uniformly []  = failure
uniformly [a] = return a
uniformly lst@(h:t) = do
  f <- bern (1/fromIntegral (length lst))
  if f then return h else uniformly t

_ = runExact $ uniformly ([]::[Int])
_ = runExact $ uniformly [1]
_ = runExact $ uniformly [1,2]
_ = runExact $ uniformly [1..10]


-- ------------------------------------------------------------------------
-- Conditioning

-- Let's go back to the running example (slightly more complicated):
-- We flip a fair coin thrice. We now *observed* that the
-- results of three flips are not all the same.
-- What is the (posterior) probability that the first coin came up head (True)?
-- (draw the model)

{-
 We want to compute
 Pr(Coin1=x|TheSame=False)
    { Multiply/divide by Pr(TheSame=False) }
 = Pr(Coin1=x|TheSame=False) * Pr(TheSame=False) / Pr(TheSame=False)
    {Chain rule; obtaining the Joint distribution}
 = Pr(Coin1=x,TheSame=False) / Pr(TheSame=False)
    {Integrating out}
 = Sum_y Sum_z Pr(Coin1=x,Coin2=y,Coin3=z,TheSame=False) /
   Sum_x Sum_y Sum_z Pr(Coin1=x,Coin2=y,Coin3=z,TheSame=False)

How to find the above numerator and denominator from the joint distribution:
  False False False  True     1/8
  False False True   False    1/8
  False True False   False    1/8
  False True  True   False    1/8
  True  False False  False    1/8
  True  False True   False    1/8
  True  True  False  False    1/8
  True  True  True   True     1/8

First, remove all rows where TheSame is not False

  False False True   False    1/8
  False True False   False    1/8
  False True  True   False    1/8
  True  False False  False    1/8
  True  False True   False    1/8
  True  True  False  False    1/8

Then integrate out Coin2 and Coin3 (do Sum_y and Sum_z)

  False    False    3/8
  True     False    3/8

for the last factor, we just sum up: 6/8
The desired result

  False    False    1/2
  True     False    1/2

-}

-- How to program this
-- Recall, the joint distribution corresponds to a model

joint3:: Dst (Bool,Bool,Bool,Bool)
joint3 = do
  coin1 <- bern 0.5
  coin2 <- bern 0.5
  coin3 <- bern 0.5
  same  <- return (coin1 == coin2 && coin2 == coin3)
  return (coin1,coin2,coin3,same)

_ = runExact joint3

-- Pr(Coin1=x|Same=False)
one_not_same = do
  (coin1,coin2,coin3,same) <- joint3
  if same then failure  -- erasing rows
     else return coin1  -- coin2 and coin3 are integrated out

_ = runExact one_not_same

-- But we didn't compute the term in the denominator.
-- How to do that?

_ = normalize $ runExact one_not_same


normalize :: PT a -> PT a
normalize pt = map (map_snd (/nf)) pt
 where nf = sum $ map snd pt


grass_wet = do
  rain         <- bern 0.3
  sprinkler    <- bern 0.5
  grass_is_wet <- nor 0.9 0.8 0.1 rain sprinkler
  if not grass_is_wet then failure else return (rain,sprinkler)


-- Pr(Rain|Wet)
_ = normalize . runExact $ do { (r,s) <- grass_wet; return r}
-- The result matches what we had before. Much simpler this time, right?
_ = normalize . runExact $ do { (r,s) <- grass_wet; return s}




alarm :: Dst Bool
alarm = do
  b <- bern 0.001
  e <- bern 0.002
  a <- case (b,e) of
        (True,True)   -> bern 0.95
        (True,False)  -> bern 0.94
        (False,True)  -> bern 0.29
        (False,False) -> bern 0.001
  j <- if a then bern 0.9 else bern 0.05
  m <- if a then bern 0.7 else bern 0.01
  if (j && not m) then return b else failure

_ = normalize $ runExact alarm
-- Probability Table
type PT a = [(a,Prob)]  -- Ord a

map_fst :: (a -> b) -> (a,c) -> (b,c)
map_fst f (x,y) = (f x,y)

map_snd :: (a -> b) -> (c,a) -> (c,b)
map_snd f (x,y) = (x,f y)


-- The representation of distributions
data Dst a where
  Single :: PT a -> Dst a
  Chain  :: PT b -> (b -> Dst a) -> Dst a


instance Functor Dst where
   fmap f (Single pt) = Single (map (map_fst f) pt)
   fmap f (Chain d k) = Chain d (fmap f . k)



instance Applicative Dst where
  pure    = return
  m <*> x = do {mv <- m; xv <- x; return (mv xv)}

instance Monad Dst where
  return x = Single [(x,1)]

  -- Exercise: why is this correct?
  Single []      >>= k = Single []
  Single [(x,1)] >>= k = k x    -- Nothing to sum over
  Single pt      >>= k = Chain pt k

  -- Exercise: justify this
  -- Sum_y (Sum_x Pr(X=x) * Pr(Y=y|X=x)) * Pr(Z=z|Y=y)
  -- Sum_y (Sum_x Pr(X=x) * Pr(Y=y|X=x) * Pr(Z=z|Y=y))
  -- Sum_x (Sum_y Pr(X=x) * Pr(Y=y|X=x) * Pr(Z=z|Y=y))
  -- Sum_x Pr(X=x) * (Sum_y Pr(Y=y|X=x) * Pr(Z=z|Y=y))
  Chain pt k1 >>= k = Chain pt (\x -> k1 x >>= k)

--csr: Dst ist ein Syntaxbaum, die Konstruktion entspricht einer freien Monade 
--Standardverf. Freie Monade wäre: BaseFunctor mit Single und Chain, dann Fix Konstruktor


-- The handler of the Dst effect: Exact inference
runExact :: Ord a => Dst a -> PT a
runExact (Single x) = x
runExact (Chain pt k) =
  M.toList . M.fromListWith (+) .
   concatMap (\ (x,p) -> map (map_snd (*p)) $ runExact (k x)) $ pt

--csr: das nennt Oleg gerne Definitional Interpreter
--zuerst Produktregel dann Konsolidierung über Summenregel
--fromListWith: "Create a map from a list of key/value pairs with a comb. function 
--concatMap: Map a function over all the elements of a container and concatenate the resulting lists.
--concatMap :: Foldable t => (a -> [b]) -> t a -> [b]
--https://www.lernhelfer.de/schuelerlexikon/mathematik-abitur/artikel/baumdiagramme-und-pfadregeln


instance Dist Dst where
  bern p  = Single [(True, p), (False,1-p)]
  failure = Single []


-- A different handler: sampling

runSample :: Int -> Dst a -> [a]
runSample n m = go (mkStdGen 17) n m
  where
    go g 0 _ = []
    go g n (Single []) = go g (n-1) m
    go g n (Single pt) =
      let (x,g1) = select g pt in x:go g1 (n-1) m
    go g n (Chain [] k) = go g (n-1) m
    go g n (Chain pt k) =
      let (x,g1) = select g pt in go g1 n (k x)

    select g [(x,1)] = (x,g)
    select g pt      =
      let (r,g1) = randomR (0::Double,1) g
          x = fst . head . dropWhile (\ (_,p) -> r > p) $
              scanl1 (\ (_,p1) (x,p2) -> (x,p1+p2)) pt
      in (x,g1)


_ = let n = 10000 in (/ fromIntegral n) . fromIntegral . length . filter id $ runSample n grass_fwd

categorical :: PT a -> Dst a
categorical = Single


-- ------------------------------------------------------------------------
-- Grass Model

-- Probability the grass is wet, computed by hand
-- It is easier to compute the probability the grass is dry.
-- All three inputs (including noise) to nor should be false.
-- They are independent, so we just multiply the probability.
-- The input from rain is false if either there is no rain,
-- or there was rain, but it did not wet the grass.
grass_wet_hand = 1 - grass_dry
 where
   grass_dry = 0.9 * (0.7 + 0.3*0.1) * (0.5 + 0.5*0.2)

-- Computing the (posterior) probability of rain having observed
-- the grass is wet.
-- Bayes formula:
-- Pr(G,R) = Pr(R|G) * Pr(G) = Pr(G|R) * Pr(R)
-- Thus Pr(R|G) = Pr(G|R) * Pr(R) / Pr(G)
-- We have computed Pr(G) earlier.
rain_if_grass_wet_hand = grass_wet_rain * rain / grass_wet_hand
 where
   rain = 0.3
   grass_wet_rain = 1 - grass_dry_rain
   grass_dry_rain = 0.9 * 0.1 * (0.5 + 0.5*0.2)
-- 0.4684714427203697

spr_if_grass_wet_hand = grass_wet_spr * spr / grass_wet_hand
 where
   spr = 0.5
   grass_wet_spr = 1 - grass_dry_spr
   grass_dry_spr = 0.9 * (0.7 + 0.3*0.1) * 0.2
-- 0.7169032684054144

-- Hence, when we see wet grass, it is quite more likely this is because the
-- sprinkler was on.

