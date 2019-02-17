from datetime import datetime
from airflow import DAG
from airflow.operators.dummy_operator import DummyOperator
from airflow.operators.python_operator import PythonOperator

from module  import extraction, load, transform, visualize


dag = DAG('etl-job',
          description='Simple ETL task with IMS24 data',
          schedule_interval='0 * * * *',
          start_date=datetime(2018, 12, 13),
          catchup=False)


start_etl = DummyOperator(task_id='start-etl',
                               retries=3,
                               dag=dag)

end_etl = DummyOperator(task_id='end-etl',
                               retries=3,
                               dag=dag)

data_extraction = PythonOperator(task_id='extraction',
                                python_callable=extraction.main(),
                                dag=dag)

data_transformation = PythonOperator(task_id='transform',
                                     python_callable=transform.main(),
                                     dag=dag)

data_load = PythonOperator(task_id='load',
                           python_callable=load.main(),
                           dag=dag)

data_visualization = PythonOperator(task_id='visualization',
                                    python_callable=load.main(),
                                    dag=dag)

start_etl >> data_extraction >> data_transformation >> data_load >> data_visualization >> end_etl