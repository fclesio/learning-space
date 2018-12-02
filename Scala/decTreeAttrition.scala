// Dataset: https://raw.githubusercontent.com/fclesio/learning-space/master/Datasets/02%20-%20Classification/attrition.csv
import org.apache.spark.ml.feature.VectorAssembler
import org.apache.spark.ml.linalg.Vectors
import org.apache.spark.ml.regression.AFTSurvivalRegression
import org.apache.spark.sql.types._

// File storage
val rootDir = "/Users/flavioclesio/Downloads/attrition.csv"

import spark.implicits._
// Load CSV file according the schema
var data = spark.read.format("csv")
.option("header", "true")
.load(rootDir)

val newDf = data.select(data.columns.map(c => col(c).cast(DoubleType)) : _*)

val dataset = newDf.select("Gender","Age","Income","FamilySize","Education","Calls","Visits","Churn")

dataset.printSchema()

// A Vector column with the features
val vecAssembler = new VectorAssembler()
val features = vecAssembler
  .setInputCols(Array("Gender","Age","Income","FamilySize","Education","Calls","Visits"))
  .setOutputCol("features")
  .transform(dataset)

features.printSchema()

features.show(5)


// Split the data into training and test sets (30% held out for testing).
val Array(trainingData, testData) = features.randomSplit(Array(0.7, 0.3))

// Train a DecisionTree model.
val dt = new DecisionTreeClassifier()
  .setLabelCol("Churn")
  .setFeaturesCol("features")

// Chain indexers and tree in a Pipeline.
val pipeline = new Pipeline()
  .setStages(Array(dt))


// Train model. This also runs the indexers.
val model = pipeline.fit(trainingData)

// Make predictions.
val predictions = model.transform(testData)

// Select example rows to display.
predictions.select("Churn", "Churn", "features").show(5)


// Select (prediction, true label) and compute test error.
val evaluator = new MulticlassClassificationEvaluator()
  .setLabelCol("Churn")
  .setPredictionCol("prediction")
  .setMetricName("accuracy")
val accuracy = evaluator.evaluate(predictions)
println(s"Test Error = ${(1.0 - accuracy)}")


val treeModel = model.stages(0).asInstanceOf[DecisionTreeClassificationModel]
println(s"Learned classification tree model:\n ${treeModel.toDebugString}")

