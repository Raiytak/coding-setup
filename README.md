# coding-setup

Ansible scripts to configure a new workstation. The available roles are:
- kvm: Installs Kernel-based Virtual Machine, to have local VMs
- zsh: Installs zsh

If you want to launch the ansible playbook manually, you have to specify your hosts in '/etc/ansible/hosts'. For example:
```
[local_vm_01]
192.168.122.1 ansible_user=sa-ansible
```