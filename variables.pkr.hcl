/*
    DESCRIPTION:
    Debian 12 (Bookworm) input variables.
    Packer Plugin for Proxmox (`proxmox-iso` builder).
*/

//  BLOCK: variable
//  Defines the input variables.

// Proxmox Credentials
variable "proxmox_url" {
  type        = string
  description = "The URL to the Proxmox API endpoint."
  default     = null
}

variable "proxmox_username" {
  type        = string
  description = "The username to login to the Proxmox datacenter"
  default     = null
  sensitive   = true
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
  sensitive   = true
}

variable "proxmox_api_token_id" {
  type        = string
  description = "If a Proxmox API token is being used for authentication, the token ID must be provided."
  default     = null
  sensitive   = true
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
  default     = null
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

// Virtual machine settings
variable "vm_name" {
  type        = string
  description = "The name of the VM"
  default     = null
}

variable "vm_guest_os_language" {
  type        = string
  description = "The language to be used for the operating system."
  default     = "en_US"
}

variable "vm_guest_os_keyboard" {
  type        = string
  description = "The keyboard layout to use for the VM."
  default     = "us"
}

variable "vm_guest_os_timezone" {
  type        = string
  description = "The timezone to use for the VM."
  default     = "UTC"
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
  default     = 1
}

variable "vm_cpu_count" {
  type        = number
  description = "The number of vCPU's to assign to the VM."
  default     = 1
}

variable "vm_os" {
  type        = string
  description = "The VM operating system. Can be; `wxp`. `w2k`, `w2k3`, `w2k8`, `wvista`, `win7`, `win8`, `win10`, `l24`, `l26`, `solaris`, or `other`."
  default     = "l26"
  validation {
    condition     = contains(["wxp", "w2k", "w2k3", "w2k8", "wvista", "win7", "win8", "win10", "l24", "l26", "solaris", "other"], var.vm_os)
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
  default     = "local-lvm"
}

variable "vm_disk_size" {
  type        = string
  description = "The size of the disk, including a unit suffix, such as 10G to indicate 10 gigabytes."
  default     = "32G"
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
  default     = "lsi"
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

variable "vm_interface" {
  type        = string
  description = " Name of the network interface that Packer gets the VMs IP from. Defaults to the first non loopback interface."
  default     = null
}

variable "vm_unmount_iso" {
  type        = bool
  description = "If true, remove the mounted ISO from the template after finishing. Defaults to false."
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
  default     = "cidata"
}

variable "iso_storage_pool" {
  type        = string
  description = "The storage pool to upload the attached iso file to."
  default     = "local"
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
  default     = "5s"
}

// Communicator settings
variable "build_username" {
  type        = string
  description = "The username to use for the build."
  default     = "packer"
}

variable "build_password" {
  type        = string
  description = "The password to use for the build."
  default     = "packer"
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
  default     = "ansible"
}

variable "ansible_password" {
  type        = string
  description = "The Ansible provisioner password."
  default     = "ansible"
  sensitive   = true
}

variable "ansible_key" {
  type        = string
  description = "The SSH Public Key to use for the Ansible provisioner."
  default     = null
  sensitive   = true
}

variable "root_password" {
  type        = string
  description = "The password to use for the root user."
  default     = null
  sensitive   = true
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
  default     = "http"
}