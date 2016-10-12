###
### Generate Training and Testing Set 
###
from sklearn import cross_validation

"""
    X_1: independent (target) variables for first data set
    Y_1: dependent (outcome) variable for first data set
    X_2: independent (target) variables for the second data set
    Y_2: dependent (outcome) variable for the second data set
"""
X_1, X_2, Y_1, Y_2 = cross_validation.train_test_split(
    target_features, outcome_feature, test_size=0.5, random_state=0)