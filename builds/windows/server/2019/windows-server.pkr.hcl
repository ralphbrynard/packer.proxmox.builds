# > Packer Build File
# > Description: Packer Windows Server Build file
# > 'proxmox-iso' builder 

## > Packer Configuration Block
packer {
  required_version = ">= 1.9.4"
  required_plugins {
    windows-update = {
      source  = "github.com/rgl/windows-update"
      version = ">= 0.14.3"
    }
    git = {
      source  = "github.com/ethanmdavidson/git"
      version = ">= 0.4.3"
    }
    proxmox = {
      version = ">= 1.1.3"
      source  = "github.com/hashicorp/proxmox"
    }
    external = {
      version = ">= 0.0.2"
      source  = "github.com/joomcode/external"
    }
    sshkey = {
      version = ">= 1.0.1"
      source  = "github.com/ivoronin/sshkey"
    }
  }
}

## > Data Source Blocks
#data "external-raw" "virtioURL" {
#  program = ["${path.cwd}/utils/virtio.sh", "--virtio-url"]
#}

#data "external-raw" "sha256" {
#  program = ["${path.cwd}/utils/virtio.sh", "--compute-sha256"]
#}

data "sshkey" "build_key" {
  name = var.build_username
}

data "git-repository" "cwd" {}

## > Local Variables
locals {
  #virtio_iso_url    = data.external-raw.virtioURL.result
  #virtio_iso_sha256 = data.external-raw.sha256.result
  vm_name_datacenter_desktop = join(
    ".",
    [
      join("",
        [
          replace("${var.vm_guest_os_family}", "windows", "win"),
          replace("${var.vm_guest_os_name}", "server", "srv"),
          "${var.vm_guest_os_version}"
        ]
      ),
      join("",
        [
          replace("${var.vm_guest_os_edition_datacenter}", "datacenter", "dc"),
          "${var.vm_guest_os_experience_desktop}"
        ]
      )
    ]
  )
  build_by           = "Built by: HashiCorp Packer ${packer.version}"
  build_date         = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
  build_version      = data.git-repository.cwd.head
  build_description  = "Version: ${local.build_version}\nBuilt on: ${local.build_date}\n${local.build_by}"
  iso_file           = "local:iso/en_windows_server_2019_updated_aug_2019_x64_dvd_cdf24600.iso"
  manifest_date      = formatdate("YYYY-MM-DD hh:mm:ss", timestamp())
  manifest_path      = "${path.cwd}/manifests/"
  manifest_output    = "${local.manifest_path}${local.manifest_date}.json"
  ovf_export_path    = "${path.cwd}/artifacts/"
  bucket_name        = replace("${var.vm_guest_os_family}-${var.vm_guest_os_name}-${var.vm_guest_os_version}", ".", "")
  bucket_description = "${var.vm_guest_os_family} ${var.vm_guest_os_name} ${var.vm_guest_os_version}"
}

## > Build block
source "null" "packer-iso" {
  communicator = "none"
}

build {
  name = "drivers"
  source "source.null.packer-iso" {}

  provisioner "shell-local" {
    environment_vars = [
      "PACKER_CACHE_DIR=${path.cwd}/packer_cache"
    ]
    inline = ["${path.cwd}/utils/virtio-drivers.sh ${var.vm_guest_os_version}"]
  }
}

build {
  name = "windows-server-2019-datacenter-desktop"
  source "source.proxmox-iso.datacenter-desktop" {}

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
}
