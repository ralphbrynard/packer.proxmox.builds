# > Packer Autovars File
# > Description: Autovars file for Packer build

## > VM Settings
# > Installation Operating System Metadata
vm_guest_os_family  = "linux"
vm_guest_os_version = "12"
vm_guest_os_name    = "debian"

# > Guest Operating System Medata
vm_guest_os_language = "en-US"
vm_guest_os_keyboard = "en-US"

# > Virtual Machine Hardware Settings
vm_bridge_interface     = "vmbr0"
vm_mem_size             = 4096
vm_cpu_cores            = 2
vm_cpu_count            = 2
vm_cpu_type             = "kvm64"
vm_disk_controller_type = "virtio-scsi-single"
vm_network_card         = "e1000"
vm_nic_vlan_tag         = 13
iso_storage_pool        = "packer_iso"
vm_disk_size            = "32G"
iso_file                = "debian-12.1.0-amd64-netinst.iso"

# > Cloud Init Settings
enable_cloud_init       = true
cloud_init_storage_pool = "cidata"