# > Build Variables
# > Description: Build variables for Packer builds.

## > Communicator Credentials
build_username = "vagrant"
build_password = "V@gran+!"

## > Virtual Machine Settings
vm_bridge_interface = "vmbr0"
vm_mem_size = 2048
vm_cpu_cores = 1
vm_cpu_count = 1
vm_cpu_type = "kvm64"
vm_disk_controller_type = "virtio-scsi-single"
vm_network_card = "e1000"
vm_nic_vlan_tag = "12"
iso_storage_pool = ""

## > Windows Settings
enable_windows_secure_boot = false
communicator_winrm_port = 5985
communicator_winrm_use_ssl = false
communicator_winrm_insecure = true
communicator_winrm_use_ntlm = false

## > Windows Server 2019 Specific Variables
vm_inst_os_kms_key_datacenter = "WMDGN-G9PQG-XVVXX-R3X43-63DFG"
vm_inst_os_kms_key_standard   = "N69G4-B89J2-4G8F4-WWYCC-J464C"

