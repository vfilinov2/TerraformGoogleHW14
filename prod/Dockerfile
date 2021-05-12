FROM  tomcat:latest
RUN apt update -y 
RUN apt install curl gnupg -y

# Install Google Cloud SDK and import public keys
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
&& curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - \
&& apt-get update -y && apt-get install google-cloud-sdk -y      

# Copy artifact from bucket to ./webapps
RUN gsutil cp gs://third-booth-312713-bucket1/hello-1.0.war $CATALINA_HOME/webapps
EXPOSE 8080
CMD $CATALINA_HOME/bin/catalina.sh run