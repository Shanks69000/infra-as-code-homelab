terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.78"
    }
  }
}

provider "proxmox" {
  endpoint  = "https://10.10.1.10:8006/"
  api_token = var.proxmox_token
  insecure  = true
}
