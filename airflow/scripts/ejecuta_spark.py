#!/usr/bin python3
from airflow.providers.sftp.operators.sftp import SFTPOperator
from airflow.providers.apache.spark.operators.spark_submit import SparkSubmitOperator
from datetime import datetime
from airflow import DAG

__author__ = "Bryan Alonso"

default_args= {
    "retries": 0
}

# local filepath
local_filepath="/tmp/dataset_untels.csv"

with DAG(
    dag_id="operaciones_spark",
    description="Operaciones con Spark",
    start_date=datetime(2025, 1, 1),
    catchup=False,
    schedule="*/30 * * * *",
    tags=["mysql"],
    default_args=default_args
) as dag:

    cargar_archivo_servidor = SFTPOperator(
        task_id="carga_archivo_servidor",
        ssh_conn_id="ssh_limnstack01",
        operation="put",
        local_filepath=local_filepath,
        remote_filepath="/tmp/dataset_untels.csv"
    )

    ejecutar_tarea_spark = SparkSubmitOperator(
        task_id="Ejecuta_tarea_spark",
        application="/tmp/process_data.py"
    )

    cargar_archivo_servidor >> ejecutar_tarea_spark
