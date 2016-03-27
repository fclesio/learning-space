from lifelines.datasets import load_waltons
df = load_waltons() # returns a Pandas DataFrame

print df.head()


T = df['T']
E = df['E']


from lifelines import KaplanMeierFitter
kmf = KaplanMeierFitter()
kmf.fit(T, event_observed=E) # more succiently, kmf.fit(T,E)


kmf.survival_function_
kmf.median_
kmf.plot()




#     Multiple groups
groups = df['group']
ix = (groups == 'miR-137')

kmf.fit(T[~ix], E[~ix], label='control')
ax = kmf.plot()

kmf.fit(T[ix], E[ix], label='miR-137')
kmf.plot(ax=ax)





from lifelines import NelsonAalenFitter
naf = NelsonAalenFitter()
naf.fit(T, event_observed=E)


#but instead of a survival_function_ being exposed, a cumulative_hazard_ is.








#Survival Regression

from lifelines.datasets import load_regression_dataset
regression_dataset = load_regression_dataset()

regression_dataset.head()






from lifelines import AalenAdditiveFitter, CoxPHFitter

# Using Cox Proportional Hazards model
cf = CoxPHFitter()
cf.fit(regression_dataset, 'T', event_col='E')
cf.print_summary()

# Using Aalen's Additive model
aaf = AalenAdditiveFitter(fit_intercept=False)
aaf.fit(regression_dataset, 'T', event_col='E')






x = regression_dataset[regression_dataset.columns - ['E','T']]
aaf.predict_survival_function(x.ix[10:12]).plot() #get the unique survival functions of the first two subjects



aaf.plot()









