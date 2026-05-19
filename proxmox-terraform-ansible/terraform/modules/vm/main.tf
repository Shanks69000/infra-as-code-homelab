# Le bloc ressource
#Un bloc resource représente un objet à créer sur l'infrastructure
resource "proxmox_virtual_environment_vm" "this" {
  name       = var.name
  vm_id      = var.vm_id
  node_name  = var.node_name
  tags       = var.tags

    # Bloc suivant — le clone du template
    clone {
    vm_id = var.template_id
    full  = true
    }
    # Bloc suivant — le CPU 
    cpu {
    cores = var.cores
    type = "x86_64-v2-AES"
    }
    # Bloc suivant — la mémoire
    memory {
    dedicated = var.memory_mb
    }
    # Bloc suivant — le disque 
    disk {
    datastore = var.datastore
    interface = "scsi0"
    size = var.disk_size_gb
    file_format = "raw"
    }
    # Bloc suivant — la carte réseau
    network_device {
    bridge = "vmbr0"
    model = "virtio"
    }
    # Bloc suivant — le guest agent
    agent {
    enabled = true
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
        keys     = [var.ssh_public_key]
      }
    }
  boot_order = ["scsi0"]
  on_boot = false
}