# Deploy a futel asterisk server on a 64 bit Rocky Linux VM

We use Vagrant and Virtualbox on an Ubuntu host.

# Setup

Have a recent Rocky 8 Vagrant box.

  vagrant box add generic/rocky8 (if asked, choose virtualbox provider)
  vagrant box update

# Requirements and test

## Have assets

Have an assets package built by storageserver in src/assets.tgz.

## Create deployment virtualenv

- python3 -m venv venv
- source venv/bin/activate
- pip install -r requirements.txt

# Validate

Validate requirements and configuration locally

- source venv/bin/activate
- ansible-playbook -i deploy/hosts deploy/requirements_conf_vm_playbook.yml
- # enter root password when prompted, what could go wrong?
- ansible-playbook -K -i deploy/hosts deploy/requirements_packages_generic_playbook.yml
- ansible-playbook -K -i deploy/hosts deploy/requirements_packages_vm_playbook.yml

# Deploy to newly created VM

- source venv/bin/activate
- vagrant up
- vagrant ssh -c 'sudo -u asterisk touch /etc/asterisk/challenge.csv'

# Provision an existing VM

This is only needed to update an existing VM, if no changes have been made, a successful "vagrant up" will also provision.

- vagrant provision

# Shortcut: update asterisk conf and scripts on an existing VM

This assumes everything you want to do is in update_asterisk_playbook.yml and update_secrets_playbook.yml.

- vagrant provision --provision-with update_asterisk
- vagrant provision --provision-with update_asterisk_conf_sync

# Deploy itests to an existing VM

- vagrant provision --provision-with deploy/update_asterisk_itests
