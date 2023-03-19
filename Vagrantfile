# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "archlinux/archlinux"

  # VM with the host's architecture
  config.vm.define "host-libvirt", primary: true do |x86lv|
    # Set a static IP address that you can use to connect to services running in
    # the containers.
    #
    # Use the 'e1000e' network adapter instead of the default virtio if the network performance is extremely poor (I had this happen with QEMU ~7.0.x but it seems to have fixed itself)
    #
    # Disable NAT routing for this device to prevent routing confusion between
    # this one and the management device
    x86lv.vm.network :private_network,
      :ip => "10.11.11.2",
      :libvirt__forward_mode => "open"

    # Default Docker port for unencrypted connections
    x86lv.vm.network "forwarded_port", guest: 2375, host: 12375

    x86lv.vm.provider "libvirt" do |lv|
      lv.cpu_mode = "host-passthrough"
      lv.cpus = `#{RbConfig::CONFIG['host_os'] =~ /darwin/ ? 'sysctl -n hw.ncpu' : 'nproc'}`.chomp
      # To limit the number of cores the VM can use, comment the line above
      # and use this one instead:
      #lv.cputopology :sockets => 1, :cores => 6, :threads => 2
      lv.memory = 4096

      # NOTE: The machine fails to start (and stop) if this setting is activated
      # lv.graphics_type = "none"
    end
  end

  config.vm.provision "shell", path: "provision.sh", privileged: true, reboot: true
end
