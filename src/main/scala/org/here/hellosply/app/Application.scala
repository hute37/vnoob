package org.here.hellosply.app

import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._
import org.apache.spark.SparkConf


class Application(args: Array[String]) {


  var sc: SparkContext = _

  def open(): SparkContext = {
    val sparkHome = sys.env("SPARK_HOME")
    println(s"got SPARK_HOME=$sparkHome")

    val conf = new SparkConf().setAppName("Simple Application")
    sc = new SparkContext(conf)
    sc
  }

  def close(): Unit = {
    if (sc != null) {
      sc.stop()
    }
  }

  lazy val R = org.ddahl.rscala.RClient()



  val rcode =
    """
      |library("hellosply")
      |
      |a <-iris_count_auto()
      |
      |aSpecies <- a$Species
      |aCount <- a$Species_Count
      |
    """.stripMargin


  def demo(): Unit = {

    println(s"R code:\n${rcode}\n")

    println(s"R eval, ...")

    R.eval(rcode)

    println(s"R eval, done.")


    val aSpecies: Array[String] = R.getS1("aSpecies")
    val aCount: Array[Int] = R.getI1("aCount")

    val a: Array[(String, Int)] = aSpecies zip aCount


    println(s"\n a := \n")

    a.foreach(println)

    println(s"\n\n\n")


  }


  def run() : Unit = {
    open()
    demo()
    close()
  }

}

object Application {

  def main(args: Array[String]) {
    val app = new Application(args)
    app.run
  }
}