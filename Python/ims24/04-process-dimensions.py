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
-- dim_address
drop table if exists dw.dim_address;
select
	title as title_key
	,complete_address as address_key
	,city as city_key
	,street
	,postal_code
	,district
	,house_number
into 
	dw.dim_address
from 
	staging.temp_raw_address;


-- dim_city
drop table if exists dw.dim_city;
select
	title as title_key
	,complete_address as address_key
	,city as city_key
	,city
into 
	dw.dim_city
from 
	staging.temp_raw_address;


-- dim_district
drop table if exists dw.dim_district;
select
	title as title_key
	,complete_address as address_key
	,district as district_key
	,district
into 
	dw.dim_district
from 
	staging.temp_raw_address;
	

-- dim_agency
drop table if exists dw.dim_agency;
SELECT 
	 title
	, address as complete_address
	, agency as agency_key
	, agency
into 
	dw.dim_agency	
FROM 
	ods.extracted_raw_table;
"""

cursor = conn.cursor()
cursor.execute(sql_text)
cursor.close()
