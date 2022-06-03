# Packer template to create and provision storage image from centos image

variable "deploy_access_token" {
    type = string
    default = ""
}

source "digitalocean" "foo" {
    api_token    = "${var.deploy_access_token}"
    droplet_name = "assetsbuild"
    image        = "rockylinux-8-x64"
    region       = "sfo3"
    size         = "s-1vcpu-1gb"
    ssh_username = "root"
    snapshot_name = "assetsbuild"
}

build {
    sources = ["source.digitalocean.foo"]
    provisioner "ansible" {
        groups = ["digitalocean"]
            playbook_file = "deploy/deploy_playbook.yml"
            extra_arguments = ["--vault-password-file=conf/vault_pass_digitalocean.txt"]            
        }
    provisioner "ansible" {        
        groups = ["baseinstall"]        
            playbook_file = "deploy/provision_playbook.yml"
        }
}
