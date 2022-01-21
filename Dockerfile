FROM ubuntu:20.04 AS basic

RUN apt-get update && apt-get install -y \
    wget vim git

RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata software-properties-common

RUN wget https://github.com/github/codeql-action/releases/latest/download/codeql-bundle-linux64.tar.gz

RUN cd /opt && tar -xvzf ../codeql-bundle-linux64.tar.gz && rm ../codeql-bundle-linux64.tar.gz

ENV PATH="/opt/codeql:${PATH}"

CMD bash

FROM basic AS log4j2-codeql

RUN apt-get update && apt-get install -y\
  maven openjdk-8-jdk openjdk-11-jdk

RUN git clone https://github.com/apache/logging-log4j2.git

RUN cd logging-log4j2 && git checkout rel/2.14.1 &&\
    cd ..

RUN wget https://download.java.net/java/GA/jdk9/9.0.4/binaries/openjdk-9.0.4_linux-x64_bin.tar.gz

RUN cd /opt && tar -xvzf ../openjdk-9.0.4_linux-x64_bin.tar.gz && rm ../openjdk-9.0.4_linux-x64_bin.tar.gz

RUN mkdir -p ~/.m2

COPY toolchains.xml /root/.m2/

COPY pom-xml.patch /

RUN cd logging-log4j2 &&\
    git apply /pom-xml.patch &&\
    cd ..
