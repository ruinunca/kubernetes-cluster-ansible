#!/usr/bin/env bash

# install ansible (http://docs.ansible.com/intro_installation.html)
apt-get -y install software-properties-common
apt-add-repository -y ppa:ansible/ansible
apt-get update
apt-get -y install ansible

# configure hosts file for the internal network defined by Vagrantfile
cat >> /etc/hosts <<EOL

# vagrant environment nodes
192.168.56.10  mgmt
192.168.56.11  orchestrator
192.168.56.21  worker-1
192.168.56.22  worker-2
#192.168.56.22  worker-3
#192.168.56.22  worker-4
#192.168.56.22  worker-5
EOL
