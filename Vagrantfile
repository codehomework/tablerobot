Vagrant.configure(2) do |config|
  config.vm.box = "geerlingguy/centos7"
  config.vm.synced_folder ".", "/home/vagrant/tablerobot"
  config.vm.provision "shell", privileged: false, path: "provisioner.sh"
end
