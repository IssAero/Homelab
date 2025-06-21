resource "proxmox_vm_qemu" "master_node" {

  # SECTION General Settings
  count       = 1
  desc        = "Homelab Master Node"
  agent       = 1 # <-- (Optional) Enable QEMU Guest Agent
  target_node = "balo"
  vmid        = 101 + count.index #Unique VM ID Per VM
  # name        = "ubuntu-${101 + count.index}-worker-node"
  name = "Homelab-Master-Node"

  # SECTION Template Settings
  clone      = "ubuntu-server-noble"
  full_clone = true

  # SECTION Boot Process
  onboot = true
  # NOTE Change startup, shutdown and auto reboot behavior
  startup          = ""
  automatic_reboot = true

  # SECTION Hardware Settings
  qemu_os = "other"
  bios    = "seabios"
  memory  = 4096
  cpu {
    cores   = 2
    sockets = 1
    type    = "host"
  }

  # SECTION Network Settings
  network {
    id     = 0 # NOTE Required since 3.x.x
    bridge = "vmbr0"
    model  = "virtio"
  }

  # SECTION Disk Settings
  # NOTE Change the SCSI controller type, since Proxmox 7.3, virtio-scsi-single is the default one         
  scsihw = "virtio-scsi-single"

  # NOTE New disk layout (changed in 3.x.x)
  disks {
    ide {
      ide0 {
        cloudinit {
          storage = "local-zfs"
        }
      }
    }
    virtio {
      virtio0 {
        disk {
          storage = "local-zfs"

          # NOTE Since 3.x.x size change disk size will trigger a disk resize
          size = "25G"
          # NOTE Enable IOThread for better disk performance in virtio-scsi-single
          #      and enable disk replication
          iothread  = true
          replicate = false
        }
      }
    }
  }

  # SECTION Cloud Init Settings
  # FIXME Before deployment, adjust according to your network configuration
  ipconfig0  = "ip=10.100.110.${101 + count.index}/24,gw=10.100.110.1"
  nameserver = "10.100.110.1"
  ciuser     = "administrator"
  sshkeys    = var.PUBLIC_SSH_KEY
  # !SECTION
}


###WORKER NODE###
resource "proxmox_vm_qemu" "worker_node" {

  # SECTION General Settings
  count       = 1
  desc        = "Homelab Worker Node"
  agent       = 1 # <-- (Optional) Enable QEMU Guest Agent
  target_node = "balo"
  vmid        = 102 + count.index #Unique VM ID Per VM
  # name        = "ubuntu-${101 + count.index}-worker-node"
  name = "Homelab-Worker-Node"

  # SECTION Template Settings
  clone      = "ubuntu-server-noble"
  full_clone = true

  # SECTION Boot Process
  onboot = true
  # NOTE Change startup, shutdown and auto reboot behavior
  startup          = ""
  automatic_reboot = true

  # SECTION Hardware Settings
  qemu_os = "other"
  bios    = "seabios"
  memory  = 16384
  cpu {
    cores   = 4
    sockets = 1
    type    = "host"
  }

  # SECTION Network Settings
  network {
    id     = 0 # NOTE Required since 3.x.x
    bridge = "vmbr0"
    model  = "virtio"
  }

  # SECTION Disk Settings
  # NOTE Change the SCSI controller type, since Proxmox 7.3, virtio-scsi-single is the default one         
  scsihw = "virtio-scsi-single"

  # NOTE New disk layout (changed in 3.x.x)
  disks {
    ide {
      ide0 {
        cloudinit {
          storage = "local-zfs"
        }
      }
    }
    virtio {
      virtio0 {
        disk {
          storage = "local-zfs"

          # NOTE Since 3.x.x size change disk size will trigger a disk resize
          size = "100G"
          # NOTE Enable IOThread for better disk performance in virtio-scsi-single
          #      and enable disk replication
          iothread  = true
          replicate = false
        }
      }
    }
  }

  # SECTION Cloud Init Settings
  # FIXME Before deployment, adjust according to your network configuration
  ipconfig0  = "ip=10.100.110.${102 + count.index}/24,gw=10.100.110.1"
  nameserver = "10.100.110.1"
  ciuser     = "administrator"
  sshkeys    = var.PUBLIC_SSH_KEY
  # !SECTION
}

###NGINX PROXY MANAGER###
resource "proxmox_vm_qemu" "NGINX_PROXY_MANAGER_" {

  # SECTION General Settings
  count       = 1
  desc        = "NGINX Proxy Mangager Node"
  agent       = 1 # <-- (Optional) Enable QEMU Guest Agent
  target_node = "balo"
  vmid        = 103 + count.index #Unique VM ID Per VM
  # name        = "ubuntu-${101 + count.index}-worker-node"
  name = "Proxy-Manager-Node"

  # SECTION Template Settings
  clone      = "ubuntu-server-noble"
  full_clone = true

  # SECTION Boot Process
  onboot = true
  # NOTE Change startup, shutdown and auto reboot behavior
  startup          = ""
  automatic_reboot = true

  # SECTION Hardware Settings
  qemu_os = "other"
  bios    = "seabios"
  memory  = 4096
  cpu {
    cores   = 2
    sockets = 1
    type    = "host"
  }

  # SECTION Network Settings
  network {
    id     = 0 # NOTE Required since 3.x.x
    bridge = "vmbr0"
    model  = "virtio"
  }

  # SECTION Disk Settings
  # NOTE Change the SCSI controller type, since Proxmox 7.3, virtio-scsi-single is the default one         
  scsihw = "virtio-scsi-single"

  # NOTE New disk layout (changed in 3.x.x)
  disks {
    ide {
      ide0 {
        cloudinit {
          storage = "local-zfs"
        }
      }
    }
    virtio {
      virtio0 {
        disk {
          storage = "local-zfs"

          # NOTE Since 3.x.x size change disk size will trigger a disk resize
          size = "20G"
          # NOTE Enable IOThread for better disk performance in virtio-scsi-single
          #      and enable disk replication
          iothread  = true
          replicate = false
        }
      }
    }
  }

  # SECTION Cloud Init Settings
  # FIXME Before deployment, adjust according to your network configuration
  ipconfig0  = "ip=10.100.110.${103 + count.index}/24,gw=10.100.110.1"
  nameserver = "10.100.110.1"
  ciuser     = "administrator"
  sshkeys    = var.PUBLIC_SSH_KEY
  # !SECTION
}

###MONITORING NODE###
resource "proxmox_vm_qemu" "monitoring_node" {

  # SECTION General Settings
  count       = 1
  desc        = "Monitoring Node"
  agent       = 1 # <-- (Optional) Enable QEMU Guest Agent
  target_node = "balo"
  vmid        = 104 + count.index #Unique VM ID Per VM
  # name        = "ubuntu-${101 + count.index}-worker-node"
  name = "Monitoring-Node"

  # SECTION Template Settings
  clone      = "ubuntu-server-noble"
  full_clone = true

  # SECTION Boot Process
  onboot = true
  # NOTE Change startup, shutdown and auto reboot behavior
  startup          = ""
  automatic_reboot = true

  # SECTION Hardware Settings
  qemu_os = "other"
  bios    = "seabios"
  memory  = 4096
  cpu {
    cores   = 2
    sockets = 1
    type    = "host"
  }

  # SECTION Network Settings
  network {
    id     = 0 # NOTE Required since 3.x.x
    bridge = "vmbr0"
    model  = "virtio"
  }

  # SECTION Disk Settings
  # NOTE Change the SCSI controller type, since Proxmox 7.3, virtio-scsi-single is the default one         
  scsihw = "virtio-scsi-single"

  # NOTE New disk layout (changed in 3.x.x)
  disks {
    ide {
      ide0 {
        cloudinit {
          storage = "local-zfs"
        }
      }
    }
    virtio {
      virtio0 {
        disk {
          storage = "local-zfs"

          # NOTE Since 3.x.x size change disk size will trigger a disk resize
          size = "30G"
          # NOTE Enable IOThread for better disk performance in virtio-scsi-single
          #      and enable disk replication
          iothread  = true
          replicate = false
        }
      }
    }
  }

  # SECTION Cloud Init Settings
  # FIXME Before deployment, adjust according to your network configuration
  ipconfig0  = "ip=10.100.110.${104 + count.index}/24,gw=10.100.110.1"
  nameserver = "10.100.110.1"
  ciuser     = "administrator"
  sshkeys    = var.PUBLIC_SSH_KEY
  # !SECTION
}