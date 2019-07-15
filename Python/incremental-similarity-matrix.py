# Import libraries to deal with TF-IDF / Cosine Similarity Matrix
import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity, linear_kernel

# Generate DF
df = pd.DataFrame({'jobId' : [1,2,3,4,5], 'serviceId' : [99,88,77,66, 55],
                   'text' : ['Ich hätte gerne ein Bild an meiner Wand.',
                             'Ich will ein Bild auf meinem Auto.',
                             'Ich brauche ein Bild auf meinem Auto.',
                             'Ich brauche einen Rasenmäher für meinen Garten.',
                             'Ich brauche einen Maler, der mein Haus streicht.'
                            ]}) 

# array([[1, 99, 'Ich hätte gerne ein Bild an meiner Wand.'],
#        [2, 88, 'Ich will ein Bild auf meinem Auto.'],
#        [3, 77, 'Ich brauche ein Bild auf meinem Auto.'],
#        [4, 66, 'Ich brauche einen Rasenmäher für meinen Garten.'],
#        [5, 55, 'Ich brauche einen Maler, der mein Haus streicht.']],
#       dtype=object)

# Vectorizer to convert a collection of raw documents to a matrix of TF-IDF features
vectorizer = TfidfVectorizer()

# Learn vocabulary and idf, return term-document matrix.
tfidf = vectorizer.fit_transform(df['text'].values.astype('U'))

# Array mapping from feature integer indices to feature name
words = vectorizer.get_feature_names()

# Compute cosine similarity between samples in X and Y.
similarity_matrix = cosine_similarity(tfidf, tfidf)

# Getting the jobs related in a matrix by Cosine Similarity
cosine_sim_sr = linear_kernel(tfidf, tfidf)

# I have found a way for it to work. Instead of using fit_transform, 
# you need to first fit the new document to the corpus TFIDF matrix like this:
queryTFIDF = TfidfVectorizer().fit(words)

# New text to be consulted
query = 'Mähen Sie das Gras in meinem Garten, pflanzen Sie Blumen in meinem Garten.'

#Now we can 'transform' this vector into that matrix shape by using the transform function:
queryTFIDF = queryTFIDF.transform([query])

# Where query is the query string.
# We can then find cosine similarities and find the 10 most similar/relevant documents: 
cosine_similarities = cosine_similarity(queryTFIDF, tfidf).flatten()

# Get most similar jobs based on next text
related_product_indices = cosine_similarities.argsort()[:-11:-1]
related_product_indices

# array([3, 2, 1, 4, 0])
