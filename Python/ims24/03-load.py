#!/usr/bin/env python
# -*- coding: utf-8 -*-

import psycopg2
import os
from sqlalchemy import text
from sqlalchemy import create_engine

# Globals
conn = psycopg2.connect(
    host=os.environ['IMS_HOSTNAME'],
    user=os.environ['IMS_USERNAME'],
    password=os.environ['IMS_PASSWORD'],
    dbname=os.environ['IMS_DB_NAME'],
    port=os.environ['IMS_PORT'],
    connect_timeout=5
)
conn.autocommit = True

def get_script_file_and_execute(filename):
    file_read = open(filename, 'r')
    sql_file = file_read.read()
    file_read.close()
    cursor = conn.cursor()
    cursor.execute(sql_file)
    cursor.close()

etls = [ 'analytics-database/sql/03-process-staging.sql',
        'analytics-database/sql/04-process-dimensions.sql',
        'analytics-database/sql/05-process-fact.sql',
        ]

for etl_task in etls:
    print ('########################################')
    print ('Start of ETL stage: ', etl_task)
    get_script_file_and_execute(etl_task)
    print ('End of ETL stage: ', etl_task)
    print ('########################################')

