VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define "default"
  config.vm.box = "generic/rocky8"
  config.vm.synced_folder ".", "/vagrant",
    :mount_options => ["dmode=777,fmode=777"]

  config.vm.provision "base", type: "ansible" do |ansible|
    ansible.playbook = "deploy/base_playbook.yml"
    
    # default vm gets virtualbox ansible inventory group
    ansible.groups = {
      "virtualbox" => ["default"]
    }
    # uncomment for verbose output
    # ansible.raw_arguments = ["-v"]
  end    
  
  config.vm.provider :virtualbox do |vb|
    vb.memory = 1024            # current prod is 512mb, this is for convenience
    # this creates vboxnet0 and vboxnet1, with pingable eth1 on vboxnet1
    config.vm.network "private_network", type: "dhcp", :adapter => 2    
    # uncomment to disable headless mode
    # vb.gui = true
  end

end
