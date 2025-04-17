from airflow.operators.bash import BashOperator
from datetime import datetime
from airflow import DAG

default_args = {
    "owner": "Bryan Alonso"
}

with DAG(
    dag_id="multiples_tareas",
    description="Ejecucion de multiples tareas en diferentes workers",
    start_date=datetime(2025, 1, 1),
    default_args=default_args,
    tags=["test"],
    schedule="*/5 * * * *",
    catchup=False
) as dag:
    task_A = BashOperator(
        task_id="task_A",
        bash_command="echo 'Inicio tarea A'"
    )
    task_B = BashOperator(
        task_id="task_B",
        bash_command="echo 'Inicio tarea B'"
    )

    task_C = BashOperator(
        task_id="task_C",
        bash_command="echo 'Inicio tarea C'"
    )


    task_D = BashOperator(
        task_id="task_D",
        bash_command="echo 'Inicio tarea D'"
    )

    # flujo de ejecucion
    task_A >> task_B >> task_C >> task_D
