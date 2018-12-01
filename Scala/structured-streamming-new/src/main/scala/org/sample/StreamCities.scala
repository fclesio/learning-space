package org.sample

import org.apache.spark.sql.SparkSession
import org.apache.log4j.{Level, Logger}

object StreamCities {

  def main(args : Array[String]): Unit = {

    // Turn off logs in console
    Logger.getLogger("org").setLevel(Level.OFF)
    Logger.getLogger("akka").setLevel(Level.OFF)

    val spark = SparkSession.builder()
      .appName("Spark Structured Streaming get CSV and agregate")
      .master("local[*]")
      .getOrCreate()

    // 01. Schema Definition: We'll put the structure of our
    // CSV file. Can be done using a class, but for simplicity
    // I'll keep it here
    import org.apache.spark.sql.types._
    def csvSchema = StructType {
      StructType(Array(
        StructField("id", StringType, true),
        StructField("name", StringType, true),
        StructField("city", StringType, true)
      ))
    }

    // 02. Read the Stream: Create DataFrame representing the
    // stream of the CSV according our Schema. The source it is
    // the folder in the .load() option
    val users = spark.readStream
      .format("csv")
      .option("sep", ",")
      .option("header", true)
      .schema(csvSchema)
      .load("dataset/stream_in")

    // 03. Aggregation of the Stream: To use the .writeStream()
    // we must pass a DF aggregated. We can do this using the
    // Untyped API or SparkSQL

    // 03.1: Aggregation using untyped API
    //val aggUsers = users.groupBy("city").count()

    // 03.2: Aggregation using Spark SQL
    users.createOrReplaceTempView("user_records")

    val aggUsers = spark.sql(
      """
        SELECT city, COUNT(1) as num_users
        FROM user_records
        GROUP BY city"""
    )

    // Print the schema of our aggregation
    println(aggUsers.printSchema())

    // 04. Output the stream: Now we'll write our stream in
    // console and as new files will be included in the folder
    // that Spark it's listening the results will be updated
    val consoleStream = aggUsers.writeStream
      .outputMode("complete")
      .format("console")
      .start()
      .awaitTermination()
  }
}
