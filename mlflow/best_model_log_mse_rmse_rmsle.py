# From MLFlow course

import mlflow.sklearn
from sklearn.ensemble import RandomForestRegressor
import math
import numpy as np

# Create functions
# My Post shows how ot create that:
# https://flavioclesio.com/2020/03/22/como-escolher-entre-o-rmse-e-o-rmsle/
def rmse(targets, predictions):
    '''Source: https://stackoverflow.com/questions/17197492/is-there-a-library-function-for-root-mean-square-error-rmse-in-python'''
    return np.sqrt(((predictions - targets) ** 2).mean())

def rmsle(targets, predictions):
    '''Source: https://towardsdatascience.com/metrics-and-python-850b60710e0c'''
    total = 0 
    for k in range(len(predictions)):
        LPred= np.log1p(predictions[k]+1)
        LTarg = np.log1p(targets[k] + 1)
        if not (math.isnan(LPred)) and  not (math.isnan(LTarg)): 
            total = total + ((LPred-LTarg) **2)
        
    total = total / len(predictions)        
    return np.sqrt(total)


with mlflow.start_run(run_name="Best Model Log Lab") as run:
  # Instantiate the model
  rf = RandomForestRegressor(n_estimators=1000,
		max_depth=30)
    
  rf.fit(X_train, y_train)
  predictions = rf.predict(X_test)
  
  # Log model
  mlflow.sklearn.log_model(rf, "random-forest-model")

  # Generate metrics
  mse = mean_squared_error(y_test, predictions)
  rmse = rmse(y_test, predictions)
  rmsle = rmsle(y_test, predictions)
  	
  print(f"MSE: {mse}")
  print(f"RMSE: {rmse}")
  print(f"RMSLE: {rmsle}")

  # Log metrics
  mlflow.log_metric("MSE", mse)
  mlflow.log_metric("RMSE", rmse)
  mlflow.log_metric("RMSLE", rmsle)
  
  runID = run.info.run_uuid
  experimentID = run.info.experiment_id
  
  print(f"Inside MLflow Run with run_id {runID} and experiment_id {experimentID}")
