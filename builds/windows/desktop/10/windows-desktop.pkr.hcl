# > Packer Build File
# > Description: Packer Windows 10 Build file
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
  }
}

## > Data Block
data "git-repository" "cwd" {}

## > Local Variables
locals {
  vm_name_pro = join(
    ".",
    [
      join("",
        [
          replace("${var.vm_guest_os_family}", "windows", "win"),
          "${var.vm_guest_os_version}"
        ]
      ),
      join("",
        [
          "${var.vm_guest_os_edition_pro}"
        ]
      )
    ]
  )
  vm_name_ent = join(
    ".",
    [
      join("",
        [
          replace("${var.vm_guest_os_family}", "windows", "win"),
          "${var.vm_guest_os_version}"
        ]
      ),
      join("",
        [
          "${var.vm_guest_os_edition_ent}"
        ]
      )
    ]
  )
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
}

## > Build block
build {
  name = "windows-10"

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

  post-processor "shell-local" {
    inline = [" rm -f ${path.cwd}/windows_files/drivers/*"]
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
