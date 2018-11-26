package org.sample

import org.apache.spark.sql.SparkSession

object App {
  def main(args : Array[String]): Unit = {
    val spark = SparkSession.builder()
      .appName("GitHub push counter")
      .master("local[*]")
      .getOrCreate()

    val sc = spark.sparkContext

    val numbers = sc.parallelize(1 to 100)
    numbers.foreach(println)
  }

}
