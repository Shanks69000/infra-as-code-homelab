# Ce fichier expose les informations importantes après le terraform apply
# Terraform les affiche dans le terminal à la fin.

# output "bastion_ip" {
#   description = "IP du bastion"
#   value       = module.bastion.ip_address
# }

# output "k8s_master_ip" {
#   description = "IP du master K8s"
#   value       = module.k8s_master.ip_address
# }

# output "k8s_worker1_ip" {
#   description = "IP du worker 1"
#   value       = module.k8s_worker1.ip_address
# }

# output "k8s_worker2_ip" {
#   description = "IP du worker 2"
#   value       = module.k8s_worker2.ip_address
# }

# output "k8s_db_server_ip" {
#   description = "IP du serveur de base de données"
#   value       = module.db_server.ip_address
# }

# Explication de la syntaxe module.bastion.ip_address :
# module — mot-clé qui dit qu'on référence un module.
# bastion — le nom local qu'on a donné au module dans main.tf (module "bastion").
# ip_address — l'output qu'on a déclaré dans modules/vm/outputs.tf.
# C'est la chaîne complète : le projet appelle le module → 
#                             le module crée la VM → 
#                             le module retourne des outputs → 
#                             le projet expose ces outputs à l'utilisateur.

output "vm_ips" {
    description = "IPs de toutes les VMs"
    value = {
        for name, vm in module.vms : name => vm.ip_address
    }
}