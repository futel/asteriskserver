# Packer template to create update image from baseinstall image

packer {
    required_plugins {
      digitalocean = {
        version = ">= 1.0.1"
        source  = "github.com/hashicorp/digitalocean"
      }
    }
}

variable "deploy_access_token" {
    type = string
    default = ""
}

variable "image" {
    type = string
}

variable "ssh_key_id" {
}

source "digitalocean" "foo" {
    api_token    = "${var.deploy_access_token}"
    droplet_name = "futel-stage.phu73l.net"
    image        = "${var.image}"
    region       = "sfo3"
    size         = "s-1vcpu-1gb"
    communicator = "ssh"
    ssh_username = "futel"
    ssh_port = "42422"
    ssh_private_key_file = "conf/id_rsa"
    ssh_key_id = "${var.ssh_key_id}"
    snapshot_name = "update"
}

build {
    sources = ["source.digitalocean.foo"]
    provisioner "ansible" {
        groups = ["baseinstall"]
            use_proxy = "false"
            playbook_file = "deploy/update_asterisk_playbook.yml"
            extra_arguments = ["--vault-password-file=conf/vault_pass_generic.txt"]        
        }
}
