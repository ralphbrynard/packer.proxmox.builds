/*
    DESCRIPTION:
    Debian 12 (Bookworm) build definition.
    Packer Plugin for Proxmox (`proxmox-iso` builder).
*/

//  BLOCK: packer
//  The Packer configuration.

packer {
  required_plugins {
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "~> 1"
    }
    proxmox = {
      version = ">= 1.1.3"
      source  = "github.com/hashicorp/proxmox"
    }
    git = {
      version = ">= 0.4.3"
      source  = "github.com/ethanmdavidson/git"
    }
  }
}

//  BLOCK: data
//  Defines the data sources.

data "git-repository" "cwd" {}

//  BLOCK: locals
//  Defines the local variables.

locals {
  ansible_password_encrypted = bcrypt(var.ansible_password)
  build_password_encrypted   = bcrypt(var.build_password)

  additional_cd_files = ["./config/"]

  boot_command = [
    "<esc><wait>",
    "auto preseed/url=http://${local.http_ip}:{{ .HTTPPort }}/preseed.cfg",
    "<enter>"
  ]
  build_by          = "Built by: HashiCorp Packer ${packer.version}"
  build_date        = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
  build_version     = data.git-repository.cwd.head
  build_description = "Version: ${local.build_version}\nBuilt on: ${local.build_date}\n${local.build_by}"

  http_ip = var.http_bind_address == null ? "{{ .HTTPIP }}" : var.http_bind_address

  iso_file = "debian-12.1.0-amd64-netinst.iso"
  iso_target_path = "${path.root}"
  iso_target_extension = "iso"
  manifest_date   = formatdate("YYYY-MM-DD hh:mm:ss", timestamp())
  manifest_path   = "${path.cwd}/manifests/"
  manifest_output = "${local.manifest_path}${local.manifest_date}.json"

  proxmox_username = !(var.proxmox_api_token == null) ? join("!", [var.proxmox_username, var.proxmox_api_token_id]) : var.proxmox_username

  vm_guest_os_family  = "linux"
  vm_guest_os_name    = "debian"
  vm_guest_os_version = "12"
  vm_name             = "${local.vm_guest_os_family}.${local.vm_guest_os_name}${local.vm_guest_os_version}"
  vm_iso_file         = var.vm_iso_file == null ? join("/", ["local:iso", local.iso_file]) : null

  data_source_content = {
    "/preseed.cfg" = templatefile("${abspath(path.root)}/data/preseed.pkrtpl.hcl", {
      build_username           = var.build_username
      build_password           = var.build_password
      build_password_encrypted = local.build_password_encrypted
      vm_guest_os_language     = var.vm_guest_os_language
      vm_guest_os_keyboard     = var.vm_guest_os_keyboard
      vm_guest_os_timezone     = var.vm_guest_os_timezone
      common_data_source       = var.common_data_source
    })
  }
  data_source_command = var.common_data_source == "http" ? local.http_ip : "file=/media/preseed.cfg"
  mount_cdrom_command = "<leftAltOn><f2><leftAltOff> <enter><wait> mount /dev/sr1 /media<enter> <leftAltOn><f1><leftAltOff>"
  mount_cdrom         = var.common_data_source == "http" ? " " : local.mount_cdrom_command
}
 
source "file" "cloud-init" {
    content = templatefile("${abspath(path.root)}/config/cloud.pkrtpl.cfg", {
      ansible_username = var.ansible_username
      ansible_password = local.ansible_password_encrypted
      ansible_key      = var.ansible_key != null ? var.ansible_key : ""
      build_username = var.build_username
      build_password = local.build_password_encrypted
      build_key        = var.build_key != null ? var.build_key : ""
      vm_guest_os_language     = var.vm_guest_os_language
      vm_guest_os_keyboard     = var.vm_guest_os_keyboard
      vm_guest_os_timezone     = var.vm_guest_os_timezone
    })
    target = "${path.root}/config/cloud.cfg"
}

source "proxmox-iso" "linux-debian" {
  // Proxmox datacenter and credentials
  proxmox_url              = var.proxmox_url
  username                 = local.proxmox_username
  password                 = var.proxmox_api_token == null ? var.proxmox_password : null
  token                    = var.proxmox_password == null ? var.proxmox_api_token : null
  insecure_skip_tls_verify = var.proxmox_insecure_connection

  // Proxmox settings
  node         = var.proxmox_node
  pool         = var.proxmox_resource_pool
  task_timeout = var.proxmox_task_timeout

  // Virtual Machine settings
  vm_name            = local.vm_name
  vm_id              = var.vm_id
  memory             = var.vm_mem_size
  ballooning_minimum = var.vm_enable_ballooning ? var.vm_min_mem_size : 0
  cores              = var.vm_cpu_core_count
  sockets            = var.vm_cpu_count
  os                 = var.vm_os
  bios               = var.vm_bios
  qemu_agent         = var.vm_enable_qemu_agent
  scsi_controller    = var.vm_scsi_controller
  onboot             = var.vm_start_on_boot
  disable_kvm        = var.vm_disable_kvm
  vm_interface       = var.vm_interface

  network_adapters {
    model         = var.vm_nic_model
    packet_queues = var.vm_enable_queues ? var.vm_number_of_queues : 0
    mac_address   = var.vm_nic_mac_address
    mtu           = var.vm_nic_mtu
    bridge        = var.vm_nic_bridge
    vlan_tag      = var.vm_nic_vlan
    firewall      = var.vm_enable_firewall
  }

  disks {
    type         = var.vm_disk_type
    storage_pool = var.vm_storage_pool
    disk_size    = var.vm_disk_size
    cache_mode   = var.vm_cache_mode
    format       = var.vm_disk_format
    io_thread    = var.vm_enable_io_threading
    discard      = var.vm_enable_disk_discard
    ssd          = var.vm_enable_ssd
  }

  // Removable media settings
  iso_file    = local.vm_iso_file
  unmount_iso = var.vm_unmount_iso
  additional_iso_files {
    iso_storage_pool = var.iso_storage_pool
    cd_files         = concat(["${path.root}/config"], var.additional_cd_files)
    cd_label         = var.cd_label
  }

  // HTTP data
  http_content      = var.common_data_source == "http" ? local.data_source_content : null
  http_port_max     = var.http_port_max
  http_port_min     = var.http_port_min
  http_bind_address = var.http_bind_address
  http_interface    = var.http_interface

  // Cloud init settings
  cloud_init              = var.enable_cloud_init
  cloud_init_storage_pool = var.iso_storage_pool

  // Boot settings
  boot_wait    = var.boot_wait
    boot_command = [
    "<esc><wait>",
    "auto preseed/url=http://${local.http_ip}:{{ .HTTPPort }}/preseed.cfg",
    "<enter>"
  ]

  // Communicator settings and credentials
  communicator = "ssh"
  ssh_username = var.build_username
  ssh_password = var.build_password

  // Template settings
  template_name        = var.common_create_template ? local.template_name : null
  template_description = var.common_create_template ? local.template_description : null
}

build {
  sources = [
    "source.file.cloud-init",
//    "source.proxmox-iso.linux-debian"
  ]
}