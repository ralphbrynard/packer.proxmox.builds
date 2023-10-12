/*
    DESCRIPTION:
    Debian 12 (Bookworm) build variables.
*/

// Proxmox variables
proxmox_url = "https://proxmox.lan:8006/api2/json"
proxmox_username = "packer@pve"
proxmox_api_token = "<API_TOKEN>"
proxmox_api_token_id = "packer_api_token"
proxmox_node = "<PROXMOX_NODE>"
proxmox_resource_pool = "<PROXMOX_RESOURCE_POOL>"

// Virtual machine variables
vm_mem_size = 4096
vm_cpu_core_count = 2
vm_cpu_count = 2
vm_os = "l26"
vm_nic_vlan = "13"
vm_scsi_controller = "virtio-scsi-pci"

// Removable media variables
cd_label = "cloud_init"
http_bind_address = "192.168.1.112"

// Communicator variables
build_username = "<BUILD_USERNAME>"
build_password = "<BUILD_PASSWORD>"
build_key = "<BUILD_KEY>"
ansible_username = "<ANSIBLE_USERNAME>"
ansible_password = "<ANSIBLE_PASSWORD>"
ansible_key = "<ANSIBLE_KEY>"