package org.here.hellosply.app.sample

import org.apache.spark.{SparkConf, SparkContext}

object SampleApp {

  def main(args: Array[String]) {

    val sparkHome = sys.env("SPARK_HOME")

    val logFile = s"${sparkHome}/README.md" // Should be some file on your system

    val conf = new SparkConf().setAppName("Simple Application")
    val sc = new SparkContext(conf)
    val logData = sc.textFile(logFile, 2).cache()
    val numAs = logData.filter(line => line.contains("a")).count()
    val numBs = logData.filter(line => line.contains("b")).count()
    println(s"Lines with a: $numAs, Lines with b: $numBs")
    sc.stop()
  }
}