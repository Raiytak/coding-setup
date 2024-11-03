# Coding Setup

Ansible scripts to configure a new workstation.

# Installation
Download the zip of the project, unzip.
Run:
```
./scripts/install_ansible.sh
ansible-playbook ansible/playbook.yml --ask-become-pass --become --extra-vars "target_host=localhost target_user=$(whoami)"
```

If you are using a GUI, you can install gui applications by adding the tag `--tags "all,gui"`

You can also install KVM by adding `--tags "all,install_kvm"`


# Install and use pre-commit
```
apt install pre-commit
pre-commit install
pre-commit
```
