###
#Your Packer template created the disk as scsi0, so the cloned VM expects to boot from a SCSI disk. 
#By using virtio0 in Terraform, Proxmox didn’t see a bootable disk in the right place. 
#Switching the Terraform disks to SCSI (scsi0) aligns it with the template, and now Proxmox can find the OS.

#Users don't have passwords - VMs need to be shut down and a password must be manually set inside proxmox > cloud-init

#Also I need to add the Packer code to the Repo



resource "proxmox_vm_qemu" "master_node" {
  # SECTION General Settings
  count       = 1
  desc        = "Homelab Master Node"
  agent       = 1 # <-- (Optional) Enable QEMU Guest Agent
  target_node = "balo"
  vmid        = 201 + count.index #Unique VM ID Per VM
  # name        = "ubuntu-${101 + count.index}-worker-node"
  name = "Homelab-control-plane"
  # SECTION Template Settings
  clone      = "ubuntu-2404-template"
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
      ide1 {
        cloudinit {
          storage = "local"
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          storage   = "local"
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
  ciuser     = "ubuntu"
  sshkeys    = var.PUBLIC_SSH_KEY
}

resource "proxmox_vm_qemu" "media-node" {
  # SECTION General Settings
  count       = 1
  desc        = "Homelab Worker Node"
  agent       = 1 # <-- (Optional) Enable QEMU Guest Agent
  target_node = "balo"
  vmid        = 202 + count.index #Unique VM ID Per VM
  # name        = "ubuntu-${101 + count.index}-worker-node"
  name = "media-node"
  # SECTION Template Settings
  clone      = "ubuntu-2404-template"
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
      ide1 {
        cloudinit {
          storage = "workhorse-pool"
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          storage   = "workhorse-pool"
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
  ciuser     = "ubuntu"
  sshkeys    = var.PUBLIC_SSH_KEY
}




resource "proxmox_vm_qemu" "cloud_node" {
  # SECTION General Settings
  count       = 1
  desc        = "Homelab Worker Node"
  agent       = 1 # <-- (Optional) Enable QEMU Guest Agent
  target_node = "balo"
  vmid        = 203 + count.index #Unique VM ID Per VM
  # name        = "ubuntu-${101 + count.index}-worker-node"
  name = "cloud-node"
  # SECTION Template Settings
  clone      = "ubuntu-2404-template"
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
      ide1 {
        cloudinit {
          storage = "workhorse-pool"
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          storage   = "workhorse-pool"
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
  ciuser     = "ubuntu"
  sshkeys    = var.PUBLIC_SSH_KEY
}



resource "proxmox_vm_qemu" "networking_node" {
  # SECTION General Settings
  count       = 1
  desc        = "Homelab Networking Worker Node"
  agent       = 1 # <-- (Optional) Enable QEMU Guest Agent
  target_node = "balo"
  vmid        = 204 + count.index #Unique VM ID Per VM
  # name        = "ubuntu-${101 + count.index}-worker-node"
  name = "monitoring-node"
  # SECTION Template Settings
  clone      = "ubuntu-2404-template"
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
      ide1 {
        cloudinit {
          storage = "workhorse-pool"
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          storage   = "workhorse-pool"
          size      = "50G"
          iothread  = true
          replicate = false
        }
      }
    }
  }

  # SECTION Cloud Init Settings
  ipconfig0  = "ip=10.100.110.${104 + count.index}/24,gw=10.100.110.1"
  nameserver = "10.100.110.1"
  ciuser     = "ubuntu"
  sshkeys    = var.PUBLIC_SSH_KEY
}