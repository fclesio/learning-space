ImmobilienScout24 Wrapper and DWH
-------------------

The main function of this application it's to get information about Berlin flats to rent with some basic information and build a DWH on the top of docker and at the end have some insights about the housing market in Berlin.

Requirements
--------------------
- `docker`
- `docker-compose`
- `grab`
- `sqlalchemy`
- `pandas`
- `psycopg2`
- `time`
- `logging`
- `jupyter`

Folders
--------------------

What's inside the project:

* `Module`: Python scripts that builds all the `ETL` phases. 

* `Analytics Database`: `docker-compose` file and database hosting folder. 



Environment Variables
--------------------
- `export IMS_HOSTNAME='0.0.0.0';`
- `export IMS_USERNAME='postgres';`
- `export IMS_PASSWORD='';`
- `export IMS_DB_NAME='analytics_ims';`
- `export IMS_PORT='5432'`




Instructions
--------------------
 - a) Start the database in the docker: `analytics-database: $ docker-compose up` 
 
 - b) Connect in the database: `$ psql -h 0.0.0.0 -d postgres -U postgres`
 
 - d) Create the analytics database:  `postgres=# create database analytics_ims;`
 
 - e) Connect to the database: `postgres=# \connect analytics_ims` 
 
 - f) Create the schemas: 
    - `analytics_ims=# create schema ods;`  
    - `analytics_ims=# create schema staging;` 
    - `analytics_ims=# create schema dw;` 
 
 - g) Create the raw table: `sql: $ psql -h 0.0.0.0 -d analytics_ims -U postgres -f 00-raw-table-creation.sql`
 
 - h) Run the script: `ims24: $ python main.py`