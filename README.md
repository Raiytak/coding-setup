# Coding Setup

Ansible scripts to configure a new workstation.

# Installation
Download the zip of the project, unzip.
Run:
```
./scripts/install_ansible.sh
ansible-playbook ansible/playbook.yml --ask-become-pass --become --extra-vars "target_host=localhost target_user=$(whoami)"
```

You can also install KVM by adding `--tags "all,install_kvm"`

# Preferred Oh-My-ZSH configuration
* Prompt Style: (3)
* Character Set: (1)
* Show current time?: (2)
* Prompt Separators: (1)
* Prompt Heads: (1)
* Prompt Tails: (1)
* Prompt Height: (2)
* Prompt Connection: (1)
* Prompt Frame: (4)
* Prompt Color: (2)
* Prompt Spacing: (1)
* Prompt Flow: (1)
* Enable Transient Prompt?: (y)
* Instant Prompt Mode: (1)

Optional:
* Overwrite ~/.p10k.zsh?: (y)
* Apply changes to ~/.zshrc?: (y)

# Install and use pre-commit
```
apt install pre-commit
pre-commit install
pre-commit
```
