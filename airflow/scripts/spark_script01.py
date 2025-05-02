#!/usr/env bin python3
from pyspark.sql.functions import desc, lit
from pyspark.sql import SparkSession
from datetime import datetime

# ATTRIBUTES
root_path = "/tmp"
local_filepath = f"{root_path}/dataset_untels.csv"
date_pipeline_exec = datetime.now().strftime("%Y-%m-%d")

if __name__ == '__main__':
    # CORE SESSION
    spark = SparkSession \
            .builder \
            .config("spark.dynamicAllocation.enabled", "false") \
            .config("spark.driver.memory", "4G") \
            .master("spark://192.168.0.14:7077") \
            .appName("Procesando dataset Postulantes admision 2024-1") \
            .getOrCreate()

    # EXTRACT
    df = spark \
            .read \
            .options(delimiter=",", header=True, inferSchema=True) \
            .csv(local_filepath)

    # TRANSFORM
    df = df.select(["Fecha_Nacimiento", "Edad", "Genero", "Distrito_procedencia", "Modalidad", "Puntaje", "Estado_Ingreso", "Escuela"])

    df_1 = df.groupBy("Escuela").count().orderBy(desc("count"))
    df_1 = df_1.withColumn("fecha_ejecucion", lit(date_pipeline_exec))
    df_1.show(truncate=False)

    # LOAD
    df_1.write.option('header', 'true').mode("append").csv(f"{ root_path }/datasets")
