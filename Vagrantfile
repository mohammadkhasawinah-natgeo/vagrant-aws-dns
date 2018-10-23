# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial32"
  config.vm.provision "shell", name: "ruby", inline: "sudo apt-get install ruby build-essential g++ zlib1g-dev libxml2-dev libcurl4-gnutls-dev -y"
  config.vm.provision "shell", name: "ruby-utils", inline: "sudo apt-get install -y ruby`ruby -e 'puts RUBY_VERSION[/\d+\.\d+/]'`-dev"
end