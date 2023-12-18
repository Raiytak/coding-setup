#!/bin/bash
set -eou pipefail

user="${1}"
hosts="${2}"

ansible-playbook ansible/playbook.yml --extra-vars "USER=${user} HOSTS=${hosts}"
