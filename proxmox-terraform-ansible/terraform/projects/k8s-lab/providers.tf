# Ce fichier configure la connexion à Proxmox
# c'est lui qui dit à Terraform comment parler à l'API.

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

# Explication :
# endpoint — l'URL de l'API Proxmox. On utilise var.proxmox_endpoint qu'on a déclaré dans variables.tf.
# api_token — le token d'authentification. Format user@realm!token-name=secret.
# insecure = true — désactive la vérification du certificat SSL. 
# Nécessaire car Proxmox utilise un certificat auto-signé par défaut. En prod avec un vrai certificat, tu mettrais false.