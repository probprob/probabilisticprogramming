{-# Language ExistentialQuantification, NoMonomorphismRestriction, GADTs, StandaloneDeriving, FlexibleInstances #-}

module FrMo where
import Control.Applicative
import qualified Data.Map as M
import System.Random


type Prob = Double

--Wahrscheinlichkeitsverteilung als Monade
class Monad d => Dist d where
  bern :: Prob -> d Bool
  failure :: d a        

coin = do
  bern 0.5

--Freie Monade
--coin ist nicht ausgewertet, sondern ein konkreter Syntaxbaum

--zwei Interpreter sind definiert:

--runExact coin
--[(True,0.5),(False,0.5)]

--runSample  2 coin
--[False,True]

--mehrfacher Münzwurf
toss n = sequence $ replicate n coin

-- runExact $ toss 2

--liefert Distribution ueber Anzahl Köpfe bei n Würfen (Binomialverteilung)
headcount :: Dist f => Int -> f Int
headcount n = fmap (length . filter (\x -> x)) $ toss n

composeCoinHeadCount = do
  x <- coin
  if x then headcount 2 else headcount 3


--Sampling liefert plausible Werte
countCompose samplesize n =  length $ filter (\x -> x == n) $ runSample samplesize composeCoinHeadCount
--ShDs> map (countCompose 100000)  [0,1,2,3]
--[18726,43917,31153,6204]


-- Probability Table
type PT a = [(a,Prob)] 


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

  Single []      >>= k = Single []
  Single [(x,1)] >>= k = k x    -- Nothing to sum over
  Single pt      >>= k = Chain pt k

  Chain pt k1 >>= k = Chain pt (\x -> k1 x >>= k)

--csr: Dst ist ein Syntaxbaum, die Konstruktion entspricht einer freien Monade 
--Standardverf. Freie Monade wäre: BaseFunctor mit Single und Chain, dann Fix Konstruktor


instance Dist Dst where
  bern p  = Single [(True, p), (False,1-p)]
  failure = Single []


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


normalize :: PT a -> PT a
normalize pt = map (map_snd (/nf)) pt
 where nf = sum $ map snd pt


map_fst :: (a -> b) -> (a,c) -> (b,c)
map_fst f (x,y) = (f x,y)

map_snd :: (a -> b) -> (c,a) -> (c,b)
map_snd f (x,y) = (x,f y)

