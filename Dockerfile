# selecting the base ubuntu image for docker agent
FROM ubuntu:22.04


# update the package manager and install the dependencies
RUN yes | apt-get update
RUN yes | apt install git
RUN yes | apt install python3
RUN yes | apt install default-jdk
RUN yes | apt install default-jre
RUN yes | apt install openssh-server
RUN yes | apt install curl
RUN mkdir -p /var/run/sshd

# installing nodejs
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
SHELL [ "/bin/bash","-i", "-c" ] 
RUN source ~/.bashrc
RUN nvm install v20.12.1

# installing maven



# add a jenkins user with password
RUN adduser --quiet jenkins
RUN echo "jenkins:jenkins" | chpasswd


RUN mkdir /home/jenkins/.ssh && chown -R jenkins:jenkins /home/jenkins/.ssh 

# copy the public key of jenkins server
RUN echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL+hOoZbvvZSI8FfF+JXrAgMmz2O7myFBnjIAxnJGQXu Jenkins" > /home/jenkins/.ssh/authorized_keys

RUN service ssh start

# exposing port 22 for ssh to container from jenkins server
EXPOSE 22

# run the openssh server
CMD [ "/usr/sbin/sshd","-D" ]
