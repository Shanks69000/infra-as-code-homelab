# Ce fichier expose les informations importantes après le terraform apply

output "vm_ips" {
    description = "IPs de toutes les VMs"
    value = {
        for name, vm in module.vms : name => vm.ip_address
    }
}