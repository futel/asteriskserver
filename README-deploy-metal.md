# Deploy a futel asterisk server on a 64 bit Rocky Linux box

# Setup

- The destination must have Rocky 8 installed with passwordless root SSH accessible to the user.

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
- # enter password when prompted, what could go wrong?
- ansible-playbook -K -i deploy/hosts deploy/requirements_packages_generic_playbook.yml
- ansible-playbook -K -i deploy/hosts deploy/requirements_packages_vm_playbook.yml

Run unit tests locally

As README.md

# Deploy box

Update hosts-demo with the address of the destination.

- ansible-playbook -i deploy/hosts-metal deploy/deploy_playbook.yml
- ansible-playbook -i deploy/hosts-metal deploy/baseinstall_playbook.yml --vault-id=digitalocean@conf/vault_pass_digitalocean.txt
- ansible-playbook -i deploy/hosts-metal deploy/update_asterisk_playbook.yml --vault-id generic@conf/vault_pass_generic.txt

XXX update from here as README-virtualbox.md, README.md
XXX dest_asset_directory is wrong

  ansible-playbook -i deploy/hosts deploy/update_asterisk_playbook.yml --limit 'all:!virtualbox' --vault-id generic@conf/vault_pass_generic.txt
  ansible-playbook -i deploy/hosts deploy/update_asterisk_conf_sync_playbook.yml --limit 'all:!virtualbox' --vault-id prod@conf/vault_pass_prod.txt

XXX update from here as README-virtualbox.md, README.md

# Update iptables

  # XXX me
  iptables -A INPUT -p udp -m udp -s 67.171.203.32 -j ACCEPT
  iptables -A INPUT -p tcp -m tcp -s 67.171.203.32 -j ACCEPT
  # shadytel
  iptables -A INPUT -p udp -m udp -s 44.31.23.100 -j ACCEPT
  iptables -A INPUT -p tcp -m tcp -s 44.31.23.100 -j ACCEPT
