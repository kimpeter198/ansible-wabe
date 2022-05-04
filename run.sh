#!/bin/bash

SCRIPT="$0"
FOLDER=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# Exit if no BECOME-Password was passed
BECOME_PASS=$0

# Extra Args

if [ -z "$BECOME_PASS" ]; then
    echo You need to pass the Become-Password as argument:
    echo bash $SCRIPT \'MySecretPassword\'
    exit 1
fi

# Test for sudo rights
echo -e "$BECOME_PASS\n" | sudo -S -v
SUDO="$?"

# Exit if no sudo access
if [ "$SUDO" -gt 0 ]; then
    echo You need sudo rights to run this script:
    echo Please run as user with sudo rights and provide a valid password.
    exit $SUDO
fi

# Exit on error from here on
set -euo pipefail

# Sync Clocks (Timezone Workaround https://askubuntu.com/questions/1096930/sudo-apt-update-error-release-file-is-not-yet-valid)
sudo hwclock --hctosys

# Update system and install Ansible
sudo apt-get update
sudo apt-get install --yes software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt-get install --yes ansible htop nano python3 tree

# Ansible Color Fix
PY_COLORS='1'
ANSIBLE_FORCE_COLOR='1'

# Print Ansible Infos
ansible --version

# Log ansible commands
set -x

# Run playbooks
ansible-playbook -l localhost "$FOLDER/setup.yml" -e "ansible_sudo_pass=$BECOME_PASS" ${@:2}

# Stop log ansible commands
set +x

# Clean up
BECOME_PASS=""
