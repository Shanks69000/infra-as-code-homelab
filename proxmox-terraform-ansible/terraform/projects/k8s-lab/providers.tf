# Ce fichier configure la connexion à Proxmox

# Bloc 1 déclaration du provider requis
terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.78"
    }
  }
}

# Bloc 2 configuration du provider
provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = var.proxmox_token
  insecure  = true
}

