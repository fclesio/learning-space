###
### Save Classifier
###
from sklearn.externals import joblib
joblib.dump(clf, 'model/nb.pkl')