# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
	config.vm.box = "puppetlabs/centos65" # http://puppet-vagrant-boxes.puppetlabs.com/
	config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-65-x64-virtualbox-nocm.box"
	config.vm.provider :virtualbox do |p|
		p.customize ["modifyvm", :id, "--memory", 1024]
		p.customize ["modifyvm", :id, "--cpus", 2]
		p.customize ["modifyvm", :id, "--cpuexecutioncap", 50]
	end
	config.vm.hostname = "webdev"
	config.vm.network "forwarded_port", guest: 80, host: 8080
	config.vm.network "forwarded_port", guest: 8081, host: 8081
	config.vm.provision :shell, path: "bootstrap.sh"
end
