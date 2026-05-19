# Bloc 1 — L'ID de la VM créée
output "vm_id" {
    description = "VMID de la VM créée dans Proxmox"
    value       = proxmox_virtual_environment_vm.this.vm_id
}
# Bloc 2 — Le nom de la VM
output "name" {
    description = "Nom de la VM"
    value       = proxmox_virtual_environment_vm.this.name
}
# Bloc 3 — L'IP de la VM
output "ip_address" {
    description = "Adresse IP de la VM"
    value       = var.ip_address
}