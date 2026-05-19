# Variables pour le module VM
# Bloc 1 : Variables d'entrée
variable "vm_id" {
    description = "VMID unique dans Proxmox (ex: 101)"
    type        = number
}
# Bloc 2 — Le nom de la VM 
variable "name" {
    description = "Nom de la VM dans Proxmox (ex: bastion)"
    type        = string
}
# Bloc 3 — Les vCPU avec une valeur par défaut 
variable "cores" {
    description = "Nombre de vCPU pour la VM"
    type        = number
    default     = 2
}
# Bloc 4 — La RAM 
variable "memory_mb" {
    description = "RAM en MB"
    type        = number
    default     = 2048
}
# Bloc 5 — La taille du disque 
variable "disk_size_gb" {
    description = "Taille du disque en GB"
    type        = number
    default     = 20
}
# Bloc 6 — L'IP statique
variable "ip_address" {
    description = "Adresse IP statique avec masque CIDR (ex: 10.10.1.20/24)"
    type        = string
}
# Bloc 7 — La gateway
variable "gateway" {
    description = "Passerelle par défaut"
    type        = string
    default     = "10.10.1.1"
}
# Bloc 8 — La clé SSH 
variable "ssh_key" {
    description = "Clé SSH publique par cloud-init pour l'accès à la VM"
    type        = string
}
# Bloc 9 — L'utilisateur cloud-init
variable "ci_user" {
    description = "Utilisateur créé par cloud-init (ex: admin)"
    type        = string
    default     = "debian"
}
# Bloc 10 — Le nœud Proxmox
variable "node_name" {
    description = "Nom du nœud Proxmox cible"
    type        = string
    default = "pve"
}
# Bloc 11 — Le template à cloner
variable "template_id" {
    description = "VMID du template à cloner (ex: debian-11-template)"
    type        = number
    default = "9000"
}
# Bloc 12 — Le storage 
variable "datastore" {
    description = "Storage Proxmox pour les disques (ex: local-lvm)"
    type        = string
    default     = "local-lvm"
}
# Bloc 13 — Les tags
variable "tags" {
    description = "Tags Proxmox pour organiser les VMs (ex: ['web', 'production'])"
    type        = list(string)
    default     = []
}
