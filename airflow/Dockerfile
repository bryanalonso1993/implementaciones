FROM apache/airflow:latest
USER root
RUN apt-get update && \
    apt-get install -y openjdk-17-jdk
USER airflow
RUN pip install \
    apache-airflow-providers-http \
    apache-airflow-providers-mysql \
    apache-airflow-providers-ssh \
    apache-airflow-providers-apache-spark \
    apache-airflow-providers-elasticsearch

# Opcional: instala paquetes adicionales si querés
# RUN pip install pandas requests boto3

# Copiá tus DAGs si querés empaquetarlos dentro
# COPY dags/ /opt/airflow/dags/

# Entrypoint ya lo maneja la imagen oficial