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