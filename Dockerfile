FROM ubuntu:xenial
LABEL version="0.5" maintainer="Chandra Siva <email@chandraonline.net>"
MAINTAINER chandraonline

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get upgrade -q -y
RUN apt-get dist-upgrade -q -y

# Install base dev stuff

RUN apt-get install -y build-essential && \
    apt-get install -y apt-utils && \
    apt-get install -y sudo && \
    apt-get install -y figlet && \
    apt-get install -y strace && \
    apt-get install -y curl && \
    apt-get install -y git && \
    apt-get install -y tmux && \
    apt-get install -y unzip && \
    apt-get install -y wget && \
    apt-get install -y vim

##################################################
# Install open jdk 8
##################################################

# This is in accordance to : https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-get-on-ubuntu-16-04 

RUN apt-get update && \
    apt-get install -y openjdk-8-jdk && \
    apt-get install -y ant && \ 
    apt-get clean && \ 
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/oracle-jdk8-installer; 

# Fix certificate issues, found as of # https://bugs.launchpad.net/ubuntu/+source/ca-certificates-java/+bug/983302 

RUN apt-get update && \ 
    apt-get install -y ca-certificates-java && \
    apt-get clean && \ 
    update-ca-certificates -f && \ 
    rm -rf /var/lib/apt/lists/* && \ 
    rm -rf /var/cache/oracle-jdk8-installer; 

# Setup JAVA_HOME, this is useful for docker commandline 
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/ 

##################################################
# Install Scala
##################################################

RUN wget http://downloads.lightbend.com/scala/2.11.8/scala-2.11.8.deb -O /tmp/scala-2.11.8.deb && \
    dpkg -i /tmp/scala-2.11.8.deb && \
    rm -f /tmp/scala-2.11.8.deb && \
    rm -rf /usr/share/doc/scala

ENV SCALA_HOME=/usr/share/scala

##################################################
# Install SBT
##################################################

# Get and install scala-sbt from deb file
RUN wget https://dl.bintray.com/sbt/debian/sbt-0.13.13.deb -O /tmp/sbt-0.13.13.deb && \
    dpkg -i /tmp/sbt-0.13.13.deb && \
    rm -f /tmp/sbt-0.13.13.deb
