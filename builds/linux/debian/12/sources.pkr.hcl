# > Packer Sources File
# > Description: Sources file for various Packer builds
# > 'proxmox-iso' builder

# > Linux Debian 12
source "proxmox-iso" "linux-debian" {
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
  vm_name            = local.vm_name
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

  dynamic "additional_iso_files" {
    for_each = var.common_data_source == "disk" ? [1] : [0]
    content {
      unmount    = var.common_remove_cdrom
      device = "sata0"
      iso_storage_pool = var.iso_storage_pool
      cd_content = local.data_source_content
    }
  }

  // HTTP Data
  http_content      = var.common_data_source == "http" ? local.data_source_content : null
  http_port_max     = var.http_port_max
  http_port_min     = var.http_port_min
  http_bind_address = var.http_bind_address

  // Cloud Init Settings
  cloud_init              = var.enable_cloud_init
  cloud_init_storage_pool = var.enable_cloud_init ? var.cloud_init_storage_pool : null

  // Boot Settings
  boot_wait = "5s"
  boot_command = [
    "<esc><wait>",
    "${local.data_source_command}",
    "<enter><wait>",
    "${local.mount_cdrom}",
    "<down><down><down><down><enter>"
  ]

  // Communicator Settings
  communicator         = "ssh"
  ssh_username         = var.build_username
  ssh_password         = var.build_password
  ssh_private_key_file = data.sshkey.build_key.private_key_path

  // Template Settings
  template_name        = var.common_template_conversion ? local.vm_name : null
  template_description = var.common_template_conversion ? local.build_description : null
}