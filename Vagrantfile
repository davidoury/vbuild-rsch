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
    config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1024"]
    end
  end

  config.vm.define "virtualbox1" do |virtualbox1|
    virtualbox1.vm.network "private_network", ip: "10.0.0.101"
    virtualbox1.vm.hostname = "virtualbox1"
    config.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", "2048"]
    end
    virtualbox1.vm.network "forwarded_port", guest: 8787,  host:  8787
    virtualbox1.vm.network "forwarded_port", guest: 50070, host: 50070
    virtualbox1.vm.network "forwarded_port", guest: 8080,  host: 18080
    virtualbox1.vm.network "forwarded_port", guest: 8081,  host: 18081
  end

# config.vm.define "virtualbox2" do |virtualbox2|
#   virtualbox2.vm.network "private_network", ip: "10.0.0.102"
#   virtualbox2.vm.hostname = "virtualbox2"
# end

# config.vm.define "virtualbox3" do |virtualbox3|
#   virtualbox3.vm.network "private_network", ip: "10.0.0.103"
#   virtualbox3.vm.hostname = "virtualbox3"
# end

  config.vm.provider "virtualbox" do |vb|

    vb.gui = false # No VirtualBox GUI
 
    vb.memory = "2048" # 4GB memory
  end
end

