from sklearn.datasets import load_iris
from sklearn.svm import LinearSVC

iris = load_iris()

n_samples, n_features = iris.data.shape

n_samples
n_features

iris.target
list(iris.target_names)

X, y = iris.data, iris.target

clf = LinearSVC()
clf

clf = clf.fit(X, y)

clf.coef_
clf.intercept_ 

X_new = [[ 5.0,  3.6,  1.3,  0.25]]
l = clf.predict(X_new)
l


SVM 



