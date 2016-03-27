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


