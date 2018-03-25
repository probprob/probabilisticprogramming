{-# Language ExistentialQuantification, NoMonomorphismRestriction, GADTs, StandaloneDeriving, FlexibleInstances #-}


module ShDs where

import Control.Applicative
import qualified Data.Map as M
import System.Random

xor :: Bool -> Bool -> Bool
xor x y = not (x == y)


type Prob = Double

-- What a happy coincidence! Haskell has the right good notation. We only
-- need to rename our conditional and dirac into somewhat historical names
-- (>>=) and return.

class Monad d => Dist d where
  bern :: Prob -> d Bool
  failure :: d a         -- we see the need for this when it comes to
                         -- conditioning


--Beispiel aus Wiki
coin = do
  x <- bern 0.5
  return x

--{csr

--mehrfacher Münzwurf
toss n = sequence $ replicate n coin

-- runExact $ toss 2
--[([False,False],0.25),([False,True],0.25),([True,False],0.25),([True,True],0.25)]


--liefert Distribution ueber Anzahl Köpfe bei n Würfen
headcount :: Dist f => Int -> f Int
headcount n = fmap (length . filter (\x -> x)) $ toss n

composeCoinHeadCount = do
  x <- coin
  if x then headcount 2 else headcount 1

countCompose samplesize n =  length $ filter (\x -> x == n) $ runSample samplesize composeCoinHeadCount
--ShDs> map (countCompose 100000)  [0,1,2]
-- [37450,50052,12498]


--Wahrscheinlichkeiten aus Wiki
--P(0)=0.5*0.5 + 0.5*0.25  = 3/8
--P(1)=0.5*0.5 + 0.5*0.5   = 4/8
--P(2)=0.5*0.25            = 1/8

--csr}

twocoins = do
  x <- bern 0.5
  y <- bern 0.5
  return $ xor x y

twocoins1 = do
  x <- bern 0.5
  y <- bern 0.5
  return $ (x,(y,xor x y))

mytwocoins1 = do
  x <- bern 0.5
  y <- bern 0.5
  return $ (((xor x y), (x,y)))

-- This is just the syntactic sugar. GHC re-writes it into the form
-- twocoins' that we saw before.

-- Again, what is the type of twocoins?

-- Let us implement another model, as an exercise:
-- die roll; throw n dice
-- Draw the model

class Dist d => Die d where
  die :: d Int   -- in Agda, Finite 6. But we do Int for now

--instance Die unten:  die = Single $ [ (x,1/6) | x <- [1..6] ]

dieroll n = fmap sum $ sequence $ replicate n die



_ = runExact (dieroll 3)

-- What are those functions, fmap and sequence?
--The sequence function takes a list of monadic computations, executes each one in turn and returns a list of the results. If any of the computations fail, then the whole function fails:
--sequence :: Monad m => [m a] -> m [a] 
--sequence = foldr mcons (return [])
--             where mcons p q = p >>= \x -> q >>= \y -> return (x:y)

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


{- Monty Hall Problem
https://en.wikipedia.org/wiki/Monty_Hall_problem

    Suppose you're on a game show, and you're given the choice of three doors:
    Behind one door is a car; behind the others, goats. You pick a door, say
    No. 1, and the host, who knows what's behind the doors, opens another door,
    say No. 3, which has a goat. He then says to you, "Do you want to pick door
    No. 2?" Is it to your advantage to switch your choice?
-}

monty_hall :: Bool -> Dst Bool
monty_hall should_switch = do
  car_door    <- uniformly doors
  my_choice   <- uniformly doors
  opened_door <- uniformly (del car_door . del my_choice $ doors)
  if should_switch then
    let [remaining_door] = del opened_door . del my_choice $ doors in
    return $ remaining_door == car_door
  else
    return $ my_choice == car_door
 where
   doors = [1,2,3]
   -- Delete an element from a list of was present
   del :: Eq a => a -> [a] -> [a]
   del x [] = []
   del x (h:t)
     | x == h     = t
     | otherwise  = h : del x t

_ = runExact $ monty_hall False
_ = runExact $ monty_hall True

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

-- Eldest daughter puzzle
-- A family has exactly two kids, one of them is a girl.
-- What is the chance the older is a girl?

girl :: Dst Bool
girl = do
  g1 <- bern 0.5
  g2 <- bern 0.5
  if g1 || g2 then return g1 else failure


_ = runExact girl
_ = normalize $ runExact girl

-- Grass model

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

-- Fair coin tosses given arbitrarily biased coin (von Neumann trick)
-- Show/Prove the correctness
-- (recursion, rejection)

fair_coin :: Dst Bool -> Dst Bool
fair_coin c = undefined

_ = runExact $ fair_coin (bern 0.2)

-- Drunken coin example:
-- very large depth and very low probability of acceptance

-- Drunken coin example: coin flipping by a drunk.
-- Because the person flipping the coin is drunk, most of the time
-- the result of flipping is a lost/dropped coin

drunk_coin :: Dst Bool
drunk_coin = do
  c <- bern 0.5
  lost <- bern 0.9
  if lost then failure else return c

-- Compute AND of n tosses of the drunk coin
dcoin_and n = fmap (foldr1 (&&)) . sequence $ replicate n drunk_coin

dcoin_and1 1 = drunk_coin
dcoin_and1 n = do
  -- t <-  dcoin_and1 (n-1)
  t <- categorical . runExact $ dcoin_and1 (n-1)
  h <- drunk_coin
  return $ h && t

_ = runExact $ dcoin_and 10
-- [(False,9.990234374999978e-11),(True,9.765624999999978e-14)]

-- Can we implement more efficiently?
-- (shorthand and) Why the False probability changes?

-- Alarm puzzle
-- http://aima.eecs.berkeley.edu/slides-pdf/chapter14a.pdf
-- p5 and 6
-- See examples on pp19 and 20


-- HMM
{-
  States represent position of a 1-dimensional random walk on 1..8

  State transition: one position to left/right with prob. 0.3 each;
  stay in state with prob. 0.4 (0.7 for boundary states)

  Observable: two states 'l' and 'r'. Prob. of observation=l in state
  k is 1-(k-1)/7
-}

newtype HMMState = HS{unHS:: Int} deriving (Show,Eq,Ord)
instance Bounded HMMState where
  minBound = HS 1
  maxBound = HS 8

instance Enum HMMState where
  succ (HS i) = HS (i+1)
  pred (HS i) = HS (i-1)
  fromEnum (HS i) = i
  toEnum = HS

-- Transition Probabilities
transitions :: HMMState -> PT HMMState
transitions st = case () of
  _ | st == minBound -> [(st,0.7),(succ st,0.3)]
  _ | st == maxBound -> [(st,0.7),(pred st,0.3)]
  _                  -> [(st,0.4),(succ st,0.3),(pred st,0.3)]

-- Observations
data HMMObs = L | R deriving (Eq,Show)

-- Tabulate the observation probabilities: of observing L
-- We use the numeric values directly from the Primula code
l_observation_prob :: M.Map HMMState Prob
l_observation_prob = M.fromList $
   zip [minBound..maxBound]
       [1.0, 0.85714, 0.71428, 0.57142, 0.42857, 0.28571, 0.14285, 0.0]

-- The evolution function: compute the state for the next step
evolve :: HMMState -> Dst HMMState
evolve = categorical . transitions

hmmobserve :: HMMState -> Dst HMMObs
hmmobserve st =
  case (M.!) l_observation_prob st of
    0 -> return R
    1 -> return L
    p -> categorical [(L,p), (R,1-p)]

-- Queries
-- Run the model for N steps, asserting observations

evolve_with_evidence :: Int -> (Int -> HMMState -> Dst ()) ->
                        Dst HMMState
evolve_with_evidence n evidence = do
  st0 <- uniformly [minBound..maxBound::HMMState]
  let evolvecheck st i = do
        s <- categorical . runExact $ st
        evidence i s
        evolve s
  foldl evolvecheck (return st0) [1..n]

_ = runExact $ evolve_with_evidence 10 (\i s -> if i == 5 then do {o <- hmmobserve s; if o == L then return () else failure} else return ())

-- ------------------------------------------------------------------------
-- Implementation
-- It is quite tricky; and those who want to know the tricky bit,
-- can ask later...

-- I show the implementation that you haven't seen: it is fully
-- above the board and faithfully implements specification.

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

instance Die Dst where
  die = Single $ [ (x,1/6) | x <- [1..6] ]

_ = runExact twocoins

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

_ = runSample 10 twocoins

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

