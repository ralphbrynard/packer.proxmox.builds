# > Packer Variables File
# > Description: Variable definitions for Packer builds
# > 'proxmox-iso' builder

## > OS Installation Variables
variable "vm_guest_os_name" {
  type    = string
  default = null
}

variable "vm_guest_os_language" {
  type    = string
  default = null
}

variable "vm_guest_os_keyboard" {
  type    = string
  default = null
}

variable "vm_guest_os_family" {
  type    = string
  default = null
}

variable "vm_guest_os_timezone" {
  type    = string
  default = "UTC"
}

variable "vm_guest_os_version" {
  type    = string
  default = null
}

variable "enable_cloud_init" {
  type        = bool
  description = <<EOF
   [Optional]  If true, add an empty Cloud-Init CDROM drive after the virtual machine has been converted to a template. Defaults to `false`.
   EOF
  default     = false
}

variable "cloud_init_storage_pool" {
  type        = string
  description = <<EOF
   [Optional]  Name of the Proxmox storage pool to store the Cloud-Init CDROM on. If not given, the storage pool of the boot device will be used.
   EOF
  default     = null
}

## > HTTP Variables
variable "external_http_ip" {
  type = string
  default = null
}

variable "http_bind_address" {
  type    = string
  default = "0.0.0.0"
}

variable "http_port_min" {
  type    = number
  default = 8000
}

variable "http_port_max" {
  type    = number
  default = 8099
}

## > Common Variables
variable "common_template_conversion" {
  type        = bool
  description = "Convert the virtual machine to template. Must be 'false' for content library."
  default     = false
}

variable "common_ip_wait_timeout" {
  type    = string
  default = "20m"
}

variable "common_remove_cdrom" {
  type    = bool
  default = true
}

variable "common_iso_datastore" {
  type        = string
  description = "[Required] The ISO datastore on the Proxmox host/cluster where ISO files for installation will be used, or uploaded."
}

variable "common_vm_datastore" {
  type        = string
  description = "[Required] The VM disk datastore on the Proxmox host/cluster where the VM disk will be stored."
}

variable "common_data_source" {
  type    = string
  default = "disk"
}

## > Proxmox Credentials
variable "proxmox_endpoint" {
  type        = string
  description = <<EOF
    [Required] The Proxmox server API endpoint URI. 
    EOF
}

variable "proxmox_username" {
  type        = string
  description = <<EOF
    [Required] The username to authenticate to the Proxmox server.
    EOF
}

variable "proxmox_password" {
  type        = string
  description = <<EOF
    [Optional] The password for the user to authenticate to the Proxmox server.
    EOF
  default     = null
  sensitive   = true
}

variable "proxmox_api_token" {
  type        = string
  description = <<EOF
    [Optional] The Proxmox API token to use to authenticate to the Proxmox server.
    EOF
  default     = null
  sensitive   = true
}

# > Proxmox Settings
variable "proxmox_host" {
  type        = string
  description = <<EOF
    [Optional] The virtualization host in which to build the virtual machine.
    EOF
}

variable "proxmox_insecure_tls" {
  type        = bool
  description = "[Optional] Whether Packer should validate the Proxmox host/cluster certificate. Defaults to `false`"
  default     = true
}

variable "enable_proxmox_firewall" {
  type    = bool
  default = false
}

variable "proxmox_resource_pool" {
  type    = string
  default = "packer"
}

## > Virtual Machine Settings
variable "vm_bridge_interface" {
  type    = string
  default = "vmbr0"
}

variable "vm_id" {
  type    = number
  default = null
}

variable "vm_mem_size" {
  type    = number
  default = 1024
}

variable "vm_mem_hot_add" {
  type    = bool
  default = false
}

variable "vm_min_mem_size" {
  type    = number
  default = 1024
}

variable "vm_cpu_cores" {
  type    = number
  default = 1
}

variable "vm_cpu_count" {
  type    = number
  default = 1
}

variable "vm_cpu_type" {
  type    = string
  default = "kvm64"
}

variable "vm_boot_wait" {
  type    = string
  default = "5s"
}

variable "enable_numa" {
  type    = bool
  default = false
}

variable "vm_firmware" {
  type    = string
  default = "seabios"
}

variable "vm_install_tools" {
  type    = bool
  default = true
}

variable "vm_disk_controller_type" {
  type    = string
  default = "virtio-scsi-single"
}

variable "vm_disk_type" {
  type    = string
  default = "scsi"
}

variable "start_on_boot" {
  type    = bool
  default = true
}

variable "disable_hardware_virtualization" {
  type    = bool
  default = false
}

variable "packer_vm_interface" {
  type    = string
  default = null
}

variable "inline" {
  type    = list(string)
  default = []
}

variable "scripts" {
  type    = list(string)
  default = []
}
# > Disk Settings
variable "vm_disk_size" {
  type    = string
  default = null
}

variable "vm_disk_cache_mode" {
  type    = string
  default = "none"
}

variable "vm_disk_format" {
  type    = string
  default = "raw"
}

variable "vm_disk_enable_io_threading" {
  type    = bool
  default = false
}

variable "vm_disk_enable_trim" {
  type    = bool
  default = false
}

variable "vm_disk_enable_ssd" {
  type    = bool
  default = false
}

# > EFI Settings
variable "is_efi" {
  type    = bool
  default = false
}

variable "efi_storage_pool" {
  type    = string
  default = null
}

variable "enable_windows_secure_boot" {
  type    = bool
  default = false
}

variable "efi_type" {
  type    = string
  default = "4m"
}

# > Network Settings
variable "vm_network_card" {
  type    = string
  default = "e1000"
}

variable "vm_nic_mac_address" {
  type    = string
  default = null
}

variable "vm_nic_mtu" {
  type    = number
  default = 0
}

variable "vm_nic_vlan_tag" {
  type    = string
  default = null
}

variable "enable_multi_queue" {
  type    = number
  default = 0
}

# > Removable Media Settings
variable "iso_file" {
  type    = string
  default = null
}

variable "iso_url" {
  type    = string
  default = null
}

variable "iso_storage_pool" {
  type        = string
  description = "[Optional] The Proxmox storage pool to upload the packer.iso file to."
  default     = null
}

variable "iso_checksum" {
  type    = string
  default = null
}

# > Communicator Settings
variable "communicator_host" {
  type        = string
  description = <<EOF
   [Optional] The address for the communicator to connect to.
   EOF
  default     = null
}

variable "communicator_timeout" {
  type        = string
  description = <<EOF
   [Optional] The amount of time to wait for WinRM to become available. This defaults to 30m since setting up a Windows machine generally takes a long time.
   EOF
  default     = null
}

variable "communicator_use_proxy" {
  type    = bool
  default = false
}

variable "build_username" {
  type    = string
  default = "sophos"
}

variable "build_password" {
  type      = string
  default   = ""
  sensitive = true
}

variable "ansible_username" {
  type    = string
  default = "ansible"
}

variable "ansible_password" {
  type      = string
  default   = ""
  sensitive = true
}

# > Additional Settings
variable "additional_packages" {
  type    = list(string)
  default = []
}
