#!/usr/bin/env python
# -*- coding: utf-8 -*-

import psycopg2
import os
from sqlalchemy import text
from sqlalchemy import create_engine

engine = create_engine('postgresql://postgres:@0.0.0.0:5432/analytics_ims', client_encoding='utf8')

# Globals
conn = psycopg2.connect(
    # host=os.environ['IMS_HOSTNAME'],
    # user=os.environ['IMS_USERNAME'],
    # password=os.environ['IMS_PASSWORD'],
    # dbname=os.environ['IMS_DB_NAME'],
    # port=os.environ['IMS_PORT'],
    # connect_timeout=5

    host='0.0.0.0',
    user='postgres',
    password='',
    dbname='analytics_ims',
    port='5432',
    connect_timeout=5

)
conn.autocommit = True

sql_text = """
-- fact_flat
drop table if exists dw.fact_flat;
SELECT 
	 title as title_key
	, address as address_key
	, title
	, address as complete_address
	, apartment_type
	, "floor" as floor_number
	, square_meters
	, availability
	, room
	, sleep_room
	, bathroom
	, district as district_key
	, animals_allowed
	, base_rent
	, aditional_costs
	, heater_tax
	, total_amount
	, initial_deposit
	, agency as agency_key
	, url
into 
	dw.fact_flat
FROM 
	ods.extracted_raw_table;
"""

cursor = conn.cursor()
cursor.execute(sql_text)
cursor.close()
