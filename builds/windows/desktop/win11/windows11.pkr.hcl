/*
    DESCRIPTION:
    Microsoft Windows 11 build definition.
    Packer Plugin for Proxmox (`proxmox-iso` builder).
*/
/*
    DESCRIPTION:
    Proxmox Variables
    Packer Plugin for Proxmox (`proxmox-iso` builder).
*/

variable "proxmox_api_endpoint" {
  type        = string
  description = <<EOF
   [Required] The proxmox server URL. EG: https://<proxmox>:8006/api2/json
   EOF
}

variable "proxmox_username" {
  type        = string
  description = <<EOF
   [Required] Username when authenticating to Proxmox, including the realm. For example `user@pve` to use the local Proxmox realm. When using token authentication, the username must include the token id after an exclamation mark. For example, `user@pve!tokenid`. Can also be set via the `PROXMOX_USERNAME` environment variable.
   EOF
}

variable "proxmox_password" {
  type        = string
  description = <<EOF
   [Optional]  Password for the user. For API tokens please use `token`. Can also be set via the PROXMOX_PASSWORD environment variable. Either `password` or `token` must be specifed. If both are set, `token` takes precedence.
   EOF
  default     = null
  sensitive   = true
}

variable "proxmox_api_token" {
  type        = string
  description = <<EOF
   [Optional] Token for authenticating API calls. This allows the API client to work with API tokens instead of user passwords. Can also be set via the PROXMOX_TOKEN environment variable. Either `password` or `token` must be specifed. If both are set, `token` takes precedence.
   EOF
  default     = null
  sensitive   = true
}

variable "proxmox_node" {
  type        = string
  description = <<EOF
   [Optional]  Which node in the Proxmox cluster to start the virtual machine on during creation.
   EOF
  default     = null
}

variable "proxmox_resource_pool" {
  type        = string
  description = <<EOF
   [Optional] Name of resource pool to create virtual machine in.
   EOF
  default     = null
}

variable "proxmox_task_timeout" {
  type        = string
  description = <<EOF
   [Optional] (duration string | ex: "1h5m2s") - task_timeout (duration string | ex: "10m") - The timeout for Promox API operations, e.g. clones. Defaults to 1 minute.
   EOF
  default     = null
}

variable "proxmox_bridge_interface" {
  type        = string
  description = <<EOF
   [Optional] The bridge network adapter name to use for the virtual machine network adapter configuration.
   EOF
  default     = null
}

variable "proxmox_insecure_connection" {
  type        = bool
  description = <<EOF
   [Optional] If set to true, the Packer provider will ignore HTTPS certificate validation.
   EOF
  default     = true
}

/*
    DESCRIPTION:
    Common Variables
    Packer Plugin for Proxmox (`proxmox-iso` builder).
*/

variable "build_version" {
  type        = string
  description = <<EOF
   [Optional] The version of the build.
   EOF
  default     = null
}

variable "build_username" {
  type        = string
  description = <<EOF
   [Required] The username for the build user. This is also used to access the virtual machine through most provisioners, unless Ansible provisioners are defined.
   EOF
}

variable "build_password" {
  type        = string
  description = <<EOF
   [Required] The password for the build user.
   EOF
  sensitive   = true
}

variable "ansible_username" {
  type        = string
  description = <<EOF
   [Optional] The username for the Ansible user.
   EOF
  default     = null
}

variable "ansible_password" {
  type        = string
  description = <<EOF
   [Optional] The password for the Ansible user.
   EOF
  default     = null
  sensitive   = true
}

// Template Settings
variable "create_template" {
  type        = bool
  description = <<EOF
   [Optional] If set to true, the Packer builder will create a template from the virtual machine.
   EOF
  default     = false
}

// WinRM Communicator Variables

variable "communicator_winrm_port" {
  type        = number
  description = <<EOF
   [Optional] The port to use for the WinRM communicator. Default is 5985.
   EOF
  default     = 5985
}

variable "communicator_winrm_use_ssl" {
  type        = bool
  description = <<EOF
   [Optional] If true, use HTTPS for WinRM.
   EOF
  default     = false
}

variable "communicator_winrm_insecure" {
  type        = bool
  description = <<EOF
   [Optional]  If true, do not check server certificate chain and host name.
   EOF
  default     = true
}

variable "communicator_winrm_use_ntlm" {
  type        = bool
  description = <<EOF
   [Optional] If true, NTLMv2 authentication (with session security) will be used for WinRM, rather than default (basic authentication), removing the requirement for basic authentication to be enabled within the target guest.
   EOF
  default     = false
}

// Common Communicator Variables

variable "communicator_use_proxy" {
  type        = bool
  description = <<EOF
   [Optional] SSetting this to true adds the remote host:port to the NO_PROXY environment variable. This has the effect of bypassing any configured proxies when connecting to the remote host. Default to false.
   EOF
  default     = false
}

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

/*
    DESCRIPTION:
    Virtual Machine Variables
    Packer Plugin for Proxmox (`proxmox-iso` builder).
*/

variable "vm_name" {
  type        = string
  description = <<EOF
   [Optional] Name of the virtual machine during creation. If not given, a random uuid will be used.
   EOF
  default     = null
}

variable "vm_id" {
  type        = number
  description = <<EOF
   [Optional] The ID used to reference the virtual machine. This will also be the ID of the final template. Proxmox VMIDs are unique cluster-wide and are limited to the range 100-999999999. If not given, the next free ID on the cluster will be used.
   EOF
  default     = null
}

variable "vm_mem_size" {
  type        = number
  description = <<EOF
   [Optional] How much memory (in megabytes) to give the virtual machine. If `ballooning_minimum` is also set, memory defines the maximum amount of memory the VM will be able to use. Defaults to `512`.
   EOF
  default     = null
}

variable "vm_min_mem_size" {
  type        = number
  description = <<EOF
   [Optional] Setting this option enables KVM memory ballooning and defines the minimum amount of memory (in megabytes) the VM will have. Defaults to 0 (memory ballooning disabled).
   EOF
  default     = 0
}

variable "vm_cpu_core_count" {
  type        = number
  description = <<EOF
   [Optional] How many CPU cores to give the virtual machine. Defaults to `1`.
   EOF
  default     = null
}

variable "vm_cpu_count" {
  type        = number
  description = <<EOF
   [Optional] How many CPU sockets to give the virtual machine. Defaults to `1`.
   EOF
  default     = null
}

variable "vm_cpu_type" {
  type        = string
  description = <<EOF
   [Optional] The CPU type to emulate. See the Proxmox API documentation for the complete list of accepted values. For best performance, set this to host. Defaults to kvm64.
   EOF
  default     = null
}

variable "vm_os" {
  type        = string
  description = <<EOF
   [Optional] The operating system. Can be `wxp`, `w2k`, `w2k3`, `w2k8`, `wvista`, `win7`, `win8`, `win10`, `l24` (Linux 2.4), `l26` (Linux 2.6+), `solaris` or `other`. Defaults to `other`.
   EOF
  default     = null
}

variable "vm_firmware" {
  type        = string
  description = <<EOF
   [Optional] Set the machine bios. This can be set to `ovmf` or `seabios`. The default value is `seabios`.
   EOF
  default     = null
}

variable "vm_scsi_controller" {
  type        = string
  description = <<EOF
   [Optional] The SCSI controller model to emulate. Can be `lsi`, `lsi53c810`, `virtio-scsi-pci`, `virtio-scsi-single`, `megasas`, or `pvscsi`. Defaults to `lsi`.
   EOF
  default     = null
}

variable "enable_start_on_boot" {
  type        = bool
  description = <<EOF
   [Optional] Specifies whether a VM will be started during system bootup. Defaults to false.
   EOF
  default     = false
}

variable "enable_hardware_virtualization" {
  type        = bool
  description = <<EOF
   [Optional] Disables KVM hardware virtualization. Defaults to false.
   EOF
  default     = false
}

variable "vm_packer_interface" {
  type        = string
  description = <<EOF
   [Optional] Name of the network interface that Packer gets the VMs IP from. Defaults to the first non loopback interface.
   EOF
  default     = null
}

variable "vm_guest_os_family" {
  type        = string
  description = <<EOF
   [Optional] The virtual machine OS family.
   EOF
  default     = "windows"
}

variable "vm_guest_os_language" {
  type        = string
  description = <<EOF
   [Optional] The guest operating system language.
   EOF
  default     = "en-US"
}

variable "vm_guest_os_keyboard" {
  type        = string
  description = <<EOF
   [Optional] The guest operating system keyboard input.
   EOF
  default     = "en-US"
}

variable "vm_guest_os_timezone" {
  type        = string
  description = <<EOF
   [Optional] The guest operating system timezone.
   EOF
  default     = "UTC"
}
variable "vm_disk_type" {
  type        = string
  description = <<EOF
   [Optional]  The type of disk. Can be scsi, sata, virtio or ide. Defaults to scsi.
   EOF
  default     = "scsi"
}

variable "vm_disk_storage_pool" {
  type        = string
  description = <<EOF
   [Required] Name of the Proxmox storage pool to store the virtual machine disk on. A local-lvm pool is allocated by the installer, for example.
   EOF
}

variable "vm_disk_cache_mode" {
  type        = string
  description = <<EOF
   [Optional]  How to cache operations to the disk. Can be none, writethrough, writeback, unsafe or directsync. Defaults to none.
   EOF
  default     = "none"
}

variable "vm_disk_format" {
  type        = string
  description = <<EOF
   [Optional] The format of the file backing the disk. Can be raw, cow, qcow, qed, qcow2, vmdk or cloop. Defaults to raw.
   EOF
  default     = "raw"
}

variable "vm_disk_enable_io_threading" {
  type        = bool
  description = <<EOF
   [Optional] Create one I/O thread per storage controller, rather than a single thread for all I/O. This can increase performance when multiple disks are used. Requires virtio-scsi-single controller and a scsi or virtio disk. Defaults to false.
   EOF   
  default     = false
}

variable "vm_disk_enable_trimming" {
  type        = bool
  description = <<EOF
   [Optional] Relay TRIM commands to the underlying storage. Defaults to false.
   EOF
  default     = false
}

variable "vm_disk_enable_ssd" {
  type        = bool
  description = <<EOF
   [Optional] Drive will be presented to the guest as solid-state drive rather than a rotational disk.
   EOF
  default     = true
}

variable "vm_disk_size" {
  type        = string
  description = <<EOF
   [Optional] The size of the disk, including a unit suffix, such as 10G to indicate 10 gigabytes.
   EOF
  default     = "64G"
}

variable "vm_storage_pool" {
  type        = string
  description = <<EOF
   [Optional] Specifies the Proxmox storage pool where to store the VM. This can be defined globally, or in each vm_disk_config.disk_storage_pool configuration.
   EOF
  default     = null
}

variable "enable_kvm_ballooning" {
  type        = bool
  description = <<EOF
   [Optional] If memory ballooning should be enabled in the VM.
   EOF
  default     = false
}

variable "enable_qemu_agent" {
  type        = bool
  description = <<EOF
   [Optional] Whether the Qemu Agent should be enabled in the VM.
   EOF
  default     = true
}

variable "vm_efi_storage_pool" {
  type        = string
  description = <<EOF
   [Optional] Name of the Proxmox storage pool to store the EFI disk on.
   EOF
  default     = null
}

variable "vm_efi_pre_enrolled_keys" {
  type        = bool
  description = <<EOF
   [Optional] Whether Microsoft Standard Secure Boot keys should be pre-loaded on the EFI disk. Defaults to false.
   EOF
  default     = false
}

variable "vm_efi_type" {
  type        = string
  description = <<EOF
   [Optional]  Specifies the version of the OVMF firmware to be used. Can be 2m or 4m. Defaults to 4m.
   EOF
  default     = null
}

variable "enable_efi_config" {
  type        = bool
  description = <<EOF
   [Optional] If set to `true`, `vm_efi_config` must be defined.
   EOF
  default     = false
}

variable "vm_nic_model" {
  type        = string
  description = <<EOF
   [Optional] Model of the virtual network adapter. Can be rtl8139, ne2k_pci, e1000, pcnet, virtio, ne2k_isa, i82551, i82557b, i82559er, vmxnet3, e1000-82540em, e1000-82544gc or e1000-82545em. Defaults to e1000.
   EOF
  default     = "e1000"
}

variable "vm_nic_no_packet_queues" {
  type        = number
  description = <<EOF
   [Optional] Number of packet queues to be used on the device. Values greater than 1 indicate that the multiqueue feature is activated. For best performance, set this to the number of cores available to the virtual machine. CPU load on the host and guest systems will increase as the traffic increases, so activate this option only when the VM has to handle a great number of incoming connections, such as when the VM is operating as a router, reverse proxy or a busy HTTP server. Requires virtio network adapter. Defaults to 0.
   EOF
  default     = 0
}

variable "vm_nic_mac_address" {
  type        = string
  description = <<EOF
   [Optional] Give the adapter a specific MAC address. If not set, defaults to a random MAC. If value is "repeatable", value of MAC address is deterministic based on VM ID and NIC ID.
   EOF
  default     = null
}

variable "vm_nic_mtu" {
  type        = number
  description = <<EOF
   [Optional] Set the maximum transmission unit for the adapter. Valid range: 0 - 65520. If set to 1, the MTU is inherited from the bridge the adapter is attached to. Defaults to 0 (use Proxmox default).
   EOF
  default     = 0
}

variable "vm_nic_vlan_tag" {
  type        = string
  description = <<EOF
   [Optional] If the adapter should tag packets. Defaults to no tagging.
   EOF
  default     = null
}

variable "vm_nic_enable_proxmox_firewall" {
  type        = bool
  description = <<EOF
   [Optional] If the interface should be protected by the firewall. Defaults to false.
   EOF
  default     = false
}

variable "vm_inst_os_kms_key_ent" {
  type        = string
  description = <<EOF
   [Optional] The installation operating system KMS key input.
   EOF
  default     = null
}

variable "vm_inst_os_kms_key_pro" {
  type        = string
  description = <<EOF
   [Optional] The installation operating system KMS key input.
   EOF
  default     = null
}

variable "vm_inst_os_image_ent" {
  type        = string
  description = <<EOF
   [Optional] The guest operating system edition. Used for naming.
   EOF
  default     = null
}

variable "vm_inst_os_image_pro" {
  type        = string
  description = <<EOF
   [Optional] The guest operating system edition. Used for naming.
   EOF
  default     = null
}

variable "enable_numa_support" {
  type        = bool
  description = <<EOF
   [Optional] If true, support for non-uniform memory access (NUMA) is enabled. Defaults to false.
   EOF
  default     = false
}

// Provisioner Variables
variable "scripts" {
  type        = list(string)
  description = <<EOF
  [Optional] A list of scripts and their relative paths to transfer and run.
  EOF
  default     = []
}

variable "inline" {
  type        = list(string)
  description = <<EOF
  [Optional] A list of commands to run.
  EOF
  default     = []
}

// Removable Media Settings
variable "download_iso" {
  type        = bool
  description = <<EOF
   [Optional] If this value is set to `true` one of `iso_url` or `iso_urls` must be defined. Conflicts with `iso_file`.
   EOF
  default     = false
}

variable "iso_file" {
  type        = string
  description = <<EOF
   [Optional]  Path to the ISO file to boot from, expressed as a proxmox datastore path, for example `local:iso/Fedora-Server-dvd-x86_64-29-1.2.iso`. Either `iso_file` OR `iso_url` must be specifed.
   EOF
  default     = null
}

variable "iso_url" {
  type        = string
  description = <<EOF
   [Optional]  A URL to the ISO containing the installation image or virtual hard drive (VHD or VHDX) file to clone.
   EOF
  default     = null
}

variable "iso_urls" {
  type        = list(string)
  description = <<EOF
   [Optional] Multiple URLs for the ISO to download. Packer will try these in order. If anything goes wrong attempting to download or while downloading a single URL, it will move on to the next. All URLs must point to the same file (same checksum). By default this is empty and `iso_url` is used. Only one of `iso_url` or `iso_urls` can be specified.
   EOF
  default     = []
}

variable "iso_checksum" {
  type        = string
  description = <<EOF
   [Optional] The checksum for the ISO file or virtual hard drive file. The type of the checksum is specified within the checksum field as a prefix, ex: "md5:{$checksum}". The type of the checksum can also be omitted and Packer will try to infer it based on string length. Valid values are "none", "{$checksum}", "md5:{$checksum}", "sha1:{$checksum}", "sha256:{$checksum}", "sha512:{$checksum}" or "file:{$path}".

   Examples:
      md5:090992ba9fd140077b0661cb75f7ce13
      ba9fd140077b0661cb75f7ce13
      sha1:ebfb681885ddf1234c18094a45bbeafd91467911
      ebfb681885ddf1234c18094a45bbeafd91467911
      sha256:ed363350696a726b7932db864dda019bd2017365c9e299627830f06954643f93
      ed363350696a726b7932db864dda019bd2017365c9e299627830f06954643f93
      file:http://releases.ubuntu.com/20.04/SHA256SUMS
      file:file://./local/path/file.sum
      file:./local/path/file.sum
   EOF
  default     = null
}

variable "unmount_iso" {
  type        = bool
  description = <<EOF
   [Optional]  If `true`, remove the mounted ISO from the template after finishing. Defaults to `true`.
   EOF
  default     = true
}

variable "mount_additional_iso" {
  type        = bool
  description = <<EOF
   [Optional] If set to `true`, additional iso files can be mounted to the virtual machine.
   EOF
  default     = false
}

variable "additional_iso_file" {
  type        = string
  description = <<EOF
   [Optional] Path to the ISO file to boot from, expressed as a proxmox datastore path, for example local:iso/Fedora-Server-dvd-x86_64-29-1.2.iso. Either iso_file OR iso_url must be specifed.
   EOF
  default     = null
}

variable "additional_iso_url" {
  type        = string
  description = <<EOF
   [Optional] A URL to the ISO containing the installation image or virtual hard drive (VHD or VHDX) file to clone.
   EOF
  default     = null
}

variable "additional_iso_urls" {
  type        = list(string)
  description = <<EOF
   [Optional] Multiple URLs for the ISO to download. Packer will try these in order. If anything goes wrong attempting to download or while downloading a single URL, it will move on to the next. All URLs must point to the same file (same checksum). By default this is empty and `iso_url` is used. Only one of `iso_url` or `iso_urls` can be specified.   
   EOF
  default     = []
}

variable "additional_iso_target_path" {
  type        = string
  description = <<EOF
   [Optional] The path where the iso should be saved after download. By default will go in the packer cache, with a hash of the original filename and checksum as its name.
   EOF
  default     = null
}

variable "additional_iso_target_extension" {
  type        = string
  description = <<EOF
   [Optional] The extension of the iso file after download. This defaults to iso.
   EOF
  default     = null
}

variable "additional_iso_checksum" {
  type        = string
  description = <<EOF
   [Optional] The checksum for the ISO file or virtual hard drive file. The type of the checksum is specified within the checksum field as a prefix, ex: "md5:{$checksum}". The type of the checksum can also be omitted and Packer will try to infer it based on string length. Valid values are "none", "{$checksum}", "md5:{$checksum}", "sha1:{$checksum}", "sha256:{$checksum}", "sha512:{$checksum}" or "file:{$path}".

   Examples:
      md5:090992ba9fd140077b0661cb75f7ce13
      ba9fd140077b0661cb75f7ce13
      sha1:ebfb681885ddf1234c18094a45bbeafd91467911
      ebfb681885ddf1234c18094a45bbeafd91467911
      sha256:ed363350696a726b7932db864dda019bd2017365c9e299627830f06954643f93
      ed363350696a726b7932db864dda019bd2017365c9e299627830f06954643f93
      file:http://releases.ubuntu.com/20.04/SHA256SUMS
      file:file://./local/path/file.sum
      file:./local/path/file.sum
   EOF
  default     = null
}

variable "additional_iso_storage_pool" {
  type        = string
  description = <<EOF
   [Optional] Proxmox storage pool onto which to upload the ISO file.
   EOF
  default     = null
}

variable "additional_iso_device" {
  type        = string
  description = <<EOF
   [Optional] Bus type and bus index that the ISO will be mounted on. Can be `ideX`, `sataX` or `scsiX`. For ide the bus index ranges from `0` to `3`, for sata from `0` to `5` and for scsi from `0` to `30`. Defaults to `ide3` since `ide2` is generally the boot drive.
   EOF
  default     = null
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

variable "vm_boot_wait" {
  type        = string
  description = <<EOF
   [Optional] (duration string | ex: "1h5m2s") - The time to wait after booting the initial virtual machine before typing the boot_command. The value of this should be a duration. Examples are 5s and 1m30s which will cause Packer to wait five seconds and one minute 30 seconds, respectively. If this isn't specified, the default is 10s or 10 seconds. To set boot_wait to 0s, use a negative number, such as "-1s"
   EOF
  default     = null
}

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

  manifest_date   = formatdate("YYYY-MM-DD hh:mm:ss", timestamp())
  manifest_path   = "${path.cwd}/manifests/"
  manifest_output = "${local.manifest_path}${local.manifest_date}.json"

}

//  BLOCK: source
//  Defines the builder configuration blocks.
source "proxmox-iso" "windows-desktop-ent" {
  // Proxmox Credentials
  proxmox_url              = var.proxmox_api_endpoint
  username                 = var.proxmox_username
  password                 = var.proxmox_password
  token                    = var.proxmox_api_token
  insecure_skip_tls_verify = var.proxmox_insecure_connection

  // Proxmox settings
  node         = var.proxmox_node
  pool         = var.proxmox_resource_pool
  task_timeout = var.proxmox_task_timeout

  // Virtual Machine Settings
  vm_name            = "windows11.ent"
  vm_id              = var.vm_id
  memory             = var.vm_mem_size
  ballooning_minimum = var.enable_kvm_ballooning ? var.vm_min_mem_size : null
  cores              = var.vm_cpu_core_count
  sockets            = var.vm_cpu_count
  cpu_type           = var.vm_cpu_type
  numa               = var.enable_numa_support
  os                 = var.vm_os
  bios               = var.vm_firmware
  qemu_agent         = var.enable_qemu_agent
  scsi_controller    = var.vm_scsi_controller
  onboot             = var.enable_start_on_boot
  disable_kvm        = var.enable_hardware_virtualization
  vm_interface       = var.vm_packer_interface

  disks {
    type         = var.vm_disk_type
    storage_pool = var.vm_disk_storage_pool
    disk_size    = var.vm_disk_size
    cache_mode   = var.vm_disk_cache_mode
    format       = var.vm_disk_format
    io_thread    = var.vm_disk_enable_io_threading
    discard      = var.vm_disk_enable_trimming
    ssd          = var.vm_disk_enable_ssd
  }

  efi_config {
    efi_storage_pool  = var.enable_efi_config ? var.efi_storage_pool : null
    pre_enrolled_keys = var.enable_efi_config ? var.efi_pre_enrolled_keys : null
    efi_type          = var.enable_efi_config ? var.efi_type : null
  }

  network_adapters {
    model         = var.vm_nic_model
    packet_queues = var.vm_nic_no_packet_queues
    mac_address   = var.vm_nic_mac_address
    mtu           = var.vm_nic_mtu
    bridge        = var.proxmox_bridge_interface
    vlan_tag      = var.vm_nic_vlan_tag
    firewall      = var.vm_nic_enable_proxmox_firewall
  }

  // Removeable Media Settings
  iso_file         = var.download_iso ? null : var.iso_file
  iso_url          = var.download_iso ? var.iso_url : null
  iso_urls         = (var.download_iso == true && var.iso_url == null) ? var.iso_urls : null
  iso_checksum     = var.download_iso ? var.iso_checksum : null
  iso_download_pve = var.download_iso ? true : false
  unmount_iso      = var.unmount_iso
  additional_iso_files {
    unmount              = var.mount_additional_iso ? true : false
    iso_file             = !(var.additional_iso_file == null) ? var.additional_iso_file : null
    iso_url              = !(var.additional_iso_url == null) ? var.additional_iso_url : null
    iso_urls             = !(var.additional_iso_urls == null) ? var.additional_iso_urls : null
    iso_target_path      = !(var.additional_iso_target_path == null) ? var.additional_iso_target_path : null
    iso_target_extension = !(var.additional_iso_target_extension == null) ? var.additional_iso_target_extension : null
    iso_checksum         = var.additional_iso_checksum
    iso_storage_pool     = var.additional_iso_storage_pool
    device               = var.additional_iso_device
    cd_files             = ["${path.cwd}/scripts/${var.vm_guest_os_family}", "${path.cwd}/drivers/"]
    cd_content = {
      "autounattend.xml" = templatefile("${abspath(path.root)}/data/autounattend.pkrtpl.hcl", {
        build_username       = var.build_username
        build_password       = var.build_password
        ansible_username     = var.ansible_username
        ansible_password     = var.ansible_password
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
  template_name        = var.create_template ? "${var.vm_name}ent" : null
  template_description = var.create_template ? local.build_description : null
}

source "proxmox-iso" "windows-desktop-pro" {
  // Proxmox Credentials
  proxmox_url              = var.proxmox_api_endpoint
  username                 = var.proxmox_username
  password                 = var.proxmox_password
  token                    = var.proxmox_api_token
  insecure_skip_tls_verify = var.proxmox_insecure_connection

  // Proxmox settings
  node         = var.proxmox_node
  pool         = var.proxmox_resource_pool
  task_timeout = var.proxmox_task_timeout

  // Virtual Machine Settings
  vm_name            = "windows11.pro"
  vm_id              = var.vm_id
  memory             = var.vm_mem_size
  ballooning_minimum = var.enable_kvm_ballooning ? var.vm_min_mem_size : null
  cores              = var.vm_cpu_core_count
  sockets            = var.vm_cpu_count
  cpu_type           = var.vm_cpu_type
  numa               = var.enable_numa_support
  os                 = var.vm_os
  bios               = var.vm_firmware
  qemu_agent         = var.enable_qemu_agent
  scsi_controller    = var.vm_scsi_controller
  onboot             = var.enable_start_on_boot
  disable_kvm        = var.enable_hardware_virtualization
  vm_interface       = var.vm_packer_interface

  disks {
    type         = var.vm_disk_type
    storage_pool = var.vm_disk_storage_pool
    disk_size    = var.vm_disk_size
    cache_mode   = var.vm_disk_cache_mode
    format       = var.vm_disk_format
    io_thread    = var.vm_disk_enable_io_threading
    discard      = var.vm_disk_enable_trimming
    ssd          = var.vm_disk_enable_ssd
  }

  efi_config {
    efi_storage_pool  = var.enable_efi_config ? var.efi_storage_pool : null
    pre_enrolled_keys = var.enable_efi_config ? var.efi_pre_enrolled_keys : null
    efi_type          = var.enable_efi_config ? var.efi_type : null
  }

  network_adapters {
    model         = var.vm_nic_model
    packet_queues = var.vm_nic_no_packet_queues
    mac_address   = var.vm_nic_mac_address
    mtu           = var.vm_nic_mtu
    bridge        = var.proxmox_bridge_interface
    vlan_tag      = var.vm_nic_vlan_tag
    firewall      = var.vm_nic_enable_proxmox_firewall
  }

  // Removeable Media Settings
  iso_file         = var.download_iso ? null : var.iso_file
  iso_url          = var.download_iso ? var.iso_url : null
  iso_urls         = (var.download_iso == true && var.iso_url == null) ? var.iso_urls : null
  iso_checksum     = var.download_iso ? var.iso_checksum : null
  iso_download_pve = var.download_iso ? true : false
  unmount_iso      = var.unmount_iso
  additional_iso_files {
    unmount              = var.mount_additional_iso ? true : false
    iso_file             = !(var.additional_iso_file == null) ? var.additional_iso_file : null
    iso_url              = !(var.additional_iso_url == null) ? var.additional_iso_url : null
    iso_urls             = !(var.additional_iso_urls == null) ? var.additional_iso_urls : null
    iso_target_path      = !(var.additional_iso_target_path == null) ? var.additional_iso_target_path : null
    iso_target_extension = !(var.additional_iso_target_extension == null) ? var.additional_iso_target_extension : null
    iso_checksum         = var.additional_iso_checksum
    iso_storage_pool     = var.additional_iso_storage_pool
    device               = var.additional_iso_device
    cd_files             = ["${path.cwd}/scripts/${var.vm_guest_os_family}","${path.cwd}/drivers/"]
    cd_content = {
      "autounattend.xml" = templatefile("${abspath(path.root)}/data/autounattend.pkrtpl.hcl", {
        build_username       = var.build_username
        build_password       = var.build_password
        ansible_username     = var.ansible_username
        ansible_password     = var.ansible_password
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
  template_name        = var.create_template ? "${var.vm_name}pro" : null
  template_description = var.create_template ? local.build_description : null
}

// Build block
build {
  sources = [
    "source.proxmox-iso.windows-desktop-pro",
    "source.proxmox-iso.windows-desktop-ent"
  ]

  provisioner "powershell" {
    environment_vars = [
      "BUILD_USERNAME=${var.build_username}",
      "OSVERSION=w11"
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
      vm_cpu_cores        = var.vm_cpu_core_count
      vmp_cpu_count       = var.vm_cpu_count
      vm_disk_size        = var.vm_disk_size
      vm_guest_os_family  = var.vm_guest_os_family
      vm_mem_size         = var.vm_mem_size
      vm_nic_model        = var.vm_nic_model
      proxmox_url         = var.proxmox_api_endpoint
      proxmox_node        = var.proxmox_node
    }
  }
}