FROM debian

# RUN apt update && apt upgrade
RUN \
  apt-get update && \
  apt-get -y install \
          software-properties-common \
          sudo \
          wget \
          nano \
          curl \
          gnupg \
          apt-transport-https\
          tar \
          gnupg \
          apt-transport-https \
          git-core && \
  rm -rf /var/lib/apt/lists/*
#
# Install PowerShell on linux
#RUN sudo apt-get update  && sudo apt-get install -y curl gnupg apt-transport-https
RUN curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
RUN sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-bullseye-prod bullseye main" > /etc/apt/sources.list.d/microsoft.list'
RUN sudo apt-get update && sudo apt-get install -y powershell  
#

# Create a user named zap
RUN ln -sf /bin/bash /bin/sh
ARG user=zap
ARG home=/home/$user
ARG UID=1000
RUN useradd -ms /bin/bash $user -N -u $UID $USER && \
        echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$user && \
        chmod 0440 /etc/sudoers.d/$user && \
        chmod g+w /etc/passwd 
#

USER zap
WORKDIR /usr/local/bin/zap

# Configure Agent must be done manually for once, and running the listening 
# process through the script "./run.sh" can be automated through cronjob to 
# automatically run at the startup
# Download and install Azure agent
WORKDIR /home/zap
RUN mkdir myagent
RUN cd myagent
COPY . /home/zap/myagent
WORKDIR /home/zap/myagent
RUN tar zxvf /home/zap/myagent/vsts-agent-linux-x64-2.213.2.tar.gz
RUN rm /home/zap/myagent/vsts-agent-linux-x64-2.213.2.tar.gz

CMD ["bash"]