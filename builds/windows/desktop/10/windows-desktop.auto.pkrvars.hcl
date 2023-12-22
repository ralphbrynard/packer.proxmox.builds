# > Packer Autovars File
# > Description: Autovars file for Packer build

## > VM Settings
# > Installation Operating System Metadata
vm_inst_os_image_pro   = "Windows 10 Pro"
vm_inst_os_image_ent   = "Windows 10 Enterprise"
vm_inst_os_kms_key_pro = "W269N-WFGWX-YVC9B-4J6C9-T83GX"
vm_inst_os_kms_key_ent = "NPPR9-FWDCX-D2C8J-H872K-2YT43"

# > Guest Operating System Metadata
vm_guest_os_language    = "en-US"
vm_guest_os_keyboard    = "en-US"
vm_guest_os_family      = "windows"
vm_guest_os_name        = "desktop"
vm_guest_os_version     = "10"
vm_guest_os_edition_pro = "pro"
vm_guest_os_edition_ent = "ent"

# > Virtual Machine Hardware Settings
vm_bridge_interface        = "vmbr0"
vm_mem_size                = 4096
vm_cpu_cores               = 2
vm_cpu_count               = 2
vm_cpu_type                = "kvm64"
vm_disk_controller_type    = "virtio-scsi-single"
vm_network_card            = "e1000"
vm_nic_vlan_tag            = 13
iso_storage_pool           = "packer_iso"
vm_disk_size               = "64G"
iso_file                   = "en-us_windows_10_business_editions_version_22h2_updated_oct_2023_x64_dvd_8fac2c2d.iso"
enable_windows_secure_boot = false

# > Communicator Settings
communicator_winrm_port     = 5985
communicator_winrm_use_ssl  = false
communicator_winrm_insecure = true
communicator_winrm_use_ntlm = false