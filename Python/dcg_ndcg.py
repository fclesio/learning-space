import numpy as np


def dcg_at_k(r, k):
    """
       Discounted Cumulative Gain in Top-K Records
       Reference: https://en.wikipedia.org/wiki/Discounted_cumulative_gain

       Parameters
       ----------
       r : Array
        Description : Array with all recommendations relevance for each position

       k : Integer
        Description : Qty of positions ranked that we're getting from the query

       Returns
       -------
       dcg_max : Integer
           DCG calculated based in the recommendations
    """

    r = np.asfarray(r)[:k]
    dcg_max = np.sum(r / np.log2(np.arange(2, r.size + 2)))
    dcg_max = round(dcg_max, 3)
    return dcg_max


def ndcg_at_k(r, k):
    """
       Normalized Discounted Cumulative Gain in Top-K Records
       Reference: https://en.wikipedia.org/wiki/Discounted_cumulative_gain

       Parameters
       ----------
       r : Array
        Description : Array with all recomendations relevance for each position

       k : Integer
        Description : Qty of positions ranked that we're getting from the query

       Returns
       -------
       r : Integer
           Number of elements brought by the query

       k : Integer
           Qty of positions ranked that we're getting from the query

       dcg : Integer
           DCG calculated based in the recommendations

       idcg : Integer
           IDCG calculated based in the recommendations

       ndcg : Integer
           nDCG calculated based in the recommendations
    """
    dcg = dcg_at_k(r=r, k=k)
    r = sorted(r, reverse=True)
    idcg = dcg_at_k(r=r, k=k)
    ndcg = round((dcg / idcg) if idcg > 0.0 else 0.0, 3)

    return r, k, dcg, idcg, ndcg


# Recommendations score
position_1 = 3
position_2 = 2
position_3 = 3
position_4 = 0
position_5 = 1
position_6 = 2

position_7 = 3
position_8 = 2

# Parameters for DCG
k_results = 6

# This will be the relevance array to be passed for the method
relevance_scores = [position_1,
                    position_2,
                    position_3,
                    position_4,
                    position_5,
                    position_6,

                    position_7,
                    position_8,
                    ]

# Get all relevance metrics
r, k, dcg, idcg, ndcg = ndcg_at_k(r=relevance_scores, k=k_results)

# Get info about the relevance metrics
print(f'Elements: {len(r)}')
print(f'K: {k}')
print(f'DCG: {dcg}')
print(f'IDCG: {idcg}')
print(f'nDCG: {ndcg}')

# Elements: 8
# K: 6
# DCG: 6.861
# IDCG: 8.74
# nDCG: 0.785
