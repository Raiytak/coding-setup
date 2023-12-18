#!/bin/bash
set -eou pipefail

ssh_pub="${1}"

useradd ansible -m -s /bin/bash -G sudo

if [ ! "${ssh_pub}" = "no_key" ]; then
    mkdir -p /home/ansible/.ssh
    echo "${ssh_pub}" >> /home/ansible/.ssh/authorized_keys
fi

# Needed when changing user inside an Ansible script (source: https://stackoverflow.com/a/56379678)
apt-get install acl
