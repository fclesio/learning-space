import pandas as pd

###
### Load Data Set
###
df=pd.read_csv(
    'cs-training.csv', 
    sep=',',
    header=0)
data = df.drop(
    df.columns[0], 
    axis=1)

# Drop rows with missing column data
data = data.dropna()

###
### Convert Data Into List Of Dict Records
###
data = data.to_dict(orient='records')

###
### Seperate Target and Outcome Features
###
from sklearn.feature_extraction import DictVectorizer
from pandas import DataFrame
vec = DictVectorizer()

df_data = vec.fit_transform(data).toarray()
feature_names = vec.get_feature_names()
df_data = DataFrame(
    df_data,
    columns=feature_names)
    
outcome_feature = df_data['SeriousDlqin2yrs']
target_features = df_data.drop('SeriousDlqin2yrs', axis=1)