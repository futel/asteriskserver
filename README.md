# Deploy an asterisk server to Digital Ocean

## Meta-requirements

The setup of README-aws, README-twilio, and README-bulkvs should be completed. These should only have to be done once.

## Steps

- Test, validate, etc.
- Create stage droplet with domain name
- Test
- Promote stage droplet to prod droplet

## Requirements and test

- Have no Digital Ocean droplets or domains named futel-stage.phu73l.net.
- Have a Digital Ocean assets snapshot created by storageserver.
- Have src/asterisk-18.8.0-futel.1.el8.x86_64.rpm built by buildserver.
- Create or check out release branch.

Run unit tests locally

```
  pushd src/var/lib/asterisk/agi-bin
  python3 -m unittest discover test
  popd
  pushd src/etc/asterisk/test
  lua test.lua
```

Run integration tests on virtualbox

```
  cd /opt/futel/itest
  sudo -u asterisk ./itest.sh
```

Validate requirements and configuration locally

```
  ansible-playbook -i deploy/hosts deploy/requirements_conf_prod_playbook.yml
  ansible-playbook -K -i deploy/hosts deploy/requirements_packages_generic_playbook.yml
```

## Deploy stage droplet

Note that the first playbook, deploy_playbook.yml, may fail if DNS takes a long time to propagate. Run it again if it does.

```
  ansible-playbook -i deploy/hosts deploy/deploy_playbook.yml --vault-id=digitalocean@conf/vault_pass_digitalocean.txt --vault-id prod@conf/vault_pass_prod.txt
  ansible-playbook -i deploy/hosts deploy/baseinstall_playbook.yml --limit 'all:!virtualbox' --vault-id=digitalocean@conf/vault_pass_digitalocean.txt
  ansible-playbook -i deploy/hosts deploy/update_asterisk_playbook.yml --limit 'all:!virtualbox' --vault-id generic@conf/vault_pass_generic.txt
  ansible-playbook -i deploy/hosts deploy/update_asterisk_conf_sync_playbook.yml --limit 'all:!virtualbox' --vault-id prod@conf/vault_pass_prod.txt
```

## Test droplet

If testplan has changed since last release branch, update google sheet testplan, keeping dates of nonupdated completed tests.
Test stage against google sheet testplan.

## Promote stage to prod

rename futel-prod.phu73l.net droplet to futel-prod-back
rename futel-stage.phu73l.net droplet to futel-prod.phu73l.net

point all voip.ms DID forwarding rules to subaccounts corresponding to new conf_version on futel-prod.phu73l.net
  185060_prod-foo|bar subaccount

```
  ansible-playbook -i deploy/hosts deploy/promote_playbook.yml --vault-id=digitalocean@conf/vault_pass_digitalocean.txt
  ansible-playbook -i deploy/hosts deploy/post_promote_playbook.yml --vault-id=digitalocean@conf/vault_pass_digitalocean.txt
```

Delete the assets* volume which was attached to futel-prod-back.

Remove snapshots of futel-prod-back except for most recent.

- test that prod outgoing calls work
- test that prod incoming call to incoming line works
- test that prod incoming calls to extensions work or get channel unavailable
- test that prod incoming calls to extensions work (may take time)

## Update iptables

This is done after a new vpnbox is deployed.

```
  ansible-playbook -i deploy/hosts deploy/update_iptables_playbook.yml
```

## Create droplets from images

A droplet can be created from any image with the stage_from_snapshot playbook. This will create the stage droplet and assign a DNS name, so there should be no futel-stage.phu73l.net droplet or domain.

```
  ansible-playbook -i deploy/hosts deploy/stage_from_snapshot_playbook.yml --vault-password-file=conf/vault_pass_digitalocean.txt --extra-vars snapshot=<image>
```
