VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define "default"
  config.vm.box = "generic/rocky8"
  config.vm.synced_folder ".", "/vagrant",
    automount: true,                          
    mount_options: ["dmode=777,fmode=777"]
  
  config.vm.provision "deploy", type: "ansible" do |ansible|
    ansible.playbook = "deploy/deploy_playbook.yml"
    # Our vm gets virtualbox ansible inventory group.
    ansible.groups = {
      "virtualbox" => ["default"]
    }
    # Generate an ansible hosts file with the variables we need.
    ansible.host_vars = {
      "default" => {"ansible_python_interpreter" => "auto",
                    "host_asset_directory" => "..",
                    "dest_asset_directory" => "/vagrant/build/opt/futel"}}
  end
  
  config.vm.provision "baseinstall", type: "ansible" do |ansible|
    ansible.playbook = "deploy/baseinstall_playbook.yml"
    ansible.vault_password_file = "conf/vault_pass_virtualbox.txt"
    # Our vm gets virtualbox ansible inventory group.
    ansible.groups = {
      "virtualbox" => ["default"]
    }
    # Generate an ansible hosts file with the variables we need.
    ansible.host_vars = {
      "default" => {"ansible_python_interpreter" => "auto",
                    "host_asset_directory" => "..",
                    "dest_asset_directory" => "/vagrant/build/opt/futel"}}
  end    

  config.vm.provision "update_asterisk", type: "ansible" do |ansible|
    ansible.playbook = "deploy/update_asterisk_playbook.yml"
    ansible.vault_password_file = "conf/vault_pass_generic.txt"
    # Our vm gets virtualbox ansible inventory group.
    ansible.groups = {
      "virtualbox" => ["default"]
    }
    # Generate an ansible hosts file with the variables we need.
    ansible.host_vars = {
      "default" => {"ansible_python_interpreter" => "auto",
                    "host_asset_directory" => "..",
                    "dest_asset_directory" => "/vagrant/build/opt/futel"}}
  end    

  config.vm.provision "update_secrets", type: "ansible" do |ansible|
    ansible.playbook = "deploy/update_secrets_playbook.yml"
    ansible.vault_password_file = "conf/vault_pass_virtualbox.txt"
    # Our vm gets virtualbox ansible inventory group.
    ansible.groups = {
      "virtualbox" => ["default"]
    }
    # Generate an ansible hosts file with the variables we need.
    ansible.host_vars = {
      "default" => {"ansible_python_interpreter" => "auto",
                    "host_asset_directory" => "..",
                    "dest_asset_directory" => "/vagrant/build/opt/futel"}}
  end    
  
  config.vm.provision "sync", type: "ansible" do |ansible|
    ansible.playbook = "deploy/sync_playbook.yml"
    ansible.vault_password_file = "conf/vault_pass_virtualbox.txt"
    # Our vm gets virtualbox ansible inventory group.
    ansible.groups = {
      "virtualbox" => ["default"]
    }
    # Generate an ansible hosts file with the variables we need.
    ansible.host_vars = {
      "default" => {"ansible_python_interpreter" => "auto",
                    "host_asset_directory" => "..",
                    "dest_asset_directory" => "/vagrant/build/opt/futel"}}
  end    

  config.vm.provision "update_asterisk_itests", type: "ansible" do |ansible|
    ansible.playbook = "deploy/update_asterisk_itests_playbook.yml"
    # Our vm gets virtualbox ansible inventory group.
    ansible.groups = {
      "virtualbox" => ["default"]
    }
    # Generate an ansible hosts file with the variables we need.
    ansible.host_vars = {
      "default" => {"ansible_python_interpreter" => "auto",
                    "host_asset_directory" => "..",
                    "dest_asset_directory" => "/vagrant/build/opt/futel"}}
  end    
  
  config.vm.provider :virtualbox do |vb|
    vb.memory = 1024            # current prod is 512mb, this is for convenience
    # this creates vboxnet0 and vboxnet1, with pingable eth1 on vboxnet1
    # We need to set the IP because Virtualbox only allows addresses in that range, and Vagrant
    # is defaulting to one in a different private network range, presumably some combinations of
    # updates will fix this and let us use the default someday.
    config.vm.network "private_network", type: "dhcp", ip: "192.168.56.1", :adapter => 2    
    # uncomment to disable headless mode
    # vb.gui = true
  end

end
