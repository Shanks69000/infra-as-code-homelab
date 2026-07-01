# Le bloc ressource
#Un bloc resource représente un objet à créer sur l'infrastructure
resource "proxmox_virtual_environment_vm" "this" {
  name       = var.name
  vm_id      = var.vm_id
  node_name  = var.node_name
  tags       = var.tags

    # Bloc le clone du template
    clone {
    vm_id = var.template_id
    full  = true
    }
    # Bloc le CPU 
    cpu {
    cores = var.cores
    type = "x86-64-v2-AES"
    }
    # Bloc la mémoire
    memory {
    dedicated = var.memory_mb
    }
    # Bloc le disque 
    disk {
    datastore_id = var.datastore
    interface = "scsi0"
    size = var.disk_size_gb
    file_format = "raw"
    }
    # Bloc la carte réseau
    network_device {
    bridge = "vmbr0"
    model = "virtio"
    }
    # Bloc le guest agent
    agent {
      enabled = true
      timeout = "1m"
      trim    = false
    }
    initialization {
      ip_config {
        ipv4 {
          address = var.ip_address
          gateway = var.gateway
        }
      }
      user_account {
        username = var.ci_user
        keys     = [var.ssh_key]
      }
    }
  boot_order = ["scsi0"]
  on_boot = false
  started = var.started
  description = var.description
}