#!/usr/bin/env python
# coding: utf-8

import pandas as pd
import psycopg2
import os
import logging
import time
import seaborn as sns; sns.set(color_codes=True)
import matplotlib.pyplot as plt
from sqlalchemy import text
from sqlalchemy import create_engine


# Get environment variables
host = os.environ['IMS_HOSTNAME']
user = os.environ['IMS_USERNAME']
password = os.environ['IMS_PASSWORD']
dbname = os.environ['IMS_DB_NAME']
port = os.environ['IMS_PORT']

# Create connection to the database
engine_string = 'postgresql://%s:%s@%s:%s/%s' % (user, password, host, port, dbname)
engine = create_engine(engine_string)

# Data extraction
sql = """
--Flats per district
select
  B.district
  ,CAST(AVG(total_amount) as numeric(16,2)) as average_price
  ,CAST(MAX(total_amount) as numeric(16,2)) as max_price
  ,CAST(MIN(total_amount) as numeric(16,2)) as min_price
  ,CAST(AVG(room) as INT) as average_rooms
  ,CAST(MAX(room) as INT) as max_rooms
  ,CAST(MIN(room) as INT) as min_rooms
  ,COUNT(*) qty_flats
from 
  dw.fact_flat A 
  join dw.dim_district B on B.title_key = A.title_key
group by 
  B.district  
order by 
  8 desc, 2 desc;
"""

# Get data
df = pd.read_sql(sql, engine)


class Visualize(object):
    def __init__(self):
        super(Visualize, self).__init__()

    @staticmethod
    def get_relation_avg_rooms_avg_price():
        # ### Relationship between Avg # Rooms x Avg Price
        ax = sns.regplot(x="average_price", y="average_rooms", data=df, label=True)
        ax.set_title('Relationship between Avg # Rooms x Avg Price')
        fig = ax.get_figure()
        fig.savefig("visual_insights/01_relation_avg_rooms_avg_price.png", dpi=400)

    @staticmethod
    def get_distribution_avg_price():
        # ### Distribution of Avg Price
        ax = sns.distplot(df['average_price'])
        ax.set_title('Distribution of Avg Price')
        fig = ax.get_figure()
        fig.savefig("visual_insights/02_distribution_avg_price.png", dpi=400)

    @staticmethod
    def get_distribution_qty_flats():
        # ### Distribution of the Flats
        ax = sns.distplot(df['qty_flats'])
        ax.set_title('Distribution of the Flats')
        fig = ax.get_figure()
        fig.savefig("visual_insights/03_distribution_qty_flats.png", dpi=400)

    @staticmethod
    def get_relation_avg_price_max_price():
        # ### Relationship between Avg Price x Max Price
        ax = sns.jointplot(x="average_price", y="max_price", data=df, label='Relationship between Avg Price x Max Price', kind="hex", color="k")
        ax.savefig("visual_insights/04_relation_avg_price_max_price.png", dpi=400)

    @staticmethod
    def get_relation_avg_price_avg_rooms():
        # ### Relationship between Avg Price x Avg Rooms
        ax = sns.jointplot(x="average_price", y="average_rooms", data=df, label=True, kind="kde")
        ax.savefig("visual_insights/05_relation_avg_price_avg_rooms.png")

    @staticmethod
    def get_correlogram_main_metrics():
        # ### Correlogram using main metrics
        ax = sns.pairplot(df[['average_price', 'average_rooms','min_price', 'min_rooms']], kind="reg")
        ax.savefig("visual_insights/06_correlogram_main_metrics.png", dpi=400)



def main():
    visual = Visualize()
    visual.get_distribution_avg_price()
    visual.get_distribution_qty_flats()
    visual.get_relation_avg_price_avg_rooms()
    visual.get_relation_avg_price_max_price()
    visual.get_relation_avg_rooms_avg_price()
    visual.get_correlogram_main_metrics()


if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO)
    logging.info('Visual Insights Started ...')
    start_time = time.time()

    main()

    logging.info('Visual Insights finished ...')
    elapsed_time = time.time() - start_time
    logging.info('Elapsed Time: %s', elapsed_time)
