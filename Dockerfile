FROM tomcat
MAINTAINER Vivek Srivastav
RUN apt-get update && apt-get -y upgrade
WORKDIR /usr/local/tomcat
EXPOSE 8080
COPY myproject/target/*.war /usr/local/tomcat/webapps/