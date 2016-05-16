FROM debian:jessie

# Set desired borg version
ENV BORGVERSION=1.0.2

# Install dependencies
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get -y install \
        build-essential \
        fuse \
        libacl1 \
        libacl1-dev \
        libfuse-dev \
        liblz4-1 \
        liblz4-dev \
        liblzma-dev \
        libssl-dev \
        openssh-server \
        openssl \
        pkg-config \
        python3 \
        python3-virtualenv \
        python3-dev \
        python3-pip \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 -v install 'llfuse<2.0'

# Install borg
RUN pip3 -v install borgbackup==${BORGVERSION}

# Create user
RUN groupadd --gid 500 borg && \
    adduser --disabled-password --gecos "Borg Backup" --home /opt/borg --uid 500 --gid 500 borg && \
    mkdir -p /opt/borg/.ssh && \
    chown -R borg:borg /opt/borg

# Setup SSH Daemon
ADD sshd_config /opt/ssh/sshd_config
RUN mkdir /var/run/sshd
RUN rm -f /etc/ssh/ssh_host_*

WORKDIR /opt/borg
ADD start.sh /start.sh

# Volume
VOLUME /opt

# Port
EXPOSE 22

# Command
CMD ["/bin/bash", "/start.sh"]