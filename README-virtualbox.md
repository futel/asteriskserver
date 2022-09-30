## Deploy a futel asterisk server on a 64 bit Rocky Linux VM

We use Vagrant and Virtualbox on an Ubuntu host.

## Setup

The guest needs a NAT network interface to communicate with external VOIP servers, and a host-only network interface to communicate with the host and/or other guests.

A Virtualbox host-only network should be created with DHCP server enabled. I used the Virtualbox configurator.
- Name vboxnet0
- IPV4 Address 172.28.128.1
- IPV4 Network Mask 255.255.255.0
- DHCP server enabled

The Virtualbox guest box should have a NAT interface as Adapter 1, and the host-only network as Adapter 2. This might be set up automatically by vagrant?

The host's network configuration should route to the host-only network interface. This might be set up automatically by virtualbox. On Ubuntu, the net-tools package may need to be installed for automatic setup, so Virtualbox can use ifconfig. If Virtualbox and Vagrant don't do it automagically, the netowork can be manually set up on the host with (assuming the host-only network is named "vboxnet0" at 172.28.128.1):

  sudo ip addr add 172.28.128.1/24 dev vboxnet0
  sudo ip link set dev vboxnet0 up  

Have a recent Rocky 8 Vagrant box.

  vagrant box add generic/rocky8
  vagrant box update

## Requirements and test

  ansible-playbook -i deploy/hosts deploy/requirements_conf_vm_playbook.yml
  ansible-playbook -K -i deploy/hosts deploy/requirements_packages_generic_playbook.yml
  ansible-playbook -K -i deploy/hosts deploy/requirements_packages_vm_playbook.yml

## Deploy to newly created VM

  ansible-playbook -i deploy/hosts deploy/update_assets_playbook.yml
  vagrant up

## Provision an existing VM

  vagrant provision

## Shortcut: update asterisk conf and scripts on an existing VM

This assumes everything you want to do is in update_asterisk_playbook.yml and update_secrets_playbook.yml.

  vagrant provision --provision-with update_asterisk
  vagrant provision --provision-with update_secrets

## Deploy itests to an existing VM

  vagrant provision --provision-with deploy/update_asterisk_itests
