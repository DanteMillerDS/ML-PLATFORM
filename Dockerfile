FROM jupyter/pyspark-notebook:latest

USER root

# Install OpenJDK 11 and set JAVA_HOME
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk curl && \
    export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java)))) && \
    echo "JAVA_HOME=$JAVA_HOME" && \
    echo "export JAVA_HOME=$JAVA_HOME" >> /etc/profile.d/java.sh && \
    echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/profile.d/java.sh && \
    apt-get clean

# Install Node.js (LTS version) via NodeSource
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Confirm Node.js and npm installed
RUN node -v && npm -v

# Create React app folder under /home/jovyan/work/react-app
USER $NB_UID
WORKDIR /home/jovyan/work

# Optional: initialize React app (you can also mount pre-built code)
RUN npx create-react-app react-app

WORKDIR /home/jovyan/work/react-app

# Install React dependencies
RUN npm install

# Expose ports
EXPOSE 8888 3000

ENV PYSPARK_PYTHON=python3
ENV PYSPARK_DRIVER_PYTHON=python3
ENV SPARK_VERSION=3.4.1

WORKDIR /home/jovyan/work
