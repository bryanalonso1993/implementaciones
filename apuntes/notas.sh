# anotar los cambios de un deployments
kubectl annotate deployment -l app=airflow kubernetes.io/change-cause="Cambio global en Airflow" --overwrite -n platform-airflow-prod

# EJM
kubectl annotate deployment -l app=airflow kubernetes.io/change-cause="Actualización imagen Airflow v1" --overwrite

# CMD
MacBook-Pro-de-bryan:airflow bryanalonsoalmeydacontreras$ kubectl annotate deployment -l app=airflow kubernetes.io/change-cause="Actualización imagen Airflow v1" --overwrite
deployment.apps/airflow-scheduler annotated
deployment.apps/airflow-webserver annotated
deployment.apps/airflow-worker annotated

# Excelente
MacBook-Pro-de-bryan:airflow bryanalonsoalmeydacontreras$ kubectl rollout history deployment airflow-scheduler
deployment.apps/airflow-scheduler 
REVISION  CHANGE-CAUSE
1         Actualización imagen Airflow v1

