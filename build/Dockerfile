FROM ubuntu:latest
RUN ln -snf /usr/share/zoneinfo/Europe/Moscow /etc/localtime ;\
apt update -y ;\
apt install git maven curl gnupg -y;\
apt update -y

WORKDIR /home/user/
RUN git clone https://github.com/boxfuse/boxfuse-sample-java-war-hello.git ./ ;\
mvn package

RUN apt remove maven git -y

# Install Google Cloud SDK and import public keys
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
&& curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - \
&& apt-get update -y && apt-get install google-cloud-sdk -y      

# Copy artifact to bucket 
CMD gsutil cp target/hello-1.0.war gs://third-booth-312713-bucket1   



