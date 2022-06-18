#!/bin/bash
sudo yum update -y
sudo yum install yum-utils -y

sudo yum install docker -y
sudo usermod -aG docker ec2-user

sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

sudo systemctl enable docker
sudo systemctl start docker

sudo mkdir /home/ec2-user/jenkins-data
sudo mkdir /home/ec2-user/jenkins-home
sudo chown ec2-user:ec2-user /home/ec2-user/jenkins-data
sudo chown ec2-user:ec2-user /home/ec2-user/jenkins-home

sudo cat <<EOF > /home/ec2-user/jenkins-data/plugins.txt
ant:latest
antisamy-markup-formatter:latest
authorize-project:latest
build-timeout:latest
cloudbees-folder:latest
configuration-as-code:latest
credentials-binding:latest
email-ext:latest
git:latest
github-branch-source:latest
gradle:latest
ldap:latest
mailer:latest
matrix-auth:latest
pam-auth:latest
pipeline-github-lib:latest
pipeline-stage-view:latest
ssh-slaves:latest
timestamper:latest
workflow-aggregator:latest
ws-cleanup:latest
EOF
sudo chown ec2-user:ec2-user /home/ec2-user/jenkins-data/plugins.txt

export JENKINS_ADMIN_ID=admin
export JENKINS_ADMIN_PASSWORD=jenkins

sudo cat <<EOF > /home/ec2-user/jenkins-home/casc.yaml
unclassified:
  location:
    url: http://127.0.0.1:8080/
jenkins:
  securityRealm:
    local:
      allowsSignup: false
      users:
       - id: ${JENKINS_ADMIN_ID}
         password: ${JENKINS_ADMIN_PASSWORD}
  authorizationStrategy:
    globalMatrix:
      permissions:
        - "Overall/Administer:admin"
        - "Overall/Read:authenticated"
  remotingSecurity:
    enabled: true
security:
  queueItemAuthenticator:
    authenticators:
    - global:
        strategy: triggeringUsersAuthorizationStrategy
EOF
sudo chown ec2-user:ec2-user /home/ec2-user/jenkins-home/casc.yaml

sudo docker pull jenkins/jenkins

sudo cat <<EOF > /home/ec2-user/jenkins-data/Dockerfile

### Image ###
FROM jenkins/jenkins
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

### Install Plugins ###
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yaml

USER root

RUN apt-get update && apt-get install wget -y

### Install Terraform ###
RUN wget --quiet https://releases.hashicorp.com/terraform/1.0.9/terraform_1.0.9_linux_amd64.zip \
&& unzip terraform_1.0.9_linux_amd64.zip \
&& mv terraform /usr/bin \
&& rm terraform_1.0.9_linux_amd64.zip

USER jenkins
EOF

sudo chown ec2-user:ec2-user /home/ec2-user/jenkins-data/Dockerfile
cd /home/ec2-user/jenkins-data
sudo docker build -t jenkins-terraform .

sudo cat <<EOF > /home/ec2-user/jenkins-data/docker-compose.yaml
version: '3'
services:
  jenkins:
    container_name: jenkins-server-tf
    image: jenkins-terraform
    ports:
      - "80:8080"
    volumes:
      - /home/ec2-user/jenkins-home:/var/jenkins_home
    networks:
      - net
networks:
  net:
EOF

sudo chown ec2-user:ec2-user /home/ec2-user/jenkins-data/docker-compose.yaml
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
sudo docker-compose up -d
