import org.apache.spark.ml.linalg.Vectors
import org.apache.spark.sql.types._
import spark.implicits._

import org.apache.spark.ml.feature.StringIndexer
import org.apache.spark.sql.DataFrame

// Main Directory
val ROOT_DIR = "/Downloads"

// Load CSV file with Schema inference
var data = spark.read.format("csv")
.option("header", "true")
.load(ROOT_DIR + "/crimes.csv")

// We'll use the view to query using Spark SQL sintax
data.createOrReplaceTempView("crimes")

// Get important columns
val crimesDF = spark.sql("""
	SELECT 
		 Crime_id
		 ,Zona 
		 ,Periculosidade 
		 ,Viaturas_Apoio_Forca_Tatica 
		 ,Patrulhamento 
		 ,Policiamento_Ostensivo 
		 ,Apoio_GCM 
		 ,Arma_Fogo 
		 ,Qtde_Vitimas 
		 ,Possui_DP 
		 ,Tipo_Policiamento 
		 ,Area_Residencial 
		 ,Ocorrencia_Atendida_15_Minutos 
		 ,Pericia 
		 ,Possui_UPP 
		 ,Iluminacao
	FROM 
	  crimes""")

val zonaIndexer = new StringIndexer().setInputCol("Zona").setOutputCol("ZonaIndexed")
val periculosidadeIndexer = new StringIndexer().setInputCol("Periculosidade").setOutputCol("PericulosidadeIndexed")
val viaturas_Apoio_Forca_TaticaIndexer = new StringIndexer().setInputCol("Viaturas_Apoio_Forca_Tatica").setOutputCol("Viaturas_Apoio_Forca_TaticaIndexed")
val patrulhamentoIndexer = new StringIndexer().setInputCol("Patrulhamento").setOutputCol("PatrulhamentoIndexed")
val policiamento_OstensivoIndexer = new StringIndexer().setInputCol("Policiamento_Ostensivo").setOutputCol("Policiamento_OstensivoIndexed")
val apoio_GCMIndexer = new StringIndexer().setInputCol("Apoio_GCM").setOutputCol("Apoio_GCMIndexed")
val arma_FogoIndexer = new StringIndexer().setInputCol("Arma_Fogo").setOutputCol("Arma_FogoIndexed")
val qtde_VitimasIndexer = new StringIndexer().setInputCol("Qtde_Vitimas").setOutputCol("Qtde_VitimasIndexed")
val possui_DPIndexer = new StringIndexer().setInputCol("Possui_DP").setOutputCol("Possui_DPIndexed")
val tipo_PoliciamentoIndexer = new StringIndexer().setInputCol("Tipo_Policiamento").setOutputCol("Tipo_PoliciamentoIndexed")
val area_ResidencialIndexer = new StringIndexer().setInputCol("Area_Residencial").setOutputCol("Area_ResidencialIndexed")
val ocorrencia_Atendida_15_MinutosIndexer = new StringIndexer().setInputCol("Ocorrencia_Atendida_15_Minutos").setOutputCol("Ocorrencia_Atendida_15_MinutosIndexed")
val periciaIndexer = new StringIndexer().setInputCol("Pericia").setOutputCol("PericiaIndexed")
val possui_UPPIndexer = new StringIndexer().setInputCol("Possui_UPP").setOutputCol("Possui_UPPIndexed")
val iluminacaoIndexer = new StringIndexer().setInputCol("Iluminacao").setOutputCol("IluminacaoIndexed")

val zonaIndexedDF = zonaIndexer.fit(crimesDF).transform(crimesDF)
val periculosidadeIndexedDF = periculosidadeIndexer.fit(zonaIndexedDF).transform(zonaIndexedDF)
val viaturas_Apoio_Forca_TaticaIndexedDF = viaturas_Apoio_Forca_TaticaIndexer.fit(periculosidadeIndexedDF).transform(periculosidadeIndexedDF)
val patrulhamentoIndexedDF = patrulhamentoIndexer.fit(viaturas_Apoio_Forca_TaticaIndexedDF).transform(viaturas_Apoio_Forca_TaticaIndexedDF)
val policiamento_OstensivoIndexedDF = policiamento_OstensivoIndexer.fit(patrulhamentoIndexedDF).transform(patrulhamentoIndexedDF)
val apoio_GCMIndexedDF = apoio_GCMIndexer.fit(policiamento_OstensivoIndexedDF).transform(policiamento_OstensivoIndexedDF)
val arma_FogoIndexedDF = arma_FogoIndexer.fit(apoio_GCMIndexedDF).transform(apoio_GCMIndexedDF)
val qtde_VitimasIndexedDF = qtde_VitimasIndexer.fit(arma_FogoIndexedDF).transform(arma_FogoIndexedDF)
val possui_DPIndexedDF = possui_DPIndexer.fit(qtde_VitimasIndexedDF).transform(qtde_VitimasIndexedDF)
val tipo_PoliciamentoIndexedDF = tipo_PoliciamentoIndexer.fit(possui_DPIndexedDF).transform(possui_DPIndexedDF)
val area_ResidencialIndexedDF = area_ResidencialIndexer.fit(tipo_PoliciamentoIndexedDF).transform(tipo_PoliciamentoIndexedDF)
val ocorrencia_Atendida_15_MinutosIndexedDF = ocorrencia_Atendida_15_MinutosIndexer.fit(area_ResidencialIndexedDF).transform(area_ResidencialIndexedDF)
val periciaIndexedDF = periciaIndexer.fit(ocorrencia_Atendida_15_MinutosIndexedDF).transform(ocorrencia_Atendida_15_MinutosIndexedDF)
val possui_UPPIndexedDF = possui_UPPIndexer.fit(periciaIndexedDF).transform(periciaIndexedDF)
val finalIndexedDF = iluminacaoIndexer.fit(possui_UPPIndexedDF).transform(possui_UPPIndexedDF)


finalIndexedDF.createOrReplaceTempView("crimesIndexed")


val df = spark.sql("""
	select 
		'[' || Zona || ', ' || Periculosidade || ', ' || Viaturas_Apoio_Forca_Tatica || ', ' || Patrulhamento || ', ' || Policiamento_Ostensivo || ', ' || Apoio_GCM || ', ' || Arma_Fogo || ', ' || Qtde_Vitimas || ', ' || Possui_DP || ', ' || Tipo_Policiamento || ', ' || Area_Residencial || ', ' || Ocorrencia_Atendida_15_Minutos || ', ' || Pericia || ', ' || Possui_UPP || ', ' || Iluminacao || ']' as items 
	from 
		crimesIndexed
	""")

df.show(3)


// Test 1
val data = spark.sparkContext.textFile(ROOT_DIR + "/crimes_2.csv").cache()
val transactions: RDD[Array[String]] = data.map(s => s.trim.split(','))
val dfTransformed = transactions.toDF

dfTransformed.show(3)

val fpgrowth = new FPGrowth().setItemsCol("value").setMinSupport(0.5).setMinConfidence(0.6)
val model = fpgrowth.fit(dfTransformed)

// Test 2
val dataunique = dataset.distinct()
val fpgrowth = new FPGrowth().setItemsCol("items").setMinSupport(0.5).setMinConfidence(0.6)
val model = fpgrowth.fit(dataunique)

// Teste 3
import org.apache.spark.sql.functions._
import org.apache.spark.sql.expressions._
crimesDF.withColumn("new_column", collect_set("Zona", "Periculosidade").alias('items'))

crimesDF.groupBy("Crime_id") 
  .agg(collect_list("Periculosidade"))
  .agg(collect_list("Zona")) 
  .show() 

// We'll use the view to query using Spark SQL sintax
data.createOrReplaceTempView("crimes")

val dfTransformed = transactions.toD
val dfArray = df.select("items").rdd.map(r => r(0)).collect()

// List of Features to pass to VectorAssembler
val crimesFeatures = Array("Zona" "Periculosidade" "Viaturas_Apoio_Forca_Tatica"
 "Patrulhamento" "Policiamento_Ostensivo" "Apoio_GCM" "Arma_Fogo" "Qtde_Vitimas"
  "Possui_DP" "Tipo_Policiamento" "Area_Residencial"
   "Ocorrencia_Atendida_15_Minutos" "Pericia" "Possui_UPP" "Iluminacao")

// Limitation of the StringIndexer in multiple columns: https://issues.apache.org/jira/browse/SPARK-11215
def includeIndexer(inputCol:String outputCol:String dataFrame:DataFrame) : DataFrame = {
	val indexer = new StringIndexer()
	  .setInputCol(inputCol)
	  .setOutputCol(outputCol)

	 val indexedDF = indexer.fit(dataFrame).transform(dataFrame)
	 
	 return indexedDF
}

// A Vector column with the features
import org.apache.spark.ml.feature.VectorAssembler
val vecAssembler = new VectorAssembler()
val features = vecAssembler
  .setInputCols(crimesFeatures)
  .setOutputCol("features")
  .transform(crimesDF)
