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