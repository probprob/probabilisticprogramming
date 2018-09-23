

// Diskrete Wahrscheinlichkeitsverteilung für Werte von Typ A
//
// Liste von Paaren Wahrscheinlichkeit-Wert


class Dist[A] (val entries: Seq[Entry[A]]) {


def flatMap[B](f: (A) ⇒ Dist[B]): Dist[B] = {
    //das ist die Mixture Distribution
    //Verteilung von B-Verteilungen
    val mix: Dist[Dist[B]] = this.map(f)
    //aggregiert die Wahrscheinlichkeiten für die Werte des zweiten Experiments
    val bAggr = new scala.collection.mutable.HashMap[B, Double]


    for( distb: Entry[Dist[B]] <- mix.entries) {
        //distb.value ist eine B-Verteilung
        //Wahrscheinlichkeit aus erstem Experiment ->  Wahrscheinlichkeit einer B-Verteilung
        val pDistb: Double = distb.p

        for(bEntry <- distb.value.entries) {
            //Summe-Produkt Regel
            bAggr.get(bEntry.value) match {
                case None => bAggr.put(bEntry.value,  pDistb * bEntry.p)
                case Some(p) => bAggr.put(bEntry.value, p + pDistb * bEntry.p)
            }
        
        }
    }

    //Hashtable -> Distribution
    val bentries: Iterable[Entry[B]] = bAggr.map( { case (value,p) => new Entry(p,value) })
    return new Dist[B](bentries.to[collection.immutable.Seq])
}


def map[B](f: (A) ⇒ B): Dist[B] =
{
    //elementweises Mapping, Wahrscheinlichkeit bleibt erhalten
    val mapped = entries.map( x => { x.map(f)})
    return new Dist(mapped)
} 

override def toString:String = {
    val buf = new StringBuilder("Dist: ")
    for(e <- entries) {
        buf ++= "\n" + e.toString 
    }
    return buf.toString
}

}


