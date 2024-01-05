#!/bin/bash
set -eou pipefail

user="$1"
hosts="$2"
verbose="${3:-}"

ansible-playbook ansible/playbook.yml --extra-vars "USER=${user} HOSTS=${hosts}" ${verbose}
