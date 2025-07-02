FROM jupyter/pyspark-notebook:latest

USER root

# Install OpenJDK 11 and detect JAVA_HOME
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk && \
    export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java)))) && \
    echo "JAVA_HOME=$JAVA_HOME" && \
    echo "export JAVA_HOME=$JAVA_HOME" >> /etc/profile.d/java.sh && \
    echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/profile.d/java.sh && \
    apt-get clean

# Install Python deps
COPY requirements.txt /tmp/requirements.txt
RUN pip install --upgrade pip && \
    pip install -r /tmp/requirements.txt && \
    rm /tmp/requirements.txt

USER $NB_UID

ENV PYSPARK_PYTHON=python3
ENV PYSPARK_DRIVER_PYTHON=python3
ENV SPARK_VERSION=3.4.1

WORKDIR /home/jovyan/work
