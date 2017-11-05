package com.movile.stream

import org.apache.spark.sql.types._

/**
  * J.P. Eiti Kimura (eiti.kimura@movile.com)
  * 01/11/2017.
  */
object SchemaDefinition {

  // the csv data schema
  def csvSchema = StructType {
    StructType(Array(
      StructField("name", StringType, true),
      StructField("country", StringType, true),
      StructField("city", StringType, true),
      StructField("phone", StringType, true),
      StructField("age", IntegerType, true),
      StructField("carrier", StringType, true),
      StructField("marital_status", StringType, true)
    ))
  }

}
