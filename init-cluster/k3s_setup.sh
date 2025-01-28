#!/bin/bash

# Update and install dependencies
sudo apt-get update -y
sudo apt-get install -y curl

# Install K3s on master node
if [[ $(hostname) == "master" ]]; then
  curl -sfL https://get.k3s.io | sh -
  # Save the K3s token for worker nodes
  sudo cat /var/lib/rancher/k3s/server/node-token > /vagrant/node-token
  # Get the master node IP
  hostname -I | awk '{print $1}' > /vagrant/master-ip
fi

# Install K3s on worker nodes
if [[ $(hostname) == worker* ]]; then
  # Wait for the master node token and IP to be available
  while [ ! -f /vagrant/node-token ] || [ ! -f /vagrant/master-ip ]; do
    sleep 2
  done

  NODE_TOKEN=$(cat /vagrant/node-token)
  MASTER_IP=$(cat /vagrant/master-ip)

  curl -sfL https://get.k3s.io | K3S_URL=https://$MASTER_IP:6443 K3S_TOKEN=$NODE_TOKEN sh -
fi
