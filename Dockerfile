FROM alpine:3.8   

# Install ssh
RUN apk add --no-cache openssh-server

# Setup SSH Daemon
ADD sshd_config /etc/ssh/sshd_config

# Install borg        
RUN apk add --no-cache borgbackup

# Startup script
ADD start.sh /start.sh

# Volume
VOLUME /opt
VOLUME /backups

# Port
EXPOSE 22

# Command
CMD ["/bin/bash", "/start.sh"]
