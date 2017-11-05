package com.movile.stream

import org.apache.spark.SparkConf
import org.apache.spark.sql.SparkSession
import org.slf4j.{Logger, LoggerFactory}
import org.apache.spark.sql.streaming.{OutputMode, Trigger}


/**
  * J.P. Eiti Kimura (eiti.kimura@movile.com)
  * 01/11/2017.
  */
object StreamingFile {

  val log: Logger = LoggerFactory.getLogger(StreamingFile.getClass)

  def main(args: Array[String]): Unit = {

    val DIR = new java.io.File(".").getCanonicalPath + "/dataset/stream_in"

    //setting cluster definition
    val conf = new SparkConf()
      .setMaster("local[*]")
      .setAppName("Spark Structured Streaming Job")

    // initiate spark session
    val spark = SparkSession
      .builder
      .config(conf)
      .getOrCreate()

    //1. == DATA INPUT ==
    // read data from datasource, in this particular case it is a directory
    val reader = spark.readStream
      .format("csv")
      .option("header", true)
      .option("delimiter", ";")
      .option("latestFirst", "true")
      .schema(SchemaDefinition.csvSchema)
      .load(DIR + "/*")


    //2. == DATA PROCESSING ==
    reader.createOrReplaceTempView("user_records")

    val transformation = spark.sql(
      """
        SELECT carrier, marital_status, COUNT(1) as num_users
        FROM user_records
        GROUP BY carrier, marital_status
      """)


    //3. == DATA OUTPUT ==
    val consoleStream = transformation.
      writeStream.
      option("truncate", false).
      outputMode(OutputMode.Complete).
      trigger(Trigger.ProcessingTime("2 seconds")).
      format("console").
      start()


    consoleStream.awaitTermination()
  }
}
