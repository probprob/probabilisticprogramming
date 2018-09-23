package figaro

import com.cra.figaro.language._
import com.cra.figaro.library.compound._
import com.cra.figaro.algorithm.factored._
import com.cra.figaro.algorithm.sampling._
import com.cra.figaro.algorithm._


object Coins {
	def main(args: Array[String]) {
        val startCoin = Flip(0.5);
        val twoCoins = Select(0.25 -> 0, 0.5 -> 1, 0.25 -> 2)
        val threeCoins = Select(0.125 -> 0, 0.375 -> 1, 0.375 -> 2, 0.125 -> 3)
        println("TwoCoins: " + twoCoins)
        println("ThreeCoins: " + threeCoins)

        val compose = Chain(startCoin, (b: Boolean) => if (b) twoCoins; else threeCoins)
        //convenience:
        //val compose = If (startCoin, twoCoins, threeCoins)

        println("\nstartCoin unobserved")
        output(compose) 
    
        println("observe startCoin true")
        startCoin.observe(true)
        output(compose)

        println("observe startCoin false")
        startCoin.observe(false)
        output(compose)     
	}

    def output(compose: Element[Int]) {
        val ve0 = VariableElimination.probability(compose, 0)
        val ve1 = VariableElimination.probability(compose, 1)
        val ve2 = VariableElimination.probability(compose, 2)
        val ve3 = VariableElimination.probability(compose, 3)
        println("compose == 0: " + ve0)
        println("compose == 1: " + ve1)
        println("compose == 2: " + ve2)
        println("compose == 3: " + ve3)
        println
      }
}