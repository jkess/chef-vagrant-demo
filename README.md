# Deployment with Chef and Vagrant

This document outlines how to deploy applications with Chef and test locally using Vagrant.

## Setup

1. Install Git
- Install the latest version of [Chef](http://www.opscode.com/chef/install/)
- [Download](https://www.virtualbox.org/wiki/Downloads) and install VirtualBox
- [Download](http://www.vagrantup.com/downloads.html) and install Vagrant
- Install vagrant plugins

        vagrant plugin install vagrant-omnibus


## Using Vagrant and Chef Solo

1. Create a project folder

        mkdir myproject
        cd myproject

2. Clone this repository (note: I'm cloning to the current directory with `.`)

        git clone https://github.com/jkess/chef-demo .

3. Add the base boxes. [Bento](https://github.com/opscode/bento) is a good source for Linux VirtualBox's

    CentOS 6.5:

        vagrant box add centos65 http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-6.5_chef-provisionerless.box

    Ubuntu Server 13.10:

        vagrant box add ubuntu13.10 http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-13.10_chef-provisionerless.box

4. Configure `Vagrantfile`
    
        # base image to clone
        config.vm.box = "centos65"

        # install chef-client
        config.omnibus.chef_version = :latest

        # run ./cookbooks/flaskapp/recipe/default.rb
        config.vm.provision :chef_solo do |chef|
          chef.node_name = "vagrant-box"
          chef.cookbooks_path = "./cookbooks"
          chef.add_recipe "flaskapp"
        end

5. Boot the guest image

        vagrant up

6. Re-run the Chef recipe

        vagrant provision

7. SSH into the host

        vagrant ssh


## Useful Vagrant Commands

Restart a virtual machine and reload *Vagrantfile*

    vagrant reload

Destroy a virtual machine

    vagrant destroy
    
SSH to the machine

* Linux/OSX OpenSSH

        vagrant ssh

* Windows Putty

        Session -> IP address: 127.0.0.1
        Session -> Port: 2222
        Connection -> Data -> Auto-login username: vagrant
        Password: vagrant

Show available base boxes

    vagrant box list


## References

- [vagrant documentation](http://docs.vagrantup.com/)
- [chef documentation](http://docs.opscode.com/)
