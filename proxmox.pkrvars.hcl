# > Proxmox Variables
# > Description: Proxmox Variables for Packer Builds.

## > Proxmox Credentials
proxmox_endpoint  = "https://10.1.0.148:8006/api2/json"
proxmox_username  = "packer@pve!packer_api_token"
proxmox_api_token = "46c7eaee-58e5-48c3-8e15-fcc1d8b092b3"

## > Proxmox Settings
proxmox_host = "hades"
proxmox_insecure_tls = true
proxmox_resource_pool = "packer"
enable_proxmox_firewall = false