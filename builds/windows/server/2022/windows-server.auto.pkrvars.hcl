# > Packer Autovars File
# > Description: Autovars file for Packer build

## > VM Settings
# > Installation Operating System Metadata
m_inst_os_image_datacenter_desktop = "Windows Server 2022 SERVERDATACENTER"
vm_inst_os_image_datacenter_core   = "Windows Server 2022 SERVERDATACENTERCORE"
vm_inst_os_image_standard_desktop  = "Windows Server 2022 SERVERSTANDARD"
vm_inst_os_image_standard_core     = "Windows Server 2022 SERVERSTANDARDCORE"
vm_inst_os_kms_key_datacenter      = "WX4NM-KYWYW-QJJR4-XV3QB-6VM33"
vm_inst_os_kms_key_standard        = "VDYBN-27WPP-V4HQT-9VMD4-VMK7H"

# > Guest Operating System Metadata
vm_guest_os_family             = "windows"
vm_guest_os_version            = "2022"
vm_guest_os_language           = "en-US"
vm_guest_os_keyboard           = "en-US"
vm_guest_os_name               = "server"
vm_guest_os_edition_datacenter = "datacenter"
vm_guest_os_edition_standard   = "standard"
vm_guest_os_experience_core    = "core"
vm_guest_os_experience_desktop = "desktop"

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
iso_file                   = "en-us_windows_server_2022_updated_oct_2023_x64_dvd_63dab61a.iso"
enable_windows_secure_boot = false

## > Windows Settings
communicator_winrm_port     = 5985
communicator_winrm_use_ssl  = false
communicator_winrm_insecure = true
communicator_winrm_use_ntlm = false