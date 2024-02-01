#!/bin/bash
set -eou pipefail

target_user="$1"
target_host="$2"
verbose="${3:-}"

ansible-playbook ansible/playbook.yml --extra-vars "TARGET_USER=${target_user} TARGET_HOST=${target_host}" ${verbose}
