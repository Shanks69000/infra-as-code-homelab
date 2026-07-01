module "grafana" {
  source = "../../../modules/vm"

  vm_id          = 105
  name           = "grafana"
  cores          = 2
  memory_mb      = 4096
  disk_size_gb   = 40
  ip_address     = "10.10.1.40/24"
  gateway        = var.gateway
  ssh_key = var.ssh_public_key
  template_id    = var.template_id
  tags           = ["k8s", "lab"]
  description = "VM Grafana pour la surveillance du cluster Kubernetes"
}