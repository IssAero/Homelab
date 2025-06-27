resource "proxmox_vm_qemu" "master_node" {
  # SECTION General Settings
  count       = 1
  desc        = "Homelab Master Node"
  agent       = 1 # <-- (Optional) Enable QEMU Guest Agent
  target_node = "balo"
  vmid        = 101 + count.index #Unique VM ID Per VM
  # name        = "ubuntu-${101 + count.index}-worker-node"
  name = "Homelab-control-plane"
  # SECTION Template Settings
  clone      = "ubuntu-server-noble"
  full_clone = true
  # SECTION Boot Process
  onboot           = true
  startup          = ""
  automatic_reboot = true
  # SECTION Hardware Settings
  qemu_os = "other"
  bios    = "seabios"
  memory  = 4092
  cpu {
    cores   = 8
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
  scsihw = "virtio-scsi-single"

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
          storage   = "local-zfs"
          size      = "25G"
          iothread  = true
          replicate = false
        }
      }
    }
  }

  # SECTION Cloud Init Settings
  ipconfig0  = "ip=10.100.110.${101 + count.index}/24,gw=10.100.110.1"
  nameserver = "10.100.110.1"
  ciuser     = "administrator"
  sshkeys    = var.PUBLIC_SSH_KEY
}

resource "proxmox_vm_qemu" "arr_worker_node" {
  # SECTION General Settings
  count       = 1
  desc        = "Homelab Worker Node"
  agent       = 1 # <-- (Optional) Enable QEMU Guest Agent
  target_node = "balo"
  vmid        = 102 + count.index #Unique VM ID Per VM
  # name        = "ubuntu-${101 + count.index}-worker-node"
  name = "media-node"
  # SECTION Template Settings
  clone      = "ubuntu-server-noble"
  full_clone = true
  # SECTION Boot Process
  onboot           = true
  startup          = ""
  automatic_reboot = true
  # SECTION Hardware Settings
  qemu_os = "other"
  bios    = "seabios"
  memory  = 12288
  cpu {
    cores   = 10
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
  scsihw = "virtio-scsi-single"

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
          storage   = "local-zfs"
          size      = "100G"
          iothread  = true
          replicate = false
        }
      }
    }
  }

  # SECTION Cloud Init Settings
  ipconfig0  = "ip=10.100.110.${102 + count.index}/24,gw=10.100.110.1"
  nameserver = "10.100.110.1"
  ciuser     = "administrator"
  sshkeys    = var.PUBLIC_SSH_KEY
}




resource "proxmox_vm_qemu" "media_storage_worker_node" {
  # SECTION General Settings
  count       = 1
  desc        = "Homelab Worker Node"
  agent       = 1 # <-- (Optional) Enable QEMU Guest Agent
  target_node = "balo"
  vmid        = 103 + count.index #Unique VM ID Per VM
  # name        = "ubuntu-${101 + count.index}-worker-node"
  name = "infra-node"
  # SECTION Template Settings
  clone      = "ubuntu-server-noble"
  full_clone = true
  # SECTION Boot Process
  onboot           = true
  startup          = ""
  automatic_reboot = true
  # SECTION Hardware Settings
  qemu_os = "other"
  bios    = "seabios"
  memory  = 8192
  cpu {
    cores   = 10
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
  scsihw = "virtio-scsi-single"

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
          storage   = "local-zfs"
          size      = "100G"
          iothread  = true
          replicate = false
        }
      }
    }
  }

  # SECTION Cloud Init Settings
  ipconfig0  = "ip=10.100.110.${103 + count.index}/24,gw=10.100.110.1"
  nameserver = "10.100.110.1"
  ciuser     = "administrator"
  sshkeys    = var.PUBLIC_SSH_KEY
}



resource "proxmox_vm_qemu" "networking_node" {
  # SECTION General Settings
  count       = 1
  desc        = "Homelab Networking Worker Node"
  agent       = 1 # <-- (Optional) Enable QEMU Guest Agent
  target_node = "balo"
  vmid        = 104 + count.index #Unique VM ID Per VM
  # name        = "ubuntu-${101 + count.index}-worker-node"
  name = "monitoring-node"
  # SECTION Template Settings
  clone      = "ubuntu-server-noble"
  full_clone = true
  # SECTION Boot Process
  onboot           = true
  startup          = ""
  automatic_reboot = true
  # SECTION Hardware Settings
  qemu_os = "other"
  bios    = "seabios"
  memory  = 4092
  cpu {
    cores   = 8
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
  scsihw = "virtio-scsi-single"

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
          storage   = "local-zfs"
          size      = "100G"
          iothread  = true
          replicate = false
        }
      }
    }
  }

  # SECTION Cloud Init Settings
  ipconfig0  = "ip=10.100.110.${104 + count.index}/24,gw=10.100.110.1"
  nameserver = "10.100.110.1"
  ciuser     = "administrator"
  sshkeys    = var.PUBLIC_SSH_KEY
}