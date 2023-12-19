#!/bin/bash
set -eou pipefail

apt-get install python3-pip
pip install ansible
pip install ansible-lint

printf "If the command 'ansible-lint' does not work, export '~/.local/bin' or add it to your command configuration file (eg: '~/.bashrc')\n"
