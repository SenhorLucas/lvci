FROM jenkins/jenkins:lts-jdk17

# Install Docker
USER root
RUN apt-get update && apt-get install -y lsb-release
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y \
  docker-ce-cli \
  iproute2 \
  iputils-ping \
  net-tools \
  vim-gtk3

# Setup
USER jenkins

# No manual setup on first startup
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

# Install plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt

# JCasC
# ENV CASC_JENKINS_CONFIG /var/jenkins_home/jenkins.yaml
# RUN mkdir -p /var/jenkins_home/casc
# COPY jenkins.yaml /var/jenkins_home/jenkins.yaml

