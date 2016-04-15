# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.box = "bento/centos-7.1" # See https://atlas.hashicorp.com/search.

  # Set root password to "hello" on all virtual boxes
  config.vm.provision "shell", inline: <<-ACCT
    echo hello | sudo passwd --stdin root
ACCT

  config.vm.define "virtualbuild" do |virtualbuild|
    virtualbuild.vm.network "private_network", ip: "10.0.0.100"
    virtualbuild.vm.hostname = "virtualbuild"
    config.vm.provider :virtualbuild do |vb|
      vb.customize ["modifyvm", :id, "--memory", "512"]
    end
    virtualbuild.vm.provision "shell", inline: <<-VBSH
      cd /tmp
      tar xvzf /vagrant/setup.tgz 
      /tmp/install.sh
VBSH
  end

  config.vm.define "box1" do |box1|
    box1.vm.network "private_network", ip: "10.0.0.101"
    box1.vm.hostname = "box1"
		config.vm.provider "virtualbox" do |v|
  		v.memory = 3072
  		v.cpus = 2
		end
    box1.vm.network "forwarded_port", guest: 8787,  host: 8787
    box1.vm.network "forwarded_port", guest: 50070, host: 50070
    box1.vm.network "forwarded_port", guest: 8080,  host: 6060
    box1.vm.network "forwarded_port", guest: 8081,  host: 6061
    box1.vm.network "forwarded_port", guest: 5050,  host: 5050
  end

 config.vm.define "box2" do |box2|
   box2.vm.network "private_network", ip: "10.0.0.102"
   box2.vm.hostname = "box2"
    config.vm.provider :box do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1500"]
    end
 end

 config.vm.define "box3" do |box3|
   box3.vm.network "private_network", ip: "10.0.0.103"
   box3.vm.hostname = "box3"
   config.vm.provider :box do |vb|
     vb.customize ["modifyvm", :id, "--memory", "1500"]
   end
 end

  config.vm.provider "box" do |vb|
    vb.gui = false # No VirtualBox GUI
  end
end

