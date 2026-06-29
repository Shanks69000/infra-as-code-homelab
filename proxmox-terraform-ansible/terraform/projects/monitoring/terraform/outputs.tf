output "k8s_grafana" {
    description = "IP de la VM Grafana"
    value       = module.grafana.ip_address
  
}