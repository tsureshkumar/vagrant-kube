
Vagrant.configure("2") do |config|

  config.vm.define "master" do |master|
      master.vm.box = "ubuntu/xenial64"
      master.disksize.size = '30GB'

      master.vm.provider "virtualbox" do |v|
        v.memory = 3072
        v.cpus = 2
      end

      master.vm.network "private_network", ip: "10.5.121.15"
      worker.vm.hostname = "master"

      master.vm.provision "shell", path: "docker_install.sh"
      master.vm.provision "shell", path: "kubernetes_install.sh"

      master.vm.synced_folder "/Users/s0t00ov/my/source", "/source"
  end

  config.vm.define "worker" do |worker|
      worker.vm.box = "ubuntu/xenial64"
      worker.disksize.size = '10GB'

      worker.vm.provider "virtualbox" do |v|
        v.memory = 1024
        v.cpus = 1
      end

      worker.vm.network "private_network", ip: "10.5.121.16"
      worker.vm.hostname = "worker0"

      worker.vm.provision "shell", path: "docker_install.sh"
      worker.vm.provision "shell", path: "kubernetes_install_slave.sh"

      worker.vm.synced_folder "/Users/s0t00ov/my/source", "/source"
  end

end

