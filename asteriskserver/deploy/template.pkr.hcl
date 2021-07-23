variable "deploy_access_token" {
    type = string
    default = ""
}

source "digitalocean" "foo" {
    api_token    = "${var.deploy_access_token}"
    droplet_name = "futel-stage.phu73l.net"
    image        = "centos-8-x64"
    region       = "sfo1"
    size         = "s-1vcpu-1gb"
    ssh_username = "root"
    snapshot_name = "baseinstall"
}

build {
    sources = ["source.digitalocean.foo"]
    provisioner "ansible" {
        groups = ["digitalocean"]
        playbook_file = "deploy/deploy_digitalocean_playbook.yml"
        extra_arguments = ["--vault-password-file=conf/vault_pass_digitalocean.txt"]
        }
    provisioner "ansible" {
        groups = ["baseinstall"]
        playbook_file = "deploy/baseinstall_playbook.yml"
        #extra_arguments = ["--vault-password-file=conf/vault_pass_prod.txt"]
        }
}
