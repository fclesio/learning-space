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