#!/bin/bash
set -eou pipefail

apt-add-repository ppa:ansible/ansible -y
apt update -y
apt install ansible -y
