# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu/trusty64"

  # Create a private network, which allows host-only access to the machine using a specific IP.
  # config.vm.network "private_network", ip: "10.0.1.55"

  # Config access port
  config.vm.network "forwarded_port", guest: 80, host: 4567

  # Share an additional folder to the guest VM. The first argument is the path on the host to the actual folder.
  # The second argument is the path on the guest to mount the folder.
  config.vm.synced_folder "~/Dropbox/Projetos/Ativos/", "/var/www/html/projects"

  # Define the bootstrap file: A (shell) script that runs after first setup of your box (= provisioning)
  config.vm.provision :shell, path: "bootstrap.sh"

  # Script runnig before destroy
  config.trigger.before :destroy do
    info "create database dump."
    run_remote  "bash /vagrant/mysqldump.sh"
  end

end
