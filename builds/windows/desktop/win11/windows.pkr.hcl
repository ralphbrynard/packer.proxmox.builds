//  BLOCK: variable
//  Defines the input variables.
variable "build_version" {
  type        = string
  description = "The version of the build"
  default     = null
}

// Proxmox Credentials
variable "proxmox_url" {
  type        = string
  description = "The URL to the Proxmox API endpoint."
}

variable "proxmox_username" {
  type        = string
  description = "The username to login to the Proxmox datacenter"
}

variable "proxmox_password" {
  type        = string
  description = "The password for the Proxmox user."
  default     = null
  sensitive   = true
}

variable "proxmox_api_token" {
  type        = string
  description = "The API token to use for the Proxmox user."
  default     = null
}

variable "proxmox_api_token_id" {
  type        = string
  description = "If a Proxmox API token is being used for authentication, the token ID must be provided."
  default     = null
}

variable "proxmox_insecure_connection" {
  type        = bool
  description = "Whether or not the connection to the Proxmox data center is using a signed or self-sign SSL certificate."
  default     = true
}

// Proxmox settings
variable "proxmox_node" {
  type        = string
  description = "Which node in the Proxmox datacenter to run the build on."
}

variable "proxmox_resource_pool" {
  type        = string
  description = "The Proxmox resource pool in which to build the VM."
  default     = null
}

variable "proxmox_task_timeout" {
  type        = string
  description = "The task timeout for the running build."
  default     = "10m"
}

variable "vm_inst_os_keyboard" {
  type        = string
  description = "The installation operating system keyboard input."
  default     = "en-US"
}

variable "vm_inst_os_image_pro" {
  type        = string
  description = "The installation operating system image input."
  default     = "Windows 11 Pro"
}

variable "vm_inst_os_image_ent" {
  type        = string
  description = "The installation operating system image input."
  default     = "Windows 11 Enterprise"
}

variable "vm_inst_os_kms_key_pro" {
  type        = string
  description = "The installation operating system KMS key input."
}

variable "vm_inst_os_kms_key_ent" {
  type        = string
  description = "The installation operating system KMS key input."
}

// Virtual machine settings
variable "vm_name" {
  type        = string
  description = "The name of the VM"
  default     = null
}

variable "vm_guest_os_family" {
  type        = string
  description = "The OS family of the virtual machine."
  default     = "Windows"
}

variable "vm_guest_os_name" {
  type        = string
  description = "The OS name of the virtual machine."
  default     = "desktop"
}

variable "vm_guest_os_version" {
  type        = string
  description = "The OS version of the virtual machine."
  default     = "11"
}

variable "vm_guest_os_language" {
  type        = string
  description = "The language to be used for the operating system."
  default     = "en-US"
}

variable "vm_guest_os_keyboard" {
  type        = string
  description = "The keyboard layout to use for the VM."
  default     = "en-US"
}

variable "vm_guest_os_timezone" {
  type        = string
  description = "The timezone to use for the VM."
  default     = "UTC"
}

variable "vm_guest_os_edition_ent" {
  type        = string
  description = "The guest operating system edition. Used for naming."
  default     = "ent"
}

variable "vm_guest_os_edition_pro" {
  type        = string
  description = "The guest operating system edition. Used for naming."
  default     = "pro"
}

variable "vm_id" {
  type        = string
  description = "The VM ID to assign to the Virtual Machine. If not define the next available will be selected."
  default     = null
}

variable "vm_mem_size" {
  type        = number
  description = "The amount of memory for the VM."
  default     = 2048
}

variable "vm_enable_ballooning" {
  type        = bool
  description = "Whether to enable memory balooning on the VM."
  default     = false
}

variable "vm_min_mem_size" {
  type        = number
  description = "If balooning is enabled, the minimum VM memory size."
  default     = 1024
}

variable "vm_cpu_core_count" {
  type        = number
  description = "The number of CPU cores to assign to the VM."
  default     = 2
}

variable "vm_cpu_count" {
  type        = number
  description = "The number of vCPU's to assign to the VM."
  default     = 2
}

variable "vm_os" {
  type        = string
  description = "The VM operating system. Can be; `wxp`. `w2k`, `w2k3`, `w2k8`, `wvista`, `win7`, `win8`, `win10`, `win11`, `l24`, `l26`, `solaris`, or `other`."
  default     = "win11"
  validation {
    condition     = contains(["wxp", "w2k", "w2k3", "w2k8", "wvista", "win7", "win8", "win10", "win11", "l24", "l26", "solaris", "other"], var.vm_os)
    error_message = "Invalid value provided. Must be one of: `wxp`. `w2k`, `w2k3`, `w2k8`, `wvista`, `win7`, `win8`, `win10`, `l24`, `l26`, `solaris`, or `other`."
  }
}

variable "vm_bios" {
  type        = string
  description = "The Virtual Machine BiOS. Can be either `seabios`, or `ovmf`"
  default     = "seabios"
  validation {
    condition     = contains(["seabios", "ovmf"], var.vm_bios)
    error_message = "Invalid value provided. Must be either: `seabios`, or `ovmf`."
  }
}

variable "vm_nic_model" {
  type        = string
  description = "Model of the virtual network adapter."
  default     = "e1000"
  validation {
    condition     = contains(["rtl8139", "ne2k_pci", "e1000", "pcnet", "virtio", "ne2k_isa", "i82551", "i82557b", "i82559er", "vmxnet3", "e1000-82540em", "e1000-82544gc", "e1000-82545em", "e1000"], var.vm_nic_model)
    error_message = "Invalid value provided. Must be one of: rtl8139, ne2k_pci, e1000, pcnet, virtio, ne2k_isa, i82551, i82557b, i82559er, vmxnet3, e1000-82540em, e1000-82544gc, e1000-82545em, or e1000."
  }
}

variable "vm_enable_queues" {
  type        = bool
  description = "Whether to enable packet queues on the VM."
  default     = false
}

variable "vm_number_of_queues" {
  type        = number
  description = "If packet queueing is enabled, the number of queues to enable on the VM. Must be equal to the number of CPU cores on the VM."
  default     = 1
}

variable "vm_nic_mac_address" {
  type        = string
  description = "The MAC address of the VM. If not defined, a dynamic MAC address will be used."
  default     = null
}

variable "vm_nic_mtu" {
  type        = number
  description = "The MTU size for the adapter. Valid range: 0-65520."
  default     = 0
}

variable "vm_nic_bridge" {
  type        = string
  description = "Which Proxmox bridge to attach the adapter to."
  default     = "vmbr0"
}

variable "vm_nic_vlan" {
  type        = string
  description = "If the adapter should tag packets. Defaults to no tagging."
  default     = null
}

variable "vm_enable_firewall" {
  type        = bool
  description = " If the interface should be protected by the firewall. Defaults to false."
  default     = false
}

variable "vm_disk_type" {
  type        = string
  description = "The type of disk. Can be one of: `scsi`, `sata`, `virtio`,`ide`. Defaults to `scsi`."
  default     = "scsi"
  validation {
    condition     = contains(["scsi", "sata", "virtio", "ide"], var.vm_disk_type)
    error_message = "Invalid value provided. Allowed values are: `scsi`, `sata`, `virtio`,`ide`. Defaults to `scsi`."
  }
}

variable "vm_storage_pool" {
  type        = string
  description = " Required. Name of the Proxmox storage pool to store the virtual machine disk on. A local-lvm pool is allocated by the installer, for example."
}

variable "vm_disk_size" {
  type        = string
  description = "The size of the disk, including a unit suffix, such as 10G to indicate 10 gigabytes."
  default     = null
}

variable "vm_cache_mode" {
  type        = string
  description = "How to cache operations to the disk. Can be `none`, `writethrough`, `writeback`, `unsafe` or `directsync`. Defaults to `none`."
  default     = "none"
  validation {
    condition     = contains(["none", "writethrough", "writeback", "unsafe", "directsync"], var.vm_cache_mode)
    error_message = "Invalid value provided. Must be one of: `none`, `witethrough`, `writeback`, `unsafe` or `directsync`."
  }
}

variable "vm_disk_format" {
  type        = string
  description = "The format of the file backing the disk. Can be `raw`, `cow`, `qcow`, `qed`, `qcow2`, `vmdk` or `cloop`. Defaults to `raw`."
  default     = "raw"
  validation {
    condition     = contains(["raw", "cow", "qcow", "qed", "qcow2", "vmdk", "cloop"], var.vm_disk_format)
    error_message = "Invalid value provided. Must be one of: `raw`, `cow`, `qcow`, `qed`, `qcow2`, `vmdk` or `cloop`."
  }
}

variable "vm_enable_io_threading" {
  type        = bool
  description = "Create one I/O thread per storage controller, rather than a single thread for all I/O. This can increase performance when multiple disks are used. Requires virtio-scsi-single controller and a scsi or virtio disk. Defaults to false."
  default     = false
}

variable "vm_enable_disk_discard" {
  type        = bool
  description = "Relay TRIM commands to the underlying storage. Defaults to false."
  default     = false
}

variable "vm_enable_ssd" {
  type        = bool
  description = "Drive will be presented to the guest as solid-state drive rather than a rotational disk."
  default     = false
}

variable "vm_enable_qemu_agent" {
  type        = bool
  description = "Enables QEMU Agent option for this VM."
  default     = true
}

variable "vm_scsi_controller" {
  type        = string
  description = "The SCSI controller model to emulate. Can be `lsi`, `lsi53c810`, `virtio-scsi-pci`, `virtio-scsi-single`, `megasas`, or `pvscsi`. Defaults to lsi."
  default     = "virtio-scsi-single"
  validation {
    condition     = contains(["lsi", "lsi53c810", "virtio-scsi-pci", "virtio-scsi-single", "megasas", "pvscsi"], var.vm_scsi_controller)
    error_message = "Invalid value provided. Must be one of: `lsi`, `lsi53c810`, `virtio-scsi-pci`, `virtio-scsi-single`, `megasas`, or `pvscsi`."
  }
}

variable "vm_start_on_boot" {
  type        = bool
  description = "Specifies whether a VM will be started during system bootup."
  default     = true
}

variable "vm_disable_kvm" {
  type        = bool
  description = "Disables KVM hardware virtualization. Defaults to false."
  default     = false
}

variable "vm_iso_file" {
  type        = string
  description = "Path to the ISO file to boot from, expressed as a proxmox datastore path, for example local:iso/Fedora-Server-dvd-x86_64-29-1.2.iso. Either iso_file OR iso_url must be specifed."
  default     = null
}

variable "vm_iso_url" {
  type        = string
  description = "A URL to the ISO containing the installation image or virtual hard drive (VHD or VHDX) file to clone."
  default     = null
}

variable "vm_iso_checksum" {
  type        = string
  description = "The checksum for the ISO file or virtual hard drive file. The type of the checksum is specified within the checksum field as a prefix, ex: `md5:{$checksum}`. The type of the checksum can also be omitted and Packer will try to infer it based on string length. Valid values are `none`, `{$checksum}`, `md5:{$checksum}`, `sha1:{$checksum}`, `sha256:{$checksum}`, `sha512:{$checksum}` or `file:{$path}`."
  default     = null
}

variable "vm_interface" {
  type        = string
  description = " Name of the network interface that Packer gets the VMs IP from. Defaults to the first non loopback interface."
  default     = null
}

variable "vm_unmount_iso" {
  type        = bool
  description = "If true, remove the mounted ISO from the template after finishing. Defaults to `true`."
  default     = true
}

variable "vm_efi_type" {
  type        = string
  description = " Specifies the version of the OVMF firmware to be used. Can be 2m or 4m. Defaults to 4m."
  default     = "4m"
  validation {
    condition     = contains(["2m", "4m"], var.vm_efi_type)
    error_message = "Invalid value provided. Must be one of `2m`, `4m`."
  }
}

variable "vm_efi_pre_enrolled_keys" {
  type        = bool
  description = " Whether Microsoft Standard Secure Boot keys should be pre-loaded on the EFI disk. Defaults to false."
  default     = false
}

// Additional iso files
variable "additional_cd_files" {
  type        = list(string)
  description = "Additional files to add to the attached CD."
  default     = []
}

variable "cd_content" {
  type        = string
  description = "String path to a template file or file that contains the CD content"
  default     = null
}

variable "cd_label" {
  type        = string
  description = "Label to attach to the attched CD's"
  default     = null
}

variable "iso_storage_pool" {
  type        = string
  description = "The storage pool to upload the attached iso file to."
  default     = null
}
// HTTP data
variable "http_content" {
  type        = string
  description = "String path to a template file or file that contains the HTTP content."
  default     = null
}

variable "http_port_max" {
  type        = number
  description = "The highest port value in a range of HTTP ports."
  default     = 8099
}

variable "http_port_min" {
  type        = number
  description = "The lowest port value in a range of HTTP ports."
  default     = 8000
}

variable "http_bind_address" {
  type        = string
  description = "The address to use for the HTTP server."
  default     = null
}

variable "http_ip" {
  type        = string
  description = "A custom IP address to use in the boot command."
  default     = null
}

variable "http_interface" {
  type        = string
  description = "The network interface to bind the HTTP server to."
  default     = null
}

// Cloud Init
variable "enable_cloud_init" {
  type        = bool
  description = "If true, add an empty Cloud-Init CDROM drive after the virtual machine has been converted to a template. Defaults to false."
  default     = false
}

variable "cloud_init_storage_pool" {
  type        = string
  description = "Name of the Proxmox storage pool to store the Cloud-Init CDROM on. If not given, the storage pool of the boot device will be used."
  default     = null
}

// Boot settings
variable "boot_wait" {
  type        = string
  description = "The time to wait after booting the initial virtual machine before typing the boot_command."
  default     = "3s"
}

// Communicator settings
variable "build_username" {
  type        = string
  description = "The username to use for the build."
}

variable "build_password" {
  type        = string
  description = "The password to use for the build."
  sensitive   = true
}

variable "build_key" {
  type        = string
  description = "The SSH Public Key to use for the build."
  default     = null
  sensitive   = true
}

variable "ansible_username" {
  type        = string
  description = "The Ansible provisioner username."
}

variable "ansible_password" {
  type        = string
  description = "The Ansible provisioner password."
  sensitive   = true
}

variable "ansible_key" {
  type        = string
  description = "The SSH Public Key to use for the Ansible provisioner."
  default     = null
  sensitive   = true
}

// Communicator Credentials
variable "communicator_type" {
  type        = string
  description = "The communicator type to use for Packer provisioning. Allowed values are `winrm`, or `ssh`."
  default     = "winrm"
  validation {
    condition     = contains(["ssh", "winrm"], var.communicator_type)
    error_message = "Invalid value provided. Allowed values are either: `ssh` or `winrm`."
  }
}

variable "communicator_port" {
  type        = number
  description = "The port for the communicator protocol."
  default     = 5985
}

variable "communicator_timeout" {
  type        = string
  description = "The timeout for the communicator protocol."
  default     = "12h"
}

variable "communicator_host" {
  type        = string
  description = "The address for WinRM to connect to."
  default     = null
}

variable "communicator_proxy" {
  type        = bool
  description = "Setting this to `true` adds the remote host:port to the NO_PROXY environment variable. This has the effect of bypassing any configured proxies when connecting to the remote host. Default to `false`."
  default     = false
}

variable "communicator_use_ssl" {
  type        = bool
  description = "If `true`, use HTTPS for WinRM."
  default     = false
}

variable "communicator_insecure" {
  type        = bool
  description = "If `true`, do not check server certificate chain and host name."
  default     = false
}

variable "communicator_use_ntlm_auth" {
  type        = bool
  description = " If `true`, NTLMv2 authentication (with session security) will be used for WinRM, rather than default (basic authentication), removing the requirement for basic authentication to be enabled within the target guest."
  default     = false
}

// Provisioner Settings

variable "scripts" {
  type        = list(string)
  description = "A list of scripts and their relative paths to transfer and run."
  default     = ["scripts/windows/windows-prepare.ps1"]
}

variable "inline" {
  type        = list(string)
  description = "A list of commands to run."
  default     = ["Get-EventLog -LogName * | ForEach { Clear-EventLog -LogName $_.Log }"]
}

// Common variables
variable "common_create_template" {
  type        = bool
  description = "Whether to create a template from the virtual machine."
  default     = false
}

variable "common_data_source" {
  type        = string
  description = "The provisioning data source. Can be either `http`, or `disk`."
  default     = "disk"
}

/*
    DESCRIPTION:
    Microsoft Windows 11 build definition.
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
    windows-update = {
      source  = "github.com/rgl/windows-update"
      version = ">= 0.14.3"
    }
  }
}

//  BLOCK: locals
//  Defines the local variables.

locals {
  build_by          = "Built by: HashiCorp Packer ${packer.version}"
  build_date        = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
  build_version     = var.build_version
  build_description = !(var.build_version == null) ? "Version: ${local.build_version}\nBuilt on: ${local.build_date}\n${local.build_by}" : "Build on: ${local.build_date}\n${local.build_by}"

  http_ip = var.http_ip == null ? "{{ .HTTPIP }}" : var.http_ip

  iso_file = "en-us_windows_11_business_editions_version_22h2_updated_oct_2023_x64_dvd_e6b6f11c.iso"
  vm_os    = "w11"

  manifest_date   = formatdate("YYYY-MM-DD hh:mm:ss", timestamp())
  manifest_path   = "${path.cwd}/manifests/"
  manifest_output = "${local.manifest_path}${local.manifest_date}.json"

  proxmox_username = !(var.proxmox_api_token == null) ? join("!", [var.proxmox_username, var.proxmox_api_token_id]) : var.proxmox_username

  vm_guest_os_family      = "windows"
  vm_guest_os_name        = "desktop"
  vm_guest_os_version     = "11"
  vm_guest_os_edition_ent = "ent"
  vm_guest_os_edition_pro = "pro"
  vm_name                 = "${local.vm_guest_os_family}.${local.vm_guest_os_name}${local.vm_guest_os_version}"
  vm_iso_file             = var.vm_iso_file == null ? join("/", ["local:iso", local.iso_file]) : null
  data_source_content     = null

  template_name        = local.vm_name
  template_description = local.build_description
}

//  BLOCK: source
//  Defines the builder configuration blocks.
source "proxmox-iso" "windows-desktop-ent" {
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
  vm_name            = "${var.vm_guest_os_name}-${var.vm_guest_os_edition_ent}.${var.vm_guest_os_family}${var.vm_guest_os_version}"
  vm_id              = var.vm_id
  memory             = !(var.vm_mem_size == null) ? var.vm_mem_size : 4096
  ballooning_minimum = var.vm_enable_ballooning ? var.vm_min_mem_size : 0
  cores              = !(var.vm_cpu_core_count == null) ? var.vm_cpu_core_count : 2
  sockets            = !(var.vm_cpu_count == null) ? var.vm_cpu_count : 2
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
    disk_size    = !(var.vm_disk_size == null) ? var.vm_disk_size : "32G"
    cache_mode   = var.vm_cache_mode
    format       = var.vm_disk_format
    io_thread    = var.vm_enable_io_threading
    discard      = var.vm_enable_disk_discard
    ssd          = var.vm_enable_ssd
  }

  // Removable media settings
  iso_file     = !(var.vm_iso_url == null) ? var.vm_iso_file : null
  iso_url      = !(var.vm_iso_file == null) ? var.vm_iso_url : null
  iso_checksum = !(var.vm_iso_url == null) ? var.vm_iso_checksum : null
  unmount_iso  = var.vm_unmount_iso
  additional_iso_files {
    unmount          = true
    iso_storage_pool = var.iso_storage_pool
    cd_files         = ["${path.cwd}/scripts/${local.vm_guest_os_family}/", "${path.cwd}/drivers/"]
    cd_content = {
      "autounattend.xml" = templatefile("${abspath(path.root)}/data/autounattend.pkrtpl.hcl", {
        build_username       = var.build_username
        build_password       = var.build_password
        ansible_username     = var.ansible_username
        ansible_password     = var.ansible_password
        vm_os                = local.vm_os
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

  // HTTP data
  http_content      = var.common_data_source == "http" ? local.data_source_content : null
  http_port_max     = var.common_data_source == "http" ? var.http_port_max : null
  http_port_min     = var.common_data_source == "http" ? var.http_port_min : null
  http_bind_address = var.common_data_source == "http" ? var.http_bind_address : null
  http_interface    = var.common_data_source == "http" ? var.http_interface : null

  // Cloud init settings
  cloud_init              = var.enable_cloud_init
  cloud_init_storage_pool = var.enable_cloud_init ? var.cloud_init_storage_pool : null

  // Boot settings
  boot_wait    = var.boot_wait
  boot_command = ["<spacebar><spacebar>"]

  // Communicator settings and credentials
  communicator   = "winrm"
  winrm_username = var.build_username
  winrm_password = var.build_password
  winrm_port     = var.communicator_port
  winrm_host     = var.communicator_host
  winrm_no_proxy = var.communicator_proxy
  winrm_timeout  = var.communicator_timeout
  winrm_use_ssl  = var.communicator_use_ssl
  winrm_insecure = var.communicator_insecure
  winrm_use_ntlm = var.communicator_use_ntlm_auth


  // Template settings
  template_name        = var.common_create_template ? local.template_name : null
  template_description = var.common_create_template ? local.template_description : null

}

source "proxmox-iso" "windows-desktop-pro" {
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
  vm_name            = "${local.vm_name}pro"
  vm_id              = var.vm_id
  memory             = !(var.vm_mem_size == null) ? var.vm_mem_size : 4096
  ballooning_minimum = var.vm_enable_ballooning ? var.vm_min_mem_size : 0
  cores              = !(var.vm_cpu_core_count == null) ? var.vm_cpu_core_count : 2
  sockets            = !(var.vm_cpu_count == null) ? var.vm_cpu_count : 2
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
    disk_size    = !(var.vm_disk_size == null) ? var.vm_disk_size : "32G"
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
    iso_storage_pool = local.iso_storage_pool
    cd_files         = ["${path.cwd}/scripts/${local.vm_guest_os_family}/", "${path.cwd}/drivers/"]
    cd_content = {
      "autounattend.xml" = templatefile("${abspath(path.root)}/data/autounattend.pkrtpl.hcl", {
        build_username       = var.build_username
        build_password       = var.build_password
        ansible_username     = var.ansible_username
        ansible_password     = var.ansible_password
        vm_os                = local.vm_os
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

  // HTTP data
  http_content      = var.common_data_source == "http" ? local.data_source_content : null
  http_port_max     = var.http_port_max
  http_port_min     = var.http_port_min
  http_bind_address = var.http_bind_address
  http_interface    = var.http_interface

  // Boot settings
  boot_wait    = var.boot_wait
  boot_command = ["<spacebar><spacebar>"]

  // Communicator settings and credentials
  communicator   = "winrm"
  winrm_username = var.build_username
  winrm_password = var.build_password
  winrm_port     = var.communicator_port

  // Template settings
  template_name        = var.common_create_template ? local.template_name : null
  template_description = var.common_create_template ? local.template_description : null
}

build {
  sources = [
    "source.proxmox-iso.windows-desktop-pro",
    "source.proxmox-iso.windows-desktop-ent"
  ]

  provisioner "powershell" {
    environment_vars = [
      "BUILD_USERNAME=${var.build_username}"
    ]
    elevated_user     = var.build_username
    elevated_password = var.build_password
    scripts           = formatlist("${path.cwd}/%s", var.scripts)
  }

  provisioner "powershell" {
    elevated_user     = var.build_username
    elevated_password = var.build_password
    inline            = var.inline
  }

  provisioner "windows-update" {
    pause_before    = "30s"
    search_criteria = "IsInstalled=0"
    filters = [
      "exclude:$_.Title -like '*VMware*'",
      "exclude:$_.Title -like '*Preview*'",
      "exclude:$_.Title -like '*Defender*'",
      "exclude:$_.InstallationBehavior.CanRequestUserInput",
      "include:$true"
    ]
    restart_timeout = "120m"
  }

  post-processor "manifest" {
    output     = local.manifest_output
    strip_path = true
    strip_time = true
    custom_data = {
      ansible_username    = var.ansible_username
      build_username      = var.build_username
      build_version       = local.build_version
      vm_cpu_cores        = !(var.vm_cpu_core_count == null) ? var.vm_cpu_core_count : 2
      vmp_cpu_count       = !(var.vm_cpu_count == null) ? var.vm_cpu_count : 2
      vm_disk_size        = !(var.vm_disk_size == null) ? var.vm_disk_size : "64G"
      vm_guest_os_family  = local.vm_guest_os_family
      vm_guest_os_name    = local.vm_guest_os_name
      vm_guest_os_version = local.vm_guest_os_version
      vm_mem_size         = !(var.vm_mem_size == null) ? var.vm_mem_size : 4096
      vm_nic_model        = var.vm_nic_model
      proxmox_url         = var.proxmox_url
      proxmox_node        = var.proxmox_node
    }
  }
}