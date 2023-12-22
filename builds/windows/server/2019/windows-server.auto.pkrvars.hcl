# > Packer Autovars File
# > Description: Autovars file for Packer build

## > VM Settings
# > Installation Operating System Metadata
vm_inst_os_image_datacenter_desktop = "Windows Server 2019 SERVERDATACENTER"
vm_inst_os_image_datacenter_core    = "Windows Server 2019 SERVERDATACENTERCORE"
vm_inst_os_image_standard_desktop   = "Windows Server 2019 SERVERSTANDARD"
vm_inst_os_image_standard_core      = "Windows Server 2019 SERVERSTANDARDCORE"
vm_inst_os_kms_key_datacenter       = "WMDGN-G9PQG-XVVXX-R3X43-63DFG"
vm_inst_os_kms_key_standard         = "N69G4-B89J2-4G8F4-WWYCC-J464C"

# > Guest Operating System Metadata
vm_guest_os_family             = "windows"
vm_guest_os_version            = "2019"
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
iso_file                   = "en_windows_server_2019_updated_aug_2019_x64_dvd_cdf24600.iso"
enable_windows_secure_boot = false

## > Windows Settings
communicator_winrm_port     = 5985
communicator_winrm_use_ssl  = false
communicator_winrm_insecure = true
communicator_winrm_use_ntlm = false