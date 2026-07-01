# Bloc 1 token proxmox
variable "proxmox_token" {
  description = "Token API Proxmox au format user@realm!token-name=secret"
  type        = string
  sensitive   = true
}
# Bloc 2 clé SSH
variable "ssh_public_key" {
  description = "Clé publique SSH injectée dans les VMs"
  type        = string
}
# Bloc 3 endpoint Proxmox
variable "proxmox_endpoint" {
  description = "URL de l'API Proxmox"
  type        = string
  default     = "https://10.10.1.10:8006/"
}
# Bloc 4 ID du template
variable "template_id" {
  description = "VMID du template debian12-cloudinit"
  type        = number
  default     = 9000
}
# Bloc 5 gateway
variable "gateway" {
  description = "Passerelle par defaut du reseau lab"
  type        = string
  default     = "10.10.1.1"
}