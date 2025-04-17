#!/usr/env bin python3
from airflow import DAG
from datetime import datetime
from airflow.providers.http.operators.http import HttpOperator

import logging

logging.warning("Empieza la ejecucion del DAG")

default_args = {
    "retries": 1,
}

with DAG(
    dag_id="operations_jsonplaceholder",
    description="Ejecuta operaciones básicas PlaceHolder",
    start_date=datetime(2025, 1, 1),
    default_args=default_args,
    tags=["http", "jsonplaceholder"],
    schedule="*/5 * * * *",
    catchup=False
) as dag:
    task_invoke_jsonplace=HttpOperator(
        task_id="get_users",
        http_conn_id="http_jsonplaceholder",
        endpoint="/todos/1",
        method="get",
        headers={"Content-Type": "application/json"},
    )
    task_invoke_jsonplace
