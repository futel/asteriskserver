# Obsolete documentation

## Deploy an asterisk server to a demo box

## note this is not very secure

install centos 6.8
add personal public key to ~root/.ssh/authorized_keys
put ip address in deploy/hosts_demo

XXX need install_asterisk_helpers also
ansible-playbook -i deploy/hosts_demo deploy/baseinstall_playbook.yml --extra-vars conf_version=demo
ansible-playbook -i deploy/hosts deploy/update_asterisk_playbook.yml --vault-password-file=conf/vault_pass_generic.txt
ansible-playbook -i deploy/hosts_demo deploy/update_asterisk_sip_playbook.yml --vault-password-file=conf/vault_pass_demo.txt  --extra-vars conf_version=demo

add 1337 voicemailbox to demo box
edit /opt/asterisk/etc/asterisk/vm_futel_users to add 1337
cp /opt/asterisk/var/spool/asterisk/voicemail/default/1234 cp /opt/asterisk/var/spool/asterisk/voicemail/default/1337

XXX challenge file /opt/asterisk/etc/asterisk/challenge.csv

ssh root@<ip> reboot
ssh root@<ip> 'service iptables stop'

# Jack

read this:
http://blog.russellbryant.net/2008/01/13/jack-interfaces-for-asterisk/

the jack apps are in /usr/local/bin/

export PATH=/usr/local/bin/:$PATH
screen
sudo -u asterisk /usr/local/bin/jackd -d dummy
sudo -u asterisk /usr/local/bin/jack_metro --bpm 120
