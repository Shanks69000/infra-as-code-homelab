# C'est ici qu'on appelle le module qu'on a créé et qu'on définit 
# les VMs concrètes du projet. 
# C'est le fichier qui ressemble le plus à un playbook Ansible.

# Bloc 1 appel du module pour le bastion
module "bastion" {
  source = "../../modules/vm"

  vm_id          = 100
  name           = "bastion"
  cores          = 1
  memory_mb      = 2048
  disk_size_gb   = 20
  ip_address     = "10.10.1.11/24"
  gateway        = var.gateway
  ssh_public_key = var.ssh_public_key
  template_id    = var.template_id
  tags           = ["bastion", "lab"]
}

# Explication ligne par ligne :
# module "bastion" — on appelle un module et on lui donne le nom local bastion. Ce nom sera utilisé pour référencer les outputs de ce module ailleurs.
# source = "../../modules/vm" — chemin vers le module. ../.. remonte de projects/k8s-lab vers terraform, puis descend dans modules/vm. Terraform supporte aussi des sources distantes comme GitHub ou le registry HashiCorp.
# vm_id = 100 — on fournit une valeur concrète pour la variable vm_id du module.
# cores = 1 — on surcharge le default du module qui était 2. Le bastion n'a besoin que d'1 vCPU.
# gateway = var.gateway — on passe la variable du projet au module. C'est comme ça que les variables se propagent — du projet vers le module.
# tags = ["bastion", "lab"] — une liste directement dans le code. Ces tags apparaîtront dans l'UI Proxmox.

module "k8s_master" {
  source = "../../modules/vm"

  vm_id          = 101
  name           = "k8s-master"
  cores          = 2
  memory_mb      = 4096
  disk_size_gb   = 30
  ip_address     = "10.10.1.20/24"
  gateway        = var.gateway
  ssh_public_key = var.ssh_public_key
  template_id    = var.template_id
  tags           = ["k8s", "master", "lab"]
}

module "k8s_worker1" {
  source = "../../modules/vm"

  vm_id          = 102
  name           = "k8s-worker1"
  cores          = 2
  memory_mb      = 4096
  disk_size_gb   = 40
  ip_address     = "10.10.1.21/24"
  gateway        = var.gateway
  ssh_public_key = var.ssh_public_key
  template_id    = var.template_id
  tags           = ["k8s", "worker", "lab"]
}

module "k8s_worker2" {
  source = "../../modules/vm"

  vm_id          = 103
  name           = "k8s-worker2"
  cores          = 2
  memory_mb      = 4096
  disk_size_gb   = 40
  ip_address     = "10.10.1.22/24"
  gateway        = var.gateway
  ssh_public_key = var.ssh_public_key
  template_id    = var.template_id
  tags           = ["k8s", "worker", "lab"]
}