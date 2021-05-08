FROM ubuntu:latest
RUN ln -snf /usr/share/zoneinfo/Europe/Moscow /etc/localtime ;\
apt update -y ;\
apt install git -y;\
apt update -y ;\
apt install maven -y ;\
apt update -y

WORKDIR /home/user/
RUN git clone https://github.com/boxfuse/boxfuse-sample-java-war-hello.git ./ ;\
mvn package

RUN apt remove maven git
RUN apt install nginx-y ;\
service nginx restart

