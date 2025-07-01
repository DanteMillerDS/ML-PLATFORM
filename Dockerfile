FROM jupyter/pyspark-notebook:latest

# Copy requirements.txt to tmp
COPY requirements.txt /tmp/requirements.txt

# Switch to root to install and delete requirements.txt without permission issues
USER root
RUN pip install --upgrade pip && \
    pip install -r /tmp/requirements.txt && \
    rm /tmp/requirements.txt

# Switch back to jovyan user
USER $NB_UID

# Set environment variables for Spark and Delta Lake
ENV PYSPARK_PYTHON=python3
ENV PYSPARK_DRIVER_PYTHON=python3
ENV SPARK_VERSION=3.4.1

WORKDIR /home/jovyan/work
