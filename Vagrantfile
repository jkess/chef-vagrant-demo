# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "centos65"
  config.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-6.5_chef-provisionerless.box"

  config.vm.network :forwarded_port, guest: 80, host: 8080

  # install the latest version of chef
  # requires vagrant plugin
  # vagrant plugin install vagrant-omnibus
  config.omnibus.chef_version = :latest

  config.vm.provision :chef_solo do |chef|
    chef.node_name = "vagrant-box"
    chef.cookbooks_path = "./cookbooks"

    # custom node attribute example
    chef.json = {
      "foo" => true
    }

    chef.add_recipe "flaskapp"
  end
end
