# Useful way to load data using Psycopg. Reference: https://pacuna.io/data-engineering/etl/2018/07/29/etl-postgres-to-postgres.html 
from airflow import DAG
from airflow.hooks.postgres_hook import PostgresHook
from airflow.operators.python_operator import PythonOperator
from datetime import datetime, timedelta
from psycopg2.extras import execute_values

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2018, 4, 29),
    'email': ['email@mail.com'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

dag = DAG('postgres_to_postgres', default_args=default_args,
	schedule_interval='@daily')

def etl(ds, **kwargs):
    execution_date = kwargs['execution_date'].strftime('%Y-%m-%d')
    query = """
SELECT *
FROM users
WHERE created_at::date = date '{}'
    """.format(execution_date)

    src_conn = PostgresHook(postgres_conn_id='source',
                            schema='source_schema').get_conn()
    dest_conn = PostgresHook(postgres_conn_id='dest',
                             schema='dest_schema').get_conn()

    # notice this time we are naming the cursor for the origin table
    # that's going to force the library to create a server cursor
    src_cursor = src_conn.cursor("serverCursor")
    src_cursor.execute(query)
    dest_cursor = dest_conn.cursor()

    # now we need to iterate over the cursor to get the records in batches
    while True:
        records = src_cursor.fetchmany(size=2000)
        if not records:
            break
        execute_values(dest_cursor,
                       "INSERT INTO users VALUES %s",
                       records)
        dest_conn.commit()

    src_cursor.close()
    dest_cursor.close()
    src_conn.close()
    dest_conn.close()

t1 = PythonOperator(
    task_id='etl',
    provide_context=True,
    python_callable=etl,
    dag=dag)