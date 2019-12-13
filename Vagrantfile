# -*- mode: ruby -*-
# vi: set ft=ruby :

IMAGE_NAME = "ubuntu/xenial64"

# Increase Kubernet numworkers if you want more than 2 worker nodes
NUM_WORKERS = 2
# VirtualBox settings
# Increase vmmemory if you want more than 256/512mb memory in the vm's
NODE_VM_MEMORY = 256 
MGMT_VM_MEMORY = 512 
# Increase numcpu if you want more cpu's per vm
NUM_CPU = 1

# Create the VMs
Vagrant.configure("2") do |config|
    
    config.ssh.insert_key = false
    config.vbguest.auto_update = true
    config.vm.box_check_update = false

    # Create management (mgmt) node
    config.vm.define "mgmt" do |mgmt|
      mgmt.vm.box = IMAGE_NAME
      mgmt.vm.network "private_network", ip: "192.168.56.10"
      mgmt.vm.hostname = "mgmt"
      if Vagrant::Util::Platform.windows? then
        # Configuration SPECIFIC for Windows 10 hosts
        mgmt.vm.synced_folder "kubernetes", "/home/vagrant/kubernetes",
          id: "vagrant-root", ouner: "vagrant", group: "vagrant",
          mount_options: ["dmode=775,fmode=664"]
        else
        # Configuration for Unix/Linux hosts
        mgmt.vm.synced_folder "kubernetes", "/home/vagrant/kubernetes"
      end

      mgmt.vm.provider "virtualbox" do |vb|
        vb.name = "mgmt"
        vb.cpus = NUM_CPU
        opts = ["modifyvm", :id, "--natdnshostresolver1", "on"]
        vb.customize opts
        vb.memory = MGMT_VM_MEMORY
      end

      mgmt.vm.provision "shell", path: "bootstrap-mgmt.sh"
    end
      
    # Create orchestrator (master) node  
    config.vm.define "orchestrator" do |master|
        master.vm.box = IMAGE_NAME
        master.vm.network "private_network", ip: "192.168.56.11"
        master.vm.network "forwarded_port", guest: 80, host: 8080
        master.vm.hostname = "orchestrator"

        master.vm.provider "virtualbox" do |vb|
          vb.name = "orchestrator"
          vb.cpus = NUM_CPU
          opts = ["modifyvm", :id, "--natdnshostresolver1", "on"]
          vb.customize opts
          vb.memory = NODE_VM_MEMORY
        end
    end # orchestrator

    # Create worker nodes
    (1..NUM_WORKERS).each do |i|
        config.vm.define "worker-#{i}" do |node|
            node.vm.box = IMAGE_NAME
            node.vm.network "private_network", ip: "192.168.56.#{20 + i}"
            node.vm.network "forwarded_port", guest: 80, host: 8080+i
            node.vm.hostname = "worker-#{i}"

            node.vm.provider "virtualbox" do |vb|
              vb.name = "worker-#{i}"
              vb.cpus = NUM_CPU
              opts = ["modifyvm", :id, "--natdnshostresolver1", "on"]
              vb.customize opts
              vb.memory = NODE_VM_MEMORY
            end
        end # i
    end # workers
end