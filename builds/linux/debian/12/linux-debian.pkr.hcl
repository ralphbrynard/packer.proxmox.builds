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
    sshkey = {
      version = ">= 1.0.1"
      source  = "github.com/ivoronin/sshkey"
    }
  }
}

//  BLOCK: data
//  Defines the data sources.

data "sshkey" "install" {
  name = var.build_username
}

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

  http_ip = var.http_ip == null ? "{{ .HTTPIP }}" : var.http_ip

  iso_file             = "debian-12.1.0-amd64-netinst.iso"
  iso_target_path      = "${path.root}"
  iso_target_extension = "iso"
  manifest_date        = formatdate("YYYY-MM-DD hh:mm:ss", timestamp())
  manifest_path        = "${path.cwd}/manifests/"
  manifest_output      = "${local.manifest_path}${local.manifest_date}.json"

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
      build_key                = var.build_key
      temp_build_key           = data.sshkey.install.public_key
      vm_guest_os_language     = var.vm_guest_os_language
      vm_guest_os_keyboard     = var.vm_guest_os_keyboard
      vm_guest_os_timezone     = var.vm_guest_os_timezone
      common_data_source       = var.common_data_source
    })
  }
  data_source_command  = var.common_data_source == "http" ? local.http_ip : "file=/media/preseed.cfg"
  template_name        = local.vm_name
  template_description = local.build_description
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

  // HTTP data
  http_content      = var.common_data_source == "http" ? local.data_source_content : null
  http_port_max     = var.http_port_max
  http_port_min     = var.http_port_min
  http_bind_address = var.http_bind_address
  http_interface    = var.http_interface

  // Cloud init settings
  cloud_init              = var.enable_cloud_init
  cloud_init_storage_pool = var.enable_cloud_init ? var.cloud_init_storage_pool : null

  // Boot settings
  boot_wait = var.boot_wait
  boot_command = [
    "<esc><wait>",
    "auto preseed/url=http://${local.http_ip}:{{ .HTTPPort }}/preseed.cfg",
    "<enter>"
  ]

  // Communicator settings and credentials
  communicator         = "ssh"
  ssh_username         = var.build_username
  ssh_password         = var.build_password
  ssh_private_key_file = data.sshkey.install.private_key_path

  // Template settings
  template_name        = var.common_create_template ? local.template_name : null
  template_description = var.common_create_template ? local.template_description : null
}

build {
  sources = [
    "source.proxmox-iso.linux-debian"
  ]

  provisioner "file" {
    content = templatefile("${abspath(path.root)}/templates/cloud.pkrtpl.cfg", {
      ansible_username = var.ansible_username
      ansible_password = local.ansible_password_encrypted
      ansible_key      = var.ansible_key
      build_username   = var.build_username
      build_password   = local.build_password_encrypted
      build_key        = var.build_key
    })
    destination = "/tmp/cloud.cfg"
  }

  provisioner "file" {
    source = "${path.root}/files/99-pve.cfg"
    destination = "/tmp/99-pve.cfg"
  }

  provisioner "shell" {
    inline = ["sudo cp /tmp/cloud.cfg /etc/cloud/cloud.cfg && sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg"]
  }

  provisioner "ansible" {
    playbook_file = "${path.cwd}/ansible/main.yml"
    roles_path    = "${path.cwd}/ansible/roles"
    ansible_env_vars = [
      "ANSIBLE_CONFIG=${path.cwd}/ansible/ansible.cfg",
      "ANSIBLE_REMOTE_TMP=/tmp/.ansible-${var.build_username}/tmp",
      "ANSIBLE_SSH_PRIVATE_KEY_FILE=${data.sshkey.install.private_key_path}",
      "ANSIBLE_USER=${var.build_username}",
      "ANSIBLE_BECOME_METHOD=sudo",
      "ANSIBLE_BECOME=true",
    ]
    extra_arguments = [
      "--extra-vars", "display_skipped_hosts=false",
      "--extra-vars", "BUILD_USERNAME=${var.build_username}",
      "--extra-vars", "BUILD_SECRET='${data.sshkey.install.private_key_path}'",
      "--extra-vars", "ANSIBLE_USERNAME=${var.ansible_username}",
      "--extra-vars", "ANSIBLE_SECRET='${var.ansible_key}'"
    ]
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
      vm_guest_os_family  = local.vm_guest_os_family
      vm_guest_os_name    = local.vm_guest_os_name
      vm_guest_os_version = local.vm_guest_os_version
      vm_mem_size         = var.vm_mem_size
      vm_nic_model        = var.vm_nic_model
      proxmox_url         = var.proxmox_url
      proxmox_node        = var.proxmox_node
    }
  }
}