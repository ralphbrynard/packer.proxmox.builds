# > Packer Sources File
# > Description: Sources file for various Packer builds
# > 'proxmox-iso' builder

## > Windows 11 Enterprise
source "proxmox-iso" "windows-desktop-ent" {
  // Proxmox Credentials
  proxmox_url = var.proxmox_endpoint
  username    = var.proxmox_username
  password    = var.proxmox_password
  token       = var.proxmox_api_token

  // Proxmox Settings
  node                     = var.proxmox_host
  pool                     = var.proxmox_resource_pool
  insecure_skip_tls_verify = var.proxmox_insecure_tls
  task_timeout             = var.common_ip_wait_timeout

  // Virtual Machine Settings
  vm_name            = local.vm_name_ent
  vm_id              = var.vm_id
  memory             = var.vm_mem_size
  ballooning_minimum = var.vm_mem_hot_add ? var.vm_min_mem_size : null
  cores              = var.vm_cpu_cores
  sockets            = var.vm_cpu_count
  cpu_type           = var.vm_cpu_type
  numa               = var.enable_numa
  bios               = var.vm_firmware
  qemu_agent         = var.vm_install_tools
  scsi_controller    = var.vm_disk_controller_type
  onboot             = var.start_on_boot
  disable_kvm        = var.disable_hardware_virtualization
  vm_interface       = var.packer_vm_interface

  // Disk Settings
  disks {
    type         = var.vm_disk_type
    storage_pool = var.common_vm_datastore
    disk_size    = var.vm_disk_size
    cache_mode   = var.vm_disk_cache_mode
    format       = var.vm_disk_format
    io_thread    = var.vm_disk_enable_io_threading
    discard      = var.vm_disk_enable_trim
    ssd          = var.vm_disk_enable_ssd
  }

  // EFI Settings
  efi_config {
    efi_storage_pool  = var.is_efi ? var.efi_storage_pool : null
    pre_enrolled_keys = var.is_efi ? var.enable_windows_secure_boot : null
    efi_type          = var.is_efi ? var.efi_type : null
  }

  // Network Settings
  network_adapters {
    model         = var.vm_network_card
    packet_queues = var.enable_multi_queue
    mac_address   = var.vm_nic_mac_address
    mtu           = var.vm_nic_mtu
    vlan_tag      = var.vm_nic_vlan_tag
    bridge        = var.vm_bridge_interface
    firewall      = var.enable_proxmox_firewall
  }

  // Removable Media Settings
  iso_file    = local.iso_file
  unmount_iso = var.common_remove_cdrom

  additional_iso_files {
    unmount          = var.common_remove_cdrom
    iso_url          = null
    iso_checksum     = null
    iso_storage_pool = var.iso_storage_pool
    cd_files         = ["${path.cwd}/scripts/${var.vm_guest_os_family}", "${path.cwd}/windows_files/drivers"]
    cd_content = {
      "autounattend.xml" = templatefile("${abspath(path.root)}/data/autounattend.pkrtpl.hcl", {
        is_efi               = false
        build_username       = var.build_username
        build_password       = var.build_password
        vm_inst_os_language  = var.vm_guest_os_language
        vm_inst_os_keyboard  = var.vm_guest_os_keyboard
        vm_inst_os_image     = var.vm_inst_os_image_ent
        vm_inst_os_kms_key   = var.vm_inst_os_kms_key_ent
        vm_guest_os_language = var.vm_guest_os_language
        vm_guest_os_keyboard = var.vm_guest_os_keyboard
        vm_guest_os_timezone = var.vm_guest_os_timezone
      })
    }
  }

  // Cloud Init Settings
  cloud_init              = var.enable_cloud_init
  cloud_init_storage_pool = var.enable_cloud_init ? var.cloud_init_storage_pool : null

  // Boot Settings
  boot_wait    = var.vm_boot_wait
  boot_command = ["<spacebar><spacebar>"]

  // Communicator Settings
  communicator   = "winrm"
  winrm_username = var.build_username
  winrm_password = var.build_password
  winrm_port     = var.communicator_winrm_port
  winrm_no_proxy = var.communicator_use_proxy
  winrm_host     = var.communicator_host
  winrm_timeout  = var.communicator_timeout
  winrm_use_ssl  = var.communicator_winrm_use_ssl
  winrm_insecure = var.communicator_winrm_insecure
  winrm_use_ntlm = var.communicator_winrm_use_ntlm

  // Template Settings
  template_name        = var.common_template_conversion ? local.vm_name_ent : null
  template_description = var.common_template_conversion ? local.build_description : null
}

## > Windows 11 Pro
source "proxmox-iso" "windows-desktop-pro" {
  // Proxmox Credentials
  proxmox_url = var.proxmox_endpoint
  username    = var.proxmox_username
  password    = var.proxmox_password
  token       = var.proxmox_api_token

  // Proxmox Settings
  node                     = var.proxmox_host
  pool                     = var.proxmox_resource_pool
  insecure_skip_tls_verify = var.proxmox_insecure_tls
  task_timeout             = var.common_ip_wait_timeout

  // Virtual Machine Settings
  vm_name            = local.vm_name_pro
  vm_id              = var.vm_id
  memory             = var.vm_mem_size
  ballooning_minimum = var.vm_mem_hot_add ? var.vm_min_mem_size : null
  cores              = var.vm_cpu_cores
  sockets            = var.vm_cpu_count
  cpu_type           = var.vm_cpu_type
  numa               = var.enable_numa
  bios               = var.vm_firmware
  qemu_agent         = var.vm_install_tools
  scsi_controller    = var.vm_disk_controller_type
  onboot             = var.start_on_boot
  disable_kvm        = var.disable_hardware_virtualization
  vm_interface       = var.packer_vm_interface

  // Disk Settings
  disks {
    type         = var.vm_disk_type
    storage_pool = var.common_vm_datastore
    disk_size    = var.vm_disk_size
    cache_mode   = var.vm_disk_cache_mode
    format       = var.vm_disk_format
    io_thread    = var.vm_disk_enable_io_threading
    discard      = var.vm_disk_enable_trim
    ssd          = var.vm_disk_enable_ssd
  }

  // EFI Settings
  efi_config {
    efi_storage_pool  = var.is_efi ? var.efi_storage_pool : null
    pre_enrolled_keys = var.is_efi ? var.enable_windows_secure_boot : null
    efi_type          = var.is_efi ? var.efi_type : null
  }

  // Network Settings
  network_adapters {
    model         = var.vm_network_card
    packet_queues = var.enable_multi_queue
    mac_address   = var.vm_nic_mac_address
    mtu           = var.vm_nic_mtu
    vlan_tag      = var.vm_nic_vlan_tag
    bridge        = var.vm_bridge_interface
    firewall      = var.enable_proxmox_firewall
  }

  // Removable Media Settings
  iso_file    = local.iso_file
  unmount_iso = var.common_remove_cdrom

  additional_iso_files {
    unmount          = var.common_remove_cdrom
    iso_url          = null
    iso_checksum     = null
    iso_storage_pool = var.iso_storage_pool
    cd_files         = ["${path.cwd}/scripts/${var.vm_guest_os_family}", "${path.cwd}/windows_files/drivers"]
    cd_content = {
      "autounattend.xml" = templatefile("${abspath(path.root)}/data/autounattend.pkrtpl.hcl", {
        is_efi               = false
        build_username       = var.build_username
        build_password       = var.build_password
        vm_inst_os_language  = var.vm_guest_os_language
        vm_inst_os_keyboard  = var.vm_guest_os_keyboard
        vm_inst_os_image     = var.vm_inst_os_image_pro
        vm_inst_os_kms_key   = var.vm_inst_os_kms_key_pro
        vm_guest_os_language = var.vm_guest_os_language
        vm_guest_os_keyboard = var.vm_guest_os_keyboard
        vm_guest_os_timezone = var.vm_guest_os_timezone
      })
    }
  }

  // Cloud Init Settings
  cloud_init              = var.enable_cloud_init
  cloud_init_storage_pool = var.enable_cloud_init ? var.cloud_init_storage_pool : null

  // Boot Settings
  boot_wait    = var.vm_boot_wait
  boot_command = ["<spacebar><spacebar>"]

  // Communicator Settings
  communicator   = "winrm"
  winrm_username = var.build_username
  winrm_password = var.build_password
  winrm_port     = var.communicator_winrm_port
  winrm_no_proxy = var.communicator_use_proxy
  winrm_host     = var.communicator_host
  winrm_timeout  = var.communicator_timeout
  winrm_use_ssl  = var.communicator_winrm_use_ssl
  winrm_insecure = var.communicator_winrm_insecure
  winrm_use_ntlm = var.communicator_winrm_use_ntlm

  // Template Settings
  template_name        = var.common_template_conversion ? local.vm_name_pro : null
  template_description = var.common_template_conversion ? local.build_description : null
}