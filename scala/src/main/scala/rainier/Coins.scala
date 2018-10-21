package rainier

import com.stripe.rainier.core._
import com.stripe.rainier.core.Generator._
import com.stripe.rainier.sampler._
import com.stripe.rainier.compute._
import collection.mutable.HashMap

object Coins {

  implicit val rng: RNG = ScalaRNG(915276085339L)

  def main(args: Array[String]): Unit = {

      val firstCoin = Bernoulli(0.5)
      val twoCoins = Binomial(0.5, 2)
      val threeCoins = Binomial(0.5, 3)

      val n = 10000    

      val samplesFirstCoin = RandomVariable(firstCoin.generator).sample(n)
      histogram(samplesFirstCoin, "samplesFirstCoin")

      val samplesTwo = RandomVariable(twoCoins.generator).sample(n)
      histogram(samplesTwo, "samplesTwo")

      val samplesThree = RandomVariable(threeCoins.generator).sample(n)
      histogram(samplesThree, "samplesThree")

      //https://github.com/stripe/rainier/blob/develop/docs/impl.md
      //Generator implements map, zip, and flatMap in the standard way for a probability monad
      val composeGenerator = firstCoin.generator.flatMap( b => if (b == 1) twoCoins.generator else threeCoins.generator)
      histogram( RandomVariable(composeGenerator).sample(n), "composeGenerator")

      //It's a bit unintuitive that in RandomVariable[T], the T refers to the type of the function object, rather than the type produced by the function, which is implici
      //flatMap of RV is Bayesian Update 
      // -> this is nonsense:
      val composeRandomVariable =
        RandomVariable(firstCoin.generator).flatMap(b => {
          if (RandomVariable(b).sample(1) == 1)  
              RandomVariable(twoCoins.generator)
          else 
              RandomVariable(threeCoins.generator)
          })
      histogram(composeRandomVariable.sample(n), "composeRandomVariable is nonsense")
    
    }

    def histogram(samples: List[Int], header: String) {
      println("------------------")
      println(header)
      val histo = new HashMap[Int, Int]
      for( s <- samples) {
          histo.get(s) match {
            case None => histo.put(s, 0)
            case Some(n) => histo.put(s, n+1)
          }
        }

        for ((k,v) <- histo) {
          println( k + ": " + v)
        }
    }
}

/*
[info] Running rainier.Coins 
------------------
samplesFirstCoin
1: 4972
0: 5026
------------------
samplesTwo
2: 2506
1: 4961
0: 2530
------------------
samplesThree
2: 3648
1: 3792
3: 1269
0: 1287
------------------
composeGenerator
2: 3134
1: 4467
3: 577
0: 1818
------------------
composeRandomVariable is nonsense
2: 3672
1: 3759
3: 1309
0: 1256
*/