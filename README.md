# coding-setup

Ansible scripts to configure a new workstation.
To install, download the zip of the project, unzip and run:
```
./scripts/prepare_target.sh
./scripts/run_ansible.sh --target-host localhost --target-user $(whoami)
```

Advised ohmyzsh configuration:
* Prompt Style: (3)
* Character Set: (1)
* Show current time?: (2)
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
