

object Demo {

    implicit val distMonad: Monad[Dist] = DistMonad

    var startCoinDist: Dist[Boolean] = new Dist (Nil :+ new Entry(0.5, true) :+ new Entry(0.5, false))

    val twoCoinDist: Dist[Int] = new Dist(Nil :+ new Entry(0.25, 0) :+ new Entry(0.5,1) :+ new Entry(0.25, 2))

    val threeCoinDist : Dist[Int] = new Dist(Nil :+ new Entry(0.125, 0) :+ new Entry(0.375,1) :+ new Entry(0.375, 2) :+ new Entry(0.125, 3))

    //mixture
    def kernel(b: Boolean): Dist[Int] = if (b) twoCoinDist else  threeCoinDist 

    import Monad._

    def demo: Dist[Int] =  { startCoinDist >>= kernel _ };
    def demo2: Dist[Int] =  startCoinDist >>= { b => if (b) twoCoinDist else  twoCoinDist  } ;
    def demo3: Dist[Int] =  startCoinDist >>= { b => if (b) threeCoinDist else  threeCoinDist  } ;


	def main(args: Array[String]) {
        println(demo)
    }
}
