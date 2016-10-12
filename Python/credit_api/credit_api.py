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


parser = api.parser()
parser.add_argument(
   'RevolvingUtilizationOfUnsecuredLines', 
   type=float, 
   required=True, 
   help='Total balance on credit cards and personal lines of credit except real estate and no installment debt like car loans divided by the sum of credit limits', 
   location='form')
parser.add_argument(
   'age', 
   type=float, 
   required=True, 
   help='Age of borrower in years',
   location='form')
parser.add_argument(
   'NumberOfTime30-59DaysPastDueNotWorse', 
   type=float, 
   required=True, 
   help='Number of times borrower has been 30-59 days past due but no worse in the last 2 years.',
   location='form')
parser.add_argument(
   'DebtRatio', 
   type=float, 
   required=True, 
   help='Monthly debt payments, alimony,living costs divided by monthy gross income',
   location='form')
parser.add_argument(
   'MonthlyIncome', 
   type=float, 
   required=True, 
   help='Monthly income',
   location='form')
parser.add_argument(
   'NumberOfOpenCreditLinesAndLoans', 
   type=float, 
   required=True, 
   help='Number of Open loans (installment like car loan or mortgage) and Lines of credit (e.g. credit cards)',
   location='form')
parser.add_argument(
   'NumberOfTimes90DaysLate', 
   type=float, 
   required=True, 
   help='Number of times borrower has been 90 days or more past due.',
   location='form')
parser.add_argument(
   'NumberRealEstateLoansOrLines', 
   type=float, 
   required=True, 
   help='Number of mortgage and real estate loans including home equity lines of credit',
   location='form')
parser.add_argument(
   'NumberOfTime60-89DaysPastDueNotWorse', 
   type=float, 
   required=True, 
   help='Number of mortgage and real estate loans including home equity lines of credit',
   location='form')
parser.add_argument(
   'NumberOfDependents', 
   type=float, 
   required=True, 
   help='Number of mortgage and real estate loans including home equity lines of credit',
   location='form')



resource_fields = api.model('Resource', {
    'result': fields.String,
})

from flask.ext.restplus import Resource
@ns.route('/')
class CreditApi(Resource):

   @api.doc(parser=parser)
   @api.marshal_with(resource_fields)
   def post(self):
     args = parser.parse_args()
     result = self.get_result(args)

     return result, 201

   def get_result(self, args):
      debtRatio = args["DebtRatio"]
      monthlyIncome = args["MonthlyIncome"]
      dependents = args["NumberOfDependents"]
      openCreditLinesAndLoans = args["NumberOfOpenCreditLinesAndLoans"]
      pastDue30Days = args["NumberOfTime30-59DaysPastDueNotWorse"]
      pastDue60Days = args["NumberOfTime60-89DaysPastDueNotWorse"]
      pastDue90Days = args["NumberOfTimes90DaysLate"]
      realEstateLoansOrLines = args["NumberRealEstateLoansOrLines"]
      unsecuredLines = args["RevolvingUtilizationOfUnsecuredLines"]
      age = args["age"] 

      from pandas import DataFrame
      df = DataFrame([[
         debtRatio,
         monthlyIncome,
         dependents,
         openCreditLinesAndLoans,
         pastDue30Days,
         pastDue60Days,
         pastDue90Days,
         realEstateLoansOrLines,
         unsecuredLines,
         age
      ]])

      clf = joblib.load('model/nb.pkl');

      result = clf.predict(df)
      if(result[0] == 1.0): 
         result = "deny" 
      else: 
         result = "approve"

      return {
         "result": result
      }

if __name__ == '__main__':
    app.run(debug=True)



    