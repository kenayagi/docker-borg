#!/bin/sh

# Generate SSH host key, if not exists
if [ ! -f "/opt/ssh/ssh_host_rsa_key" ]; then
  mkdir -p /opt/ssh/
  /usr/bin/ssh-keygen -t dsa -N "" -f /opt/ssh/ssh_host_dsa_key
  /usr/bin/ssh-keygen -t rsa -N "" -f /opt/ssh/ssh_host_rsa_key
  /usr/bin/ssh-keygen -t ecdsa -N "" -f /opt/ssh/ssh_host_ecdsa_key
  /usr/bin/ssh-keygen -t ed25519 -N "" -f /opt/ssh/ssh_host_ed25519_key
fi

if [ ! -f "/opt/ssh/authorized_keys" ]; then
  mkdir -p /opt/ssh/
  echo 'command="borg serve --restrict-to-path /path/to/repo",no-pty,no-agent-forwarding,no-port-forwarding,no-X11-forwarding,no-user-rc ssh-rsa AAAAB3...' > /opt/ssh/authorized_keys
fi

# Launch ssh server as daemon
exec /usr/sbin/sshd -D -e
