FROM tomcat
MAINTAINER Vivek Srivastav
RUN apt-get update && apt-get -y upgrade
RUN curl -fsSLO https://get.docker.com/builds/Linux/x86_64/docker-17.04.0-ce.tgz \
  && tar xzvf docker-17.04.0-ce.tgz \
  && mv docker/docker /usr/local/bin \
  && rm -r docker docker-17.04.0-ce.tgz
WORKDIR /usr/local/tomcat
EXPOSE 8080
COPY myproject/target/*.war /usr/local/tomcat/webapps/
