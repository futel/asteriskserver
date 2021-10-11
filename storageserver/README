## Requirements

Have assets subdirectory populated with assets.
Don't have any droplets, droplet images, or volumes named assetsbuild.
Don't have any volume images with names starting with assetsbuild.

## Initialize packer

This is probably only needed once?

  packer init deploy/deploy_template.pkr.hcl

Validate requirements and configuration locally

  ansible-playbook -i deploy/hosts deploy/requirements_conf_prod_playbook.yml
  packer validate -var-file=conf/variables.pkr.hcl deploy/deploy_template.pkr.hcl

## Build volume

  packer build -var-file=conf/variables.pkr.hcl deploy/deploy_template.pkr.hcl

## Create snapshot of volume and clean up

In digitalocean console, create snapshot of assetsbuild volume with default name.
In digitalocean console, destroy assetsbuild volume.
In digitalocean console, destroy assetsbuild droplet snapshot

## Notes

community.digitalocean.digital_ocean_snapshot is the ansible collection to snapshot volume

volume snapshot downgrade:
check out appropriate release to match asteriskserver
create volume snapshot

asteriskserver stage deploy:
create, provision, etc droplet
list assetsbuild volume snapshots, find most recent
create, mount assets volume from assetsbuild snapshot

asterisksever stage promote:
decommission, delete etc futel-prod-back droplet
destroy assets volume mounted to futel-prod-back
delete all assetsbuild volume snapshots but most recent

asteriskserver prod downgrade:
make snapshot of current futel-prod droplet
delete futel-prod droplet
create droplet from futel-prod-back
XXX create, mount volume of appropriate revision
