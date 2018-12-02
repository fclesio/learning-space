// =======================================================
// =============== Training and Test =====================
// =======================================================

// Dataset: https://raw.githubusercontent.com/fclesio/learning-space/master/Datasets/02%20-%20Classification/default_credit_card.csv
import org.apache.spark.ml.classification.DecisionTreeClassificationModel
import org.apache.spark.ml.classification.DecisionTreeClassifier
import org.apache.spark.ml.evaluation.MulticlassClassificationEvaluator
import org.apache.spark.ml.feature.VectorAssembler
import org.apache.spark.ml.linalg.Vectors
import org.apache.spark.ml.{Pipeline, PipelineModel}
import org.apache.spark.sql.types._
import spark.implicits._

// Main Directory
val ROOT_DIR = "/Users/flavioclesio/Downloads/default_dataset/"

// Load CSV file with Schema inference
var data = spark.read.format("csv")
.option("header", "true")
.load(ROOT_DIR + "train/default_credit_card.csv")

// Convert all dataframe to Double
val newDf = data.select(data.columns.map(c => col(c).cast(DoubleType)) : _*)

// We'll use the view to query using Spark SQL sintax
newDf.createOrReplaceTempView("loans")

// Get important columns
val sqlDF = spark.sql("""
	SELECT 
	  LIMIT_BAL
      , SEX
      , EDUCATION
      , MARRIAGE
      , AGE
      , PAY_0
      , PAY_2
      , PAY_3
      , PAY_4
      , PAY_5
      , PAY_6
      , BILL_AMT1
      , BILL_AMT2
      , BILL_AMT3
      , BILL_AMT4
      , BILL_AMT5
      , BILL_AMT6
      , PAY_AMT1
      , PAY_AMT2
      , PAY_AMT3
      , PAY_AMT4
      , PAY_AMT5
      , PAY_AMT6
      , DEFAULT
	FROM 
	  loans""")

// Check Schema
//sqlDF.printSchema()

// List of Features to pass to VectorAssembler
val lenderFeatures = Array("LIMIT_BAL","SEX","EDUCATION","MARRIAGE","AGE"
,"PAY_0","PAY_2","PAY_3","PAY_4","PAY_5","PAY_6"
,"BILL_AMT1","BILL_AMT2","BILL_AMT3","BILL_AMT4","BILL_AMT5","BILL_AMT6"
,"PAY_AMT1","PAY_AMT2","PAY_AMT3","PAY_AMT4","PAY_AMT5","PAY_AMT6")

// A Vector column with the features
val vecAssembler = new VectorAssembler()
val features = vecAssembler
  .setInputCols(lenderFeatures)
  .setOutputCol("features")
  .transform(sqlDF)

// Split the data into training and test sets (30% held out for testing).
val Array(trainingData, testData) = features.randomSplit(Array(0.8, 0.1))

// Train a DecisionTree model.
val dt = new DecisionTreeClassifier()
  .setLabelCol("DEFAULT")
  .setFeaturesCol("features")

// Chain indexers and tree in a Pipeline.
val pipeline = new Pipeline()
  .setStages(Array(dt))

// Train model. This also runs the indexers.
val model = pipeline.fit(trainingData)

// Make predictions.
val predictions = model.transform(testData)

// Select example rows to display.
// predictions.select("DEFAULT","prediction","probability","features").show(5)

// Shape of the Decicion tree
val treeModel = model.stages(0).asInstanceOf[DecisionTreeClassificationModel]
println(s"Learned classification tree model:\n ${treeModel.toDebugString}")

// Select (prediction, true label) and compute test error.
val evaluator = new MulticlassClassificationEvaluator()
  .setLabelCol("DEFAULT")
  .setPredictionCol("prediction")
  .setMetricName("accuracy")
val accuracy = evaluator.evaluate(predictions)

println("#################################")
println(s"Test Error = ${(1.0 - accuracy)}")
println("#################################")

// Save model
model.write.overwrite().save(ROOT_DIR + "model/dt_default_model.model")

// ============================================
// ================ Validation ================ 
// ============================================

//Function to get the model, load, and perform the predictions
def getFinalScorelending(loanCandidate:String, rootDirectory:String) : String = {
	import org.apache.spark.ml.classification.DecisionTreeClassificationModel
	import org.apache.spark.ml.classification.DecisionTreeClassifier
	import org.apache.spark.ml.evaluation.MulticlassClassificationEvaluator
	import org.apache.spark.ml.feature.VectorAssembler
	import org.apache.spark.ml.linalg.Vectors
	import org.apache.spark.ml.{Pipeline, PipelineModel}
	import org.apache.spark.sql.types._
	import spark.implicits._

	// Root Drectory
	val ROOT_DIR = rootDirectory

	// Load Model
	val pipelineDefaultModel = PipelineModel.read.load(ROOT_DIR + "model/dt_default_model.model")

	// Get the load candidate
	val rootDir = loanCandidate

	// Load CSV file according the schema
	var data = spark.read.format("csv")
	.option("header", "true")
	.load(rootDir)

	// Change all columns to DoubleType
	val validationDF = data.select(data.columns.map(c => col(c).cast(DoubleType)) : _*)

	// Lender features
	val lenderFeaturesValidation = Array("LIMIT_BAL","SEX","EDUCATION","MARRIAGE","AGE"
		,"PAY_0","PAY_2","PAY_3","PAY_4","PAY_5","PAY_6"
		,"BILL_AMT1","BILL_AMT2","BILL_AMT3","BILL_AMT4","BILL_AMT5","BILL_AMT6"
		,"PAY_AMT1","PAY_AMT2","PAY_AMT3","PAY_AMT4","PAY_AMT5","PAY_AMT6")

	// A Vector column with the features
	val vecAssembler = new VectorAssembler()
	val featuresValidation = vecAssembler
	.setInputCols(lenderFeaturesValidation)
	.setOutputCol("features")
	.transform(validationDF)

	// Get infos to validate the risk and the final result of our lender
	val predictValidation = pipelineDefaultModel.transform(featuresValidation);
	val lendFinalScore = predictValidation.select("prediction").take(1)(0);
	val lendProbabilities = predictValidation.select("probability").take(1)(0)(0).toString.replace("[","").replace("]","").split(",")
	val thresholdCredit: Int = 0;
	val scoreCredit = lendFinalScore(0).toString.toDouble;

	// Info about the Risk
	println("Probability Risk - Default Probability: %", lendProbabilities(1).toDouble * 100)
	
	// Final Decision
	if(scoreCredit > thresholdCredit){
		println("DENIAL: High Default Risk")
		return "DENIAL: High Default Risk";
	} else {
		println("APROVED")
		return "APROVED";
	}
}


// Get info of the model and the candidate
val ROOT_DIR = "/Users/flavioclesio/Downloads/default_dataset/"
val loanCandidateInfo = ROOT_DIR + "candidates_raw_data/loan_candidate_18.csv"

// Get prediction using function
val finalScore = getFinalScorelending(loanCandidateInfo, ROOT_DIR)

// (Probability Risk - Default Probability: %,67.67068273092369)
// DENIAL: High Default Risk
