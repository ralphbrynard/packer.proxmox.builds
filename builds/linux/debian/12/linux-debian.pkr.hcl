# > Packer Build File
# > Description: Packer Debian Linux 12 Build file
# > 'proxmox-iso' builder 

## > Packer Configuration Block
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
      source  = "github.com/ethanmdavidson/git"
      version = ">= 0.4.3"
    }    
    sshkey = {
      version = ">= 1.0.1"
      source  = "github.com/ivoronin/sshkey"
    }
  }
}

## > Data Block
data "git-repository" "cwd" {}

data "sshkey" "build_key" {
  name = var.build_username
}

data "sshkey" "ansible_key" {
  name = var.ansible_username
}

## > Local Variables
locals {
  vm_name = join(
    ".",
    [
      join("",
        [
          "${var.vm_guest_os_name}",
          "${var.vm_guest_os_version}"
        ]
      ),
      join("",
        [
          "${var.vm_guest_os_family}"
        ]
      )
    ]
  )
  ansible_password   = bcrypt(var.ansible_password)
  build_password     = bcrypt(var.build_password)
  build_by           = "Built by: HashiCorp Packer ${packer.version}"
  build_date         = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
  build_version      = data.git-repository.cwd.head
  build_description  = "Version: ${local.build_version}\nBuilt on: ${local.build_date}\n${local.build_by}"
  iso_file           = "local:iso/${var.iso_file}"
  manifest_date      = formatdate("YYYY-MM-DD hh:mm:ss", timestamp())
  manifest_path      = "${path.cwd}/manifests/"
  manifest_output    = "${local.manifest_path}${local.manifest_date}.json"
  ovf_export_path    = "${path.cwd}/artifacts/"
  bucket_name        = replace("${var.vm_guest_os_family}-${var.vm_guest_os_name}-${var.vm_guest_os_version}", ".", "")
  bucket_description = "${var.vm_guest_os_family} ${var.vm_guest_os_name} ${var.vm_guest_os_version}"
  http_bind_address  = var.external_http_ip == null ? var.http_bind_addres : var.external_http_ip
  data_source_content = {
    "/ks.cfg" = templatefile("${abspath(path.root)}/data/ks.pkrtpl.hcl", {
      build_username           = var.build_username
      build_password           = var.build_password
      build_password_encrypted = local.build_password
      build_key                = data.sshkey.build_key.public_key
      vm_guest_os_language     = var.vm_guest_os_language
      vm_guest_os_keyboard     = var.vm_guest_os_keyboard
      vm_guest_os_timezone     = var.vm_guest_os_timezone
      common_data_source       = var.common_data_source
      additional_packages      = join(" ", var.additional_packages)
    })
  }
  data_source_command = var.common_data_source == "http" ? "auto preseed/url=http://${local.http_bind_address}:{{ .HTTPPort }}/ks.cfg" : "file=/media/ks.cfg"
  mount_cdrom_command = "<leftAltOn><f2><leftAltOff> <enter><wait> mount /dev/sr1 /media<enter> <leftAltOn><f1><leftAltOff>"
  mount_cdrom         = var.common_data_source == "http" ? " " : local.mount_cdrom_command
}

## > Build Block
build {
  name    = "debian-12"
  sources = ["source.proxmox-iso.linux-debian"]

  provisioner "file" {
    content = templatefile("${abspath(path.cwd)}/templates/${var.vm_guest_os_family}/cloud.pkrtpl.cfg", {
      ansible_username = var.ansible_username
      ansible_password = local.ansible_password
      ansible_key      = data.sshkey.ansible_key.public_key
      build_username   = var.build_username
      build_password   = local.build_password
      build_key        = data.sshkey.build_key.public_key
    })
    destination = "/tmp/cloud.cfg"
  }

  provisioner "file" {
    source      = "${abspath(path.cwd)}/files/${var.vm_guest_os_family}/99-pve.cfg"
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
      "ANSIBLE_SSH_PRIVATE_KEY_FILE=${data.sshkey.ansible_key.private_key_path}",
      "ANSIBLE_USER=${var.build_username}",
      "ANSIBLE_BECOME_METHOD=sudo",
      "ANSIBLE_BECOME=true",
    ]
    extra_arguments = [
      "--extra-vars", "display_skipped_hosts=false",
      "--extra-vars", "BUILD_USERNAME=${var.build_username}",
      "--extra-vars", "BUILD_KEY='${data.sshkey.build_key.private_key_path}'",
      "--extra-vars", "ANSIBLE_USERNAME=${var.ansible_username}",
      "--extra-vars", "ANSIBLE_KEY='${data.sshkey.ansible_key.private_key_path}'"
    ]
  }

  post-processor "manifest" {
    output     = local.manifest_output
    strip_path = true
    strip_time = true
    custom_data = {
      build_username  = var.build_username
      build_date      = local.build_date
      build_version   = local.build_version
      vm_cpu_cores    = var.vm_cpu_cores
      vm_cpu_count    = var.vm_cpu_count
      vm_disk_size    = var.vm_disk_size
      vm_firmware     = var.vm_firmware
      vm_mem_size     = var.vm_mem_size
      vm_network_card = var.vm_network_card
    }
  }
}