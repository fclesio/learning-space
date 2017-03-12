curl -X POST \
   --header "Content-Type: application/x-www-form-urlencoded" \
   --header "Accept: application/json" \
   -d "NumberOfOpenCreditLinesAndLoans=12" \
   -d "NumberRealEstateLoansOrLines=0" \
   -d "age=32" \
   -d "DebtRatio=1.247340213" \
   -d "NumberOfDependents=0" \
   -d "MonthlyIncome=12500" \
   -d "RevolvingUtilizationOfUnsecuredLines=0.319779462" \
   -d "NumberOfTimes90DaysLate=12" \
   -d "NumberOfTime60-89DaysPastDueNotWorse=0" \
   -d "NumberOfTime30-59DaysPastDueNotWorse=0" \
   "http://localhost:5000/approve_credit/"