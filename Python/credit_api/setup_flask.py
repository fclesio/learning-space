from flask import Flask
from flask.ext.restplus import Api
from flask.ext.restplus import fields
from sklearn.externals import joblib

app = Flask(__name__)

api = Api(
   app, 
   version='1.0', 
   title='Credit API',
   description='A simple Prediction API')

ns = api.namespace('approve_credit', 
   description='Approve Credit Operations')