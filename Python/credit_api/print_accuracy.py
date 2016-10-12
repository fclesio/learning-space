###
### Print Accuracy and Confusion Matrix
###

output = clf.predict(X_2)

from sklearn.metrics import confusion_matrix
matrix = confusion_matrix(output, Y_2)
score = clf.score(X_2, Y_2)
print "accuracy: {0}".format(score.mean())
print matrix