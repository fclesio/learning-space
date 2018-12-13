ImmobilienScout24 Wrapper and DWH
-------------------




Folders
--------------------

What's inside the project:

* Module

* Analytics Database

Instructions
--------------------
 - a) `analytics-database: $ docker-compose up` 
 
 - b) `$ psql -h 0.0.0.0 -d postgres -U postgres`
 
 - c) `postgres=# \connect analytics_ims` 
 
 - d) `analytics_ims=# create schema ods;`  

 - e) `analytics_ims=# create schema staging;` 

 - f) `analytics_ims=# create schema dw;` 
 
 - g) `sql: $ psql -h 0.0.0.0 -d analytics_ims -U postgres -f 00-raw-table-creation.sql`
 
 - h) `ims24: $ python main.py`

