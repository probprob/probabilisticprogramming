
class Entry[E](val p: Double , val value: E) {

    def map[B](f: (E) ⇒ B): Entry[B] = new Entry(p, f(value))

    override def toString = p.toString + " " + value.toString


}