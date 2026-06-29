# C'est ici qu'on appelle le module qu'on a créé et qu'on définit 
# les VMs concrètes du projet. 
# C'est le fichier qui ressemble le plus à un playbook Ansible.
# locals {
#   common_gateway    = "10.10.1.1"
#   common_template   = 9000
# }
# # Bloc 1 appel du module pour le bastion
# module "bastion" {
#   source = "../../modules/vm"

#   vm_id          = 100
#   name           = "bastion"
#   cores          = 1
#   memory_mb      = 3072
#   disk_size_gb   = 20
#   ip_address     = "10.10.1.11/24"
#   gateway        = local.common_gateway
#   ssh_key = var.ssh_public_key
#   template_id    = local.common_template
#   tags           = ["bastion", "lab"]
#   description = "Point d'entree SSH du lab"
# }

# # Explication ligne par ligne :
# # module "bastion" — on appelle un module et on lui donne le nom local bastion. Ce nom sera utilisé pour référencer les outputs de ce module ailleurs.
# # source = "../../modules/vm" — chemin vers le module. ../.. remonte de projects/k8s-lab vers terraform, puis descend dans modules/vm. Terraform supporte aussi des sources distantes comme GitHub ou le registry HashiCorp.
# # vm_id = 100 — on fournit une valeur concrète pour la variable vm_id du module.
# # cores = 1 — on surcharge le default du module qui était 2. Le bastion n'a besoin que d'1 vCPU.
# # gateway = var.gateway — on passe la variable du projet au module. C'est comme ça que les variables se propagent — du projet vers le module.
# # tags = ["bastion", "lab"] — une liste directement dans le code. Ces tags apparaîtront dans l'UI Proxmox.

# module "k8s_master" {
#   source = "../../modules/vm"

#   vm_id          = 101
#   name           = "k8s-master"
#   cores          = 2
#   memory_mb      = 4096
#   disk_size_gb   = 30
#   ip_address     = "10.10.1.20/24"
#   gateway        = local.common_gateway
#   ssh_key = var.ssh_public_key
#   template_id    = local.common_template
#   tags           = ["k8s", "master", "lab"]
# }

# module "k8s_worker1" {
#   source = "../../modules/vm"

#   vm_id          = 102
#   name           = "k8s-worker1"
#   cores          = 2
#   memory_mb      = 4096
#   disk_size_gb   = 40
#   ip_address     = "10.10.1.21/24"
#   gateway        = local.common_gateway
#   ssh_key = var.ssh_public_key
#   template_id    = local.common_template
#   tags           = ["k8s", "worker", "lab"]
# }

# module "k8s_worker2" {
#   source = "../../modules/vm"

#   vm_id          = 103
#   name           = "k8s-worker2"
#   cores          = 2
#   memory_mb      = 4096
#   disk_size_gb   = 40
#   ip_address     = "10.10.1.22/24"
#   gateway        = local.common_gateway
#   ssh_key = var.ssh_public_key
#   template_id    = local.common_template
#   tags           = ["k8s", "worker", "lab"]
# }

# module "db_server" {
#   source = "../../modules/vm"

#   vm_id          = 104
#   name           = "db-server"
#   cores          = 2
#   memory_mb      = 4096
#   disk_size_gb   = 40
#   ip_address     = "10.10.1.30/24"
#   gateway        = local.common_gateway
#   ssh_key = var.ssh_public_key
#   template_id    = local.common_template
#   tags           = ["k8s", "DB", "lab"]
# }

locals {
  vms = {
    bastion = { vm_id = 100, ip = "10.10.1.11/24", cores = 1, memory_mb = 2048, disk = 20,  gateway = var.gateway, ssh_key = var.ssh_public_key, template_id = var.template_id, tags = ["bastion", "lab"], description = "Point d'entree SSH du lab" }
    k8s-master = { vm_id = 101, ip = "10.10.1.20/24", cores = 2, memory_mb = 4096, disk = 30,  gateway = var.gateway, ssh_key = var.ssh_public_key, template_id = var.template_id, tags = ["k8s", "master", "lab"], description = "Master du cluster Kubernetes" }
    k8s-worker1 = { vm_id = 102, ip = "10.10.1.21/24", cores = 2, memory_mb = 4096, disk = 40,  gateway = var.gateway, ssh_key = var.ssh_public_key, template_id = var.template_id, tags = ["k8s", "worker", "lab"], description = "Worker du cluster Kubernetes" }
    k8s-worker2 = { vm_id = 103, ip = "10.10.1.22/24", cores = 2, memory_mb = 4096, disk = 40,  gateway = var.gateway, ssh_key = var.ssh_public_key, template_id = var.template_id, tags = ["k8s", "worker", "lab"], description = "Worker du cluster Kubernetes" }
    db-server = { vm_id = 104, ip = "10.10.1.30/24", cores = 2, memory_mb = 4096, disk = 40, gateway = var.gateway, ssh_key = var.ssh_public_key, template_id = var.template_id, tags = ["k8s", "DB", "lab"], description = "Serveur de base de données pour le cluster Kubernetes" }
  }
}

module "vms" {
  for_each = local.vms
  source   = "../../modules/vm"
  vm_id    = each.value.vm_id
  name     = each.key
  cores    = each.value.cores
  memory_mb = each.value.memory_mb
  disk_size_gb = each.value.disk
  ip_address = each.value.ip
  gateway = each.value.gateway
  ssh_key = each.value.ssh_key
  template_id = each.value.template_id
  tags = each.value.tags
  description = each.value.description
}