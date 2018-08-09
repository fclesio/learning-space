# Simple trending prpducts recomendation using Python

# Author: Chris Clark (http://blog.untrod.com/2017/02/recommendation-engine-for-trending-products-in-python.md.html)

# Extraction query for each product using 20 days as a criteria of trending.

# SELECT v.product_id
# , -(CURRENT_DATE - si.created_at::date) "age"
# , COUNT(si.id)
# FROM product_variant v
# INNER JOIN schedule_shipmentitem si ON si.variant_id = v.id
# WHERE si.created_at >= (now() - INTERVAL '20 DAYS')
# AND si.created_at < CURRENT_DATE
# GROUP BY 1, 2

# In this section all code is made to see the trend visually

# Import libs
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

# Read the data into a Pandas dataframe
df = pd.read_csv('https://raw.githubusercontent.com/fclesio/learning-space/2b421fbf7d1069438faaa25e62b9b96479b36ffe/Datasets/09%20-%20Recomendation/sample-cart-add-data.csv')

# Group by ID & Age
cart_adds = pd.pivot_table(df, values='count', index=['id', 'age'])

# Get the trend for an specific product
ID = 542
trend = np.array(cart_adds[ID])

# Plot the product average in tle last days
x = np.arange(-len(trend),0)
plt.plot(x, trend, label="Cart Adds")
plt.legend(bbox_to_anchor=(1.05, 1), loc=2, borderaxespad=0.)
plt.title(str(ID))
plt.show()


# Smooting function
def smooth(series, window_size, window):

    # Generate data points 'outside' of x on either side to ensure
    # the smoothing window can operate everywhere
    ext = np.r_[2 * series[0] - series[window_size-1::-1],
                series,
                2 * series[-1] - series[-1:-window_size:-1]]

    weights = window(window_size)
    weights[0:window_size/2] = np.zeros(window_size/2)
    smoothed = np.convolve(weights / weights.sum(), ext, mode='same')
    return smoothed[window_size:-window_size+1]  # trim away the excess data

smoothed = smooth(
    trend,
    7,
    np.hamming
)

# Plot smoothed series
plt.plot(x, smoothed, label="Smoothed")

# Hamming window function
print (np.hamming(7))

# Standarization of the averages to discard low cart-adds of the analysis
def standardize(series):
    iqr = np.percentile(series, 75) - np.percentile(series, 25)
    return (series - np.median(series)) / iqr

smoothed_std = standardize(smoothed)

plt.plot(x, smoothed_std)


# This is the slopes that indicates the trend
slopes = smoothed_std[1:]-smoothed_std[:-1]

plt.plot(x, slopes)


# Final implementation
import pandas as pd
import numpy as np
import operator

SMOOTHING_WINDOW_FUNCTION = np.hamming
SMOOTHING_WINDOW_SIZE = 7

def train():
    df = pd.read_csv('https://raw.githubusercontent.com/fclesio/learning-space/2b421fbf7d1069438faaa25e62b9b96479b36ffe/Datasets/09%20-%20Recomendation/sample-cart-add-data.csv')
    df.sort_values(by=['id', 'age'], inplace=True)
    trends = pd.pivot_table(df, values='count', index=['id', 'age'])

    trend_snap = {}

    for i in np.unique(df['id']):
        trend = np.array(trends[i])
        smoothed = smooth(trend, SMOOTHING_WINDOW_SIZE, SMOOTHING_WINDOW_FUNCTION)
        nsmoothed = standardize(smoothed)
        slopes = nsmoothed[1:] - nsmoothed[:-1]
        # I blend in the previous slope as well, to stabalize things a bit and
        # give a boost to things that have been trending for more than 1 day
        if len(slopes) > 1:
            trend_snap[i] = slopes[-1] + slopes[-2] * 0.5
    return sorted(trend_snap.items(), key=operator.itemgetter(1), reverse=True)

def smooth(series, window_size, window):
    ext = np.r_[2 * series[0] - series[window_size-1::-1],
                series,
                2 * series[-1] - series[-1:-window_size:-1]]
    weights = window(window_size)
    smoothed = np.convolve(weights / weights.sum(), ext, mode='same')
    return smoothed[window_size:-window_size+1]


def standardize(series):
    iqr = np.percentile(series, 75) - np.percentile(series, 25)
    return (series - np.median(series)) / iqr


trending = train()


trending[:10]


# Final implementation
print ("Top 5 Trending Products")
for i,s, in trending[:5]:
    print ("Product %s (Score: %2.2f)" % (i,s))
