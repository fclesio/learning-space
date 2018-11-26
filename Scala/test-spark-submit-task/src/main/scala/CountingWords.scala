import org.apache.spark.{SparkConf, SparkContext}
import org.apache.log4j.{Level, Logger}

object CountingWords {
  def main(args: Array[String]): Unit = {
    val conf = new SparkConf().setAppName("Simple Application").setMaster("local[*]")
    val sc = new SparkContext(conf)

    val rootLogger = Logger.getRootLogger()
    rootLogger.setLevel(Level.ERROR)

    val csvFile = "/Users/flavioclesio/Desktop/scala-books/ScalaandSparkforBigDataAnalytics_Code/data/data/statesPopulation.csv"
    val logData = sc.textFile(csvFile, 2).cache()
    val numAs = logData.filter(line => line.contains("a")).count()
    val numBs = logData.filter(line => line.contains("b")).count()
    println("Lines with a: %s, Lines with b: %s".format(numAs, numBs))

    println("Fim da Leitura")

  }
}

// Package the application
// $ sbt package

// Run the class on the Spark Cluster
// ./spark-submit --class CountingWords --master local ./teste-spark_2.11-0.1.jar