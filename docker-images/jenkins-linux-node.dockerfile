FROM jenkins/inbound-agent

USER root
#nodejs and tools
RUN apt update -y
RUN apt-get install curl -y
RUN apt install zip -y
RUN apt install unzip -y
RUN apt install tar -y
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs

#kubernetes
RUN  apt-get update &&  apt-get install -y apt-transport-https gnupg2 curl
RUN  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg |  apt-key add -
RUN  echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" |  tee -a /etc/apt/sources.list.d/kubernetes.list
RUN  apt-get update
RUN  apt-get install -y kubectl
RUN mkdir /root/.kube
COPY config /root/.kube/
COPY .npmrc /root/ 

#install gcp
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN apt-get install apt-transport-https ca-certificates gnupg
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
RUN apt-get update && apt-get install google-cloud-sdk


#ssh key
RUN mkdir  /root/.ssh
COPY id_rsa.pub /root/.ssh/


ENTRYPOINT ["jenkins-slave"]
