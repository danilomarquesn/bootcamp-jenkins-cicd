### Image ###
FROM jenkins/jenkins
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

### Install Plugins ###
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

ENV JENKINS_ADMIN_ID admin
ENV JENKINS_ADMIN_PASSWORD jenkins

ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yaml

USER root

RUN apt-get update && apt-get install wget -y

### Install Terraform ###
RUN wget --quiet https://releases.hashicorp.com/terraform/1.0.9/terraform_1.0.9_linux_amd64.zip \
&& unzip terraform_1.0.9_linux_amd64.zip \
&& mv terraform /usr/bin \
&& rm terraform_1.0.9_linux_amd64.zip

USER jenkins