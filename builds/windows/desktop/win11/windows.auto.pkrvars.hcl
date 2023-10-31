/*
    DESCRIPTION:
    Microsoft Windows 11 build variables.
*/

// Build metadata
build_version = "test"

// Installation Operating System metadata
vm_inst_os_kms_key_pro = "W269N-WFGWX-YVC9B-4J6C9-T83GX"
vm_inst_os_kms_key_ent = "NPPR9-FWDCX-D2C8J-H872K-2YT43"

// Proxmox variables
proxmox_url           = "https://10.1.0.148:8006/api2/json"
proxmox_username      = "packer@pve"
proxmox_api_token     = "46c7eaee-58e5-48c3-8e15-fcc1d8b092b3"
proxmox_api_token_id  = "packer_api_token"
proxmox_node          = "hades"
proxmox_resource_pool = "packer"

// Virtual machine variables
vm_mem_size        = 4096
vm_cpu_core_count  = 2
vm_cpu_count       = 2
vm_os              = "win11"
vm_nic_vlan        = "13"
vm_scsi_controller = "virtio-scsi-single"
vm_storage_pool    = "local-lvm"
vm_disk_type       = "scsi"

// HTTP variables
http_ip = "192.168.1.112"

// Communicator variables
build_username   = "packer"
build_password   = "Windows11DesktopPro"
ansible_username = "ansible"
ansible_password = "Windows11DesktopProAnsible"

// Guest Operating System Metadata
vm_guest_os_language = "en-US"
vm_guest_os_keyboard = "en-US"
vm_guest_os_timezone = "UTC"