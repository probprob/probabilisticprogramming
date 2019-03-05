module Main where
import FrMo

main :: IO ()
main = putStrLn $ show $ runExact composeCoinHeadCount
