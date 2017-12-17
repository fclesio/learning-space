import os
import keras
import numpy as np
from flask import jsonify
from flask import request
from flask import Flask 
from keras.models import model_from_json
from keras.models import load_model

# Let's startup the Flask application
app = Flask(__name__) 

# Model reload from jSON:
print 'Load model...'
json_file = open('models/keras_v1.00_model.json', 'r')
loaded_model_json = json_file.read()
json_file.close()
keras_model_loaded = model_from_json(loaded_model_json)
print 'Model loaded...'

# Weights reloaded from .h5 inside the model
print 'Load weights...'
keras_model_loaded.load_weights("models/keras_v1.00_weights.h5")
print'Weights loaded...'

# Processing data from request and transform inside numpy array
def get_predict_data(data_unprocessed):
    print 'Load data...'
    x = np.array(data_unprocessed)
    print 'Data loaded...'
    return x

# URL that we'll use to make predictions using get and post
@app.route('/predict',methods=['GET','POST'])
def predict():
    x = request.get_data()
    x = x.split(",") 
    x = [x]
    data_processed = get_predict_data(x)
    y_hat = keras_model_loaded.predict(data_processed, batch_size=1, verbose=1)
    return jsonify({'prediction': str(y_hat)}) # This is the result that will be returned in Flask
	
if __name__ == "__main__":
	# Choose the port
	port = int(os.environ.get('PORT', 5000))
	# Run locally
	app.run(host='0.0.0.0', port=port)

# CURL example for some prediction
# $ curl -X POST -d "6,0.0,1,3,2,1,0,0,0,12,0,1" "localhost:5000/predict"
