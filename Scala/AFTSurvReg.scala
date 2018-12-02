// val test = spark.createDataFrame(Seq(
//   (1.019, 1.0, Vectors.dense(1.934, -0.721))
// )).toDF("label", "censor", "features")

import org.apache.spark.ml.feature.VectorAssembler
import org.apache.spark.ml.linalg.Vectors
import org.apache.spark.ml.regression.AFTSurvivalRegression
import org.apache.spark.sql.types._

def csvSchema = StructType {
	StructType(Array(
		StructField("date", DateType, true),
		StructField("serial_number", StringType, true),
		StructField("model", StringType, true),
		StructField("capacity_bytes", IntegerType, true),
		StructField("failure", IntegerType, true),
		StructField("smart_1_normalized", IntegerType, true),
		StructField("smart_1_raw", IntegerType, true),
		StructField("smart_2_normalized", IntegerType, true),
		StructField("smart_2_raw", IntegerType, true),
		StructField("smart_3_normalized", IntegerType, true),
		StructField("smart_3_raw", IntegerType, true),
		StructField("smart_4_normalized", IntegerType, true),
		StructField("smart_4_raw", IntegerType, true),
		StructField("smart_5_normalized", IntegerType, true),
		StructField("smart_5_raw", IntegerType, true),
		StructField("smart_7_normalized", IntegerType, true),
		StructField("smart_7_raw", IntegerType, true),
		StructField("smart_8_normalized", IntegerType, true),
		StructField("smart_8_raw", IntegerType, true),
		StructField("smart_9_normalized", IntegerType, true),
		StructField("smart_9_raw", IntegerType, true),
		StructField("smart_10_normalized", IntegerType, true),
		StructField("smart_10_raw", IntegerType, true),
		StructField("smart_11_normalized", IntegerType, true),
		StructField("smart_11_raw", IntegerType, true),
		StructField("smart_12_normalized", IntegerType, true),
		StructField("smart_12_raw", IntegerType, true),
		StructField("smart_13_normalized", IntegerType, true),
		StructField("smart_13_raw", IntegerType, true),
		StructField("smart_15_normalized", IntegerType, true),
		StructField("smart_15_raw", IntegerType, true),
		StructField("smart_183_normalized", IntegerType, true),
		StructField("smart_183_raw", IntegerType, true),
		StructField("smart_184_normalized", IntegerType, true),
		StructField("smart_184_raw", IntegerType, true),
		StructField("smart_187_normalized", IntegerType, true),
		StructField("smart_187_raw", IntegerType, true),
		StructField("smart_188_normalized", IntegerType, true),
		StructField("smart_188_raw", IntegerType, true),
		StructField("smart_189_normalized", IntegerType, true),
		StructField("smart_189_raw", IntegerType, true),
		StructField("smart_190_normalized", IntegerType, true),
		StructField("smart_190_raw", IntegerType, true),
		StructField("smart_191_normalized", IntegerType, true),
		StructField("smart_191_raw", IntegerType, true),
		StructField("smart_192_normalized", IntegerType, true),
		StructField("smart_192_raw", IntegerType, true),
		StructField("smart_193_normalized", IntegerType, true),
		StructField("smart_193_raw", IntegerType, true),
		StructField("smart_194_normalized", IntegerType, true),
		StructField("smart_194_raw", IntegerType, true),
		StructField("smart_195_normalized", IntegerType, true),
		StructField("smart_195_raw", IntegerType, true),
		StructField("smart_196_normalized", IntegerType, true),
		StructField("smart_196_raw", IntegerType, true),
		StructField("smart_197_normalized", IntegerType, true),
		StructField("smart_197_raw", IntegerType, true),
		StructField("smart_198_normalized", IntegerType, true),
		StructField("smart_198_raw", IntegerType, true),
		StructField("smart_199_normalized", IntegerType, true),
		StructField("smart_199_raw", IntegerType, true),
		StructField("smart_200_normalized", IntegerType, true),
		StructField("smart_200_raw", IntegerType, true),
		StructField("smart_201_normalized", IntegerType, true),
		StructField("smart_201_raw", IntegerType, true),
		StructField("smart_223_normalized", IntegerType, true),
		StructField("smart_223_raw", IntegerType, true),
		StructField("smart_225_normalized", IntegerType, true),
		StructField("smart_225_raw", IntegerType, true),
		StructField("smart_240_normalized", IntegerType, true),
		StructField("smart_240_raw", IntegerType, true),
		StructField("smart_241_normalized", IntegerType, true),
		StructField("smart_241_raw", IntegerType, true),
		StructField("smart_242_normalized", IntegerType, true),
		StructField("smart_242_raw", IntegerType, true),
		StructField("smart_250_normalized", IntegerType, true),
		StructField("smart_250_raw", IntegerType, true),
		StructField("smart_251_normalized", IntegerType, true),
		StructField("smart_251_raw", IntegerType, true),
		StructField("smart_252_normalized", IntegerType, true),
		StructField("smart_252_raw", IntegerType, true),
		StructField("smart_254_normalized", IntegerType, true),
		StructField("smart_254_raw", IntegerType, true),
		StructField("smart_255_normalized", IntegerType, true),
		StructField("smart_255_raw", IntegerType, true)
	))
}

var data = spark.read.format("csv")
.option("header", "true")
.schema(csvSchema)
.load("/Users/flavioclesio/Downloads/2013/2013-04-10.csv")

data.createOrReplaceTempView("harddrives")

// Check function
spark.sql("select datediff(current_timestamp(), date) FROM harddrives").show(3)



val sqlDF = spark.sql("""
	SELECT 
	  , datediff(current_timestamp(), date) AS label
	  , failure AS censor
	  , capacity_bytes
      , smart_1_normalized
      , smart_1_raw
      , smart_2_normalized
      , smart_2_raw
      , smart_3_normalized
      , smart_3_raw
      , smart_4_normalized
      , smart_4_raw
	FROM 
	  harddrives""")



val sqlDF = spark.sql("""
	SELECT 
	  capacity_bytes AS label
	  , failure AS censor
      , smart_1_normalized
      , smart_1_raw
      , smart_2_normalized
      , smart_2_raw
      , smart_3_normalized
      , smart_3_raw
      , smart_4_normalized
      , smart_4_raw
      , smart_5_normalized
      , smart_5_raw
      , smart_7_normalized
      , smart_7_raw
      , smart_8_normalized
      , smart_8_raw
      , smart_9_normalized
      , smart_9_raw
      , smart_10_normalized
      , smart_10_raw
      , smart_11_normalized
      , smart_11_raw
      , smart_12_normalized
      , smart_12_raw
      , smart_13_normalized
      , smart_13_raw
      , smart_15_normalized
      , smart_15_raw
      , smart_183_normalized
      , smart_183_raw
      , smart_184_normalized
      , smart_184_raw
      , smart_187_normalized
      , smart_187_raw
      , smart_188_normalized
      , smart_188_raw
      , smart_189_normalized
      , smart_189_raw
      , smart_190_normalized
      , smart_190_raw
      , smart_191_normalized
      , smart_191_raw
      , smart_192_normalized
      , smart_192_raw
      , smart_193_normalized
      , smart_193_raw
      , smart_194_normalized
      , smart_194_raw
      , smart_195_normalized
      , smart_195_raw
      , smart_196_normalized
      , smart_196_raw
      , smart_197_normalized
      , smart_197_raw
      , smart_198_normalized
      , smart_198_raw
      , smart_199_normalized
      , smart_199_raw
      , smart_200_normalized
      , smart_200_raw
      , smart_201_normalized
      , smart_201_raw
      , smart_223_normalized
      , smart_223_raw
      , smart_225_normalized
      , smart_225_raw
      , smart_240_normalized
      , smart_240_raw
      , smart_241_normalized
      , smart_241_raw
      , smart_242_normalized
      , smart_242_raw
      , smart_250_normalized
      , smart_250_raw
      , smart_251_normalized
      , smart_251_raw
      , smart_252_normalized
      , smart_252_raw
      , smart_254_normalized
      , smart_254_raw
      , smart_255_normalized
      , smart_255_raw 
	FROM 
	  harddrives""")


val assembler = new VectorAssembler()
  .setInputCols(Array(
    "smart_1_normalized","smart_1_raw","smart_2_normalized","smart_2_raw",
    "smart_3_normalized","smart_3_raw","smart_4_normalized","smart_4_raw",
    "smart_5_normalized","smart_5_raw","smart_7_normalized","smart_7_raw",
    "smart_8_normalized","smart_8_raw","smart_9_normalized","smart_9_raw",
    "smart_10_normalized","smart_10_raw","smart_11_normalized","smart_11_raw",
    "smart_12_normalized","smart_12_raw","smart_13_normalized","smart_13_raw",
    "smart_15_normalized","smart_15_raw","smart_183_normalized","smart_183_raw",
    "smart_184_normalized","smart_184_raw","smart_187_normalized","smart_187_raw",
    "smart_188_normalized","smart_188_raw","smart_189_normalized","smart_189_raw",
    "smart_190_normalized","smart_190_raw","smart_191_normalized","smart_191_raw",
    "smart_192_normalized","smart_192_raw","smart_193_normalized","smart_193_raw",
    "smart_194_normalized","smart_194_raw","smart_195_normalized","smart_195_raw",
    "smart_196_normalized","smart_196_raw","smart_197_normalized","smart_197_raw",
    "smart_198_normalized","smart_198_raw","smart_199_normalized","smart_199_raw",
    "smart_200_normalized","smart_200_raw","smart_201_normalized","smart_201_raw",
    "smart_223_normalized","smart_223_raw","smart_225_normalized","smart_225_raw",
    "smart_240_normalized","smart_240_raw","smart_241_normalized","smart_241_raw",
    "smart_242_normalized","smart_242_raw","smart_250_normalized","smart_250_raw",
    "smart_251_normalized","smart_251_raw","smart_252_normalized","smart_252_raw",
    "smart_254_normalized","smart_254_raw","smart_255_normalized","smart_255_raw"
    ))
  .setOutputCol("features")

val sqlDF_norm = sqlDF.na.fill(0)

val output = assembler.transform(sqlDF_norm)

val aftDF = output.select("label", "censor", "features")


val quantileProbabilities = Array(0.3, 0.6)
val aft = new AFTSurvivalRegression()
  .setQuantileProbabilities(quantileProbabilities)
  .setQuantilesCol("quantiles")

val model = aft.fit(aftDF)
