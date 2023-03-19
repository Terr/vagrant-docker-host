## vagrant-docker-host

Sets up a rootless Docker Engine daemon using a virtual machine via QEMU. Comparable to how Docker works on macOS.

While docker-rootless and Podman are good options for running containers safely, some containers can't run rootless yet (or ever?). It also requires quite a bit of setup relating to subuids and cgroups.

This virtual machine is a simpler alternative for running containers without root access. It also prevents "network interface spam" on your host machine when extra Docker networks are created for Docker Compose configurations and such.

Because of the limited, partitioned RAM and disk space of the VM, this setup isn't very suitable for long-running, very resource intensive containers. On the other hand, it's ideal for quickly building images and running containers during development that are easily cleaned up.

## Requirements

* Vagrant (tested with v2.3.4)
* QEMU (tested with 7.x)
* libvirtd

## Usage:

Make sure `libvirtd` is running (`systemctl start libvirtd`)

```
vagrant plugin install vagrant-libvirt
vagrant up
export DOCKER_HOST=tcp://127.0.0.1:12375  # Consider adding this to your shell's profile
# To get IP of VM
vagrant ssh -c 'ip a'|grep inet|grep -E -o 'inet ([[:digit:]]+\.){3}[[:digit:]]+/[[:digit:]]+'|grep /24|sort
```

## Advantages vs real rootless setup

* Easy to set up
* Can run images that require privileged (root) permissions
* No additional network interfaces are created on the host machine for each Docker network
* Easy clean up: `vagrant destroy` and everything's gone

## Disadvantages vs real rootless setup

* Cannot mount local file system in containers (similar to Docker Swarm containers)
* No automatic port forwarding from (e.g.) 127.0.0.1 to containers
* Lower performance because of virtual machine
* Have to dedicate a portion of the host machine's RAM to the VM
* Have to decide how much disk space VM/Docker can use in advance

## Known issues

### "Cannot connect to the Docker daemon at tcp://127.0.0.1:12375. Is the docker daemon running?"

A `vagrant reload` should fix it.

This only happens to me when the VM is freshly created and provisioned. I don't know if it's caused by Vagrant, QEMU or vagrant-libvirt, or maybe a combination of them.
