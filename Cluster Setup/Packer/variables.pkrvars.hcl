proxmox_url      = "https://10.100.110.20:8006/api2/json"
proxmox_username = "packer@pve!packer-admin-token"
# Leave token empty here, provide it in secrets.pkrvars.hcl
vm_id        = "9001"
iso_file     = "local:iso/ubuntu-24.04.1-live-server-amd64.iso"
ssh_username = "ubuntu"
proxmox_node = "balo"
