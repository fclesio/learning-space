# The following two commands remove any previously installed H2O packages for R.
if ("package:h2o" %in% search()) { detach("package:h2o", unload=TRUE) }
if ("h2o" %in% rownames(installed.packages())) { remove.packages("h2o") }

# Next, we download packages that H2O depends on.
if (! ("methods" %in% rownames(installed.packages()))) { install.packages("methods") }
if (! ("statmod" %in% rownames(installed.packages()))) { install.packages("statmod") }
if (! ("stats" %in% rownames(installed.packages()))) { install.packages("stats") }
if (! ("graphics" %in% rownames(installed.packages()))) { install.packages("graphics") }
if (! ("RCurl" %in% rownames(installed.packages()))) { install.packages("RCurl") }
if (! ("jsonlite" %in% rownames(installed.packages()))) { install.packages("jsonlite") }
if (! ("tools" %in% rownames(installed.packages()))) { install.packages("tools") }
if (! ("utils" %in% rownames(installed.packages()))) { install.packages("utils") }

# Now we download, install and initialize the H2O package for R.
install.packages("h2o", type="source", repos=(c("http://h2o-release.s3.amazonaws.com/h2o/rel-turing/8/R")))

# Load library
library(h2o)

# Start instance with all cores
h2o.init(nthreads = -1, max_mem_size = "8G")

# Clean state
h2o.removeAll()

# Info about cluster
h2o.clusterInfo()

# Production Cluster (Not applicable because we're using in the same machine)
#localH2O <- h2o.init(ip = '10.112.81.210', port =54321, nthreads=-1) # Server 1
#localH2O <- h2o.init(ip = '10.112.80.74', port =54321, nthreads=-1) # Server 2

# Random Forests

# URL with data
LaymanBrothersURL = "https://raw.githubusercontent.com/fclesio/learning-space/master/Datasets/02%20-%20Classification/default_credit_card.csv"

# Load data 
creditcard.hex = h2o.importFile(path = LaymanBrothersURL, destination_frame = "creditcard.hex")

# Convert DEFAULT, SEX, EDUCATION, MARRIAGE variables to categorical
creditcard.hex[,25] <- as.factor(creditcard.hex[,25]) # DEFAULT
creditcard.hex[,3] <- as.factor(creditcard.hex[,3]) # SEX
creditcard.hex[,4] <- as.factor(creditcard.hex[,4]) # EDUCATION
creditcard.hex[,5] <- as.factor(creditcard.hex[,5]) # MARRIAGE

# Let's see the summary
summary(creditcard.hex)

# We'll get 3 dataframes Train (60%), Test (20%) and Validation (20%)
creditcard.split = h2o.splitFrame(data = creditcard.hex
                                  ,ratios = c(0.6,0.2)
                                  ,destination_frames = c("creditcard.train.hex", "creditcard.test.hex", "creditcard.validation.hex")
                                  ,seed = 12345)

# Get the train dataframe(1st split object)
creditcard.train = creditcard.split[[1]]

# Get the test dataframe(2nd split object)
creditcard.test = creditcard.split[[2]]

# Get the validation dataframe(3rd split object)
creditcard.validation = creditcard.split[[3]]

# Set dependent variable
Y = "DEFAULT"

# Set independent variables
X = c("LIMIT_BAL","EDUCATION","MARRIAGE","AGE"
      ,"PAY_0","PAY_2","PAY_3","PAY_4","PAY_5","PAY_6"
      ,"BILL_AMT1","BILL_AMT2","BILL_AMT3","BILL_AMT4","BILL_AMT5","BILL_AMT6"
      ,"PAY_AMT1","PAY_AMT3","PAY_AMT4","PAY_AMT5","PAY_AMT6")


# Deep Learning
args(h2o.deeplearning)
help(h2o.deeplearning)
example(h2o.deeplearning)



model <- h2o.deeplearning(x = X,
                          y = Y,
                          model_id="dl_model_first",
                          training_frame = creditcard.train, 
                          validation_frame = creditcard.validation,
                          activation = "TanhWithDropout", 
                          input_dropout_ratio = 0.02,
                          overwrite_with_best_model=F,
                          distribution = "bernoulli",
                          hidden_dropout_ratios = c(0.3,0.3,0.3),
                          balance_classes = TRUE, 
                          hidden = c(100,100,500),
                          epochs = 1000,
                          variable_importances=T,
                          stopping_metric="AUC",
                          stopping_tolerance=0.001,
                          adaptive_rate=F,
                          rate=0.001, 
                          rate_annealing=2e-6,            
                          momentum_start=0.2,
                          momentum_ramp=1e7, 
                          l1=1e-5,
                          l2=1e-5)

x = Variável dependente. 
y = Variáveis independentes usadas para treinamento. 
model_id = Nome do modelo. 
training_frame = Dataset usado para treinamento. 
validation_frame = Dataset usado para validação.
activation = Função de ativação. 
input_dropout_ratio = Uma fração de atributos que será omitida durante o treinamento para melhoria da generalização.
overwrite_with_best_model = Se essa opção estiver como TRUE há uma sobreposição (overwrite) pelo melhor modelo. 
distribution = O tipo de distribuição das variáveis que estão no conjunto de treinamento.
hidden_dropout_ratios = Índice do dropout para cada camada escondida. 
balance_classes = Faz o balanceamento das classes para evitar algum tipo de viés de amostragem no modelo. 
hidden = Tamanho das camadas escondidas
epochs = Número de épocas, i.e. quantidade de vezes que o conjunto de treinamento vai passar pela rede.
variable_importances = Se estiver como TRUE mostra no sumário a importância de cada uma das variáveis no modelo 
stopping_metric = Métrica usada para checagem de convergência da rede. 
stopping_tolerance = É o número mínimo de tolerancia para parar o processamento da rede. 
adaptive_rate = Se estiver como TRUE o H2O faz automaticamente a atribuição da taxa de aprendizado, ou Learning Rate. 
rate = Learning rate. Se estiver alta, é menos estável, se for menor tem uma convergência mais demorada. 
rate_annealing = Emula o mecanismo de otimização Simulated Anealing, porém, neste caso a otimização ocorre no Learning Rate. Fórmula: (rate)/(1 + rate_annealing*samples) 
momentum_start = O momentum inicial do treinamento. 
momentum_ramp = Número de amostras no qual o momentum aumenta. 
l1 = Regularização L1 (LASSO) - Pode haver pesos convergindo para zero.  
l2 = Regularização L2 (Rigde) - Pode haver pesos com um valor muito reduzido. 


# AUC:  0.7703728


summary(model)

## Using the DNN model for predictions
model_dl <- h2o.predict(model, creditcard.test)

## Converting H2O format into data frame
pred_dl <- as.data.frame(model_dl)

head(pred_dl)

# Grid Search

hyper_params <- list(
  hidden=list(c(32,32,32),c(64,64)),
  input_dropout_ratio=c(0,0.05),
  rate=c(0.001,0.005)
)

search_criteria = list(strategy = "Cartesian")
                       
hyper_params

grid <- h2o.grid(
  algorithm="deeplearning",
  grid_id="dl_grid", 
  training_frame=creditcard.train,
  validation_frame=creditcard.validation, 
  x=X, 
  y=Y,
  epochs=1000,
  stopping_metric="AUC",
  stopping_tolerance=0.001,
  stopping_rounds=15,
  adaptive_rate=F, 
  momentum_start=0.2,
  momentum_stable=0.9, 
  momentum_ramp=1e7, 
  l1=1e-5,
  variable_importances=T,
  rate_annealing=2e-6,
  l2=1e-5,
  seed=12345,
  activation=c("TanhWithDropout"),
  search_criteria = search_criteria,
  hyper_params=hyper_params
)


grid


# sort the grid models by decreasing AUC
sortedGrid <- h2o.getGrid("dl_grid", sort_by="auc", decreasing = TRUE)    

# Let's see our models
sortedGrid

# Grab the model_id based in AUC
best_glm_model_id <- sortedGrid@model_ids[[1]]

# The best model
best_glm <- h2o.getModel(best_glm_model_id)

# Summary
summary(best_glm)
