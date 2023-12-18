#!/bin/bash
set -eou pipefail

apt-add-repository -y ppa:ansible/ansible
apt-get update
apt-get install -y ansible
printf "You can enter the hosts you desire in this file:\n/etc/ansible/hosts\n"
printf "To test your connection to your hosts, launch the command 'ansible all -m ping -u USER'\n"
