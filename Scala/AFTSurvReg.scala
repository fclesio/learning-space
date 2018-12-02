// val test = spark.createDataFrame(Seq(
//   (1.019, 1.0, Vectors.dense(1.934, -0.721))
// )).toDF("label", "censor", "features")

// Faulure Datasets: http://fta.scem.uws.edu.au/index.php?n=Main.DataSets
// Data source: https://www.backblaze.com/b2/hard-drive-test-data.html
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
spark.sql("select datediff(current_timestamp(), date) AS label FROM harddrives").show(3)

val sqlDF = spark.sql("""
	SELECT 
	  datediff(current_timestamp(), date) AS label
	  , failure AS censor
      , smart_1_raw
      , smart_5_raw
      , smart_9_raw
      , smart_194_raw
      , smart_197_raw
	FROM 
	  harddrives""")

val sqlDF_norm = sqlDF.na.fill(0)
sqlDF_norm.show(3)

val newDf = sqlDF_norm.select(sqlDF_norm.columns.map(c => col(c).cast(DoubleType)) : _*)
newDf.show(3)
newDf.printSchema()

val assembler = new VectorAssembler()
  .setInputCols(Array(
    "smart_1_raw", "smart_5_raw",
    "smart_9_raw", "smart_194_raw",
    "smart_197_raw"
    ))
  .setOutputCol("features")


val output = assembler.transform(newDf)
output.show(3)

val aftDF = output.select("label", "censor", "features")

aftDF.show(3)

val quantileProbabilities = Array(0.3, 0.6)
val aft = new AFTSurvivalRegression()
  .setQuantileProbabilities(quantileProbabilities)
  .setQuantilesCol("quantiles")

val model = aft.fit(aftDF)
