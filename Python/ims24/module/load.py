#!/usr/bin/env python
# -*- coding: utf-8 -*-

import psycopg2
import os
import logging

# Get Connections
try:
    print("Opening Connection")
    conn = psycopg2.connect(host=os.environ['IMS_HOSTNAME'],
                            user=os.environ['IMS_USERNAME'],
                            password=os.environ['IMS_PASSWORD'],
                            dbname=os.environ['IMS_DB_NAME'],
                            port=os.environ['IMS_PORT'],
                            connect_timeout=5)
    conn.autocommit = True
except Exception as e:
    print(e)
    print("ERROR: Could not connect into Analytics database. Check the connection.")
    raise e


class Load(object):
    def __init__(self):
        super(Load, self).__init__()

    @staticmethod
    def run_load():
        etls = [ 'analytics-database/sql/03-process-staging.sql',
                'analytics-database/sql/04-process-dimensions.sql',
                'analytics-database/sql/05-process-fact.sql',
                ]

        for etl_task in etls:
            print ('########################################')
            print ('Start of ETL stage: ', etl_task)

            print('Reading .sql file')
            file_read = open(etl_task, 'r')
            sql_file = file_read.read()
            file_read.close()
            cursor = conn.cursor()

            print("Open cursor")
            cursor.execute(sql_file)
            cursor.close()

            print ('End of ETL stage: ', etl_task)
            print ('########################################')

def main():
    load = Load()
    load.run_load()

if __name__ == '__main__':
    print 'Start Load Phase...'
    main()
    print 'End Load Phase'
