locals {
  vms = {
    k8s-master = {
      vmid   = 101
      cores  = 2
      memory = 4096
      disk   = 30
      ip     = "10.10.1.20"
    }
    k8s-worker1 = {
      vmid   = 102
      cores  = 2
      memory = 4096
      disk   = 40
      ip     = "10.10.1.21"
    }
    k8s-worker2 = {
      vmid   = 103
      cores  = 2
      memory = 4096
      disk   = 40
      ip     = "10.10.1.22"
    }
    bastion = {
      vmid   = 100
      cores  = 1
      memory = 2048
      disk   = 20
      ip     = "10.10.1.11"
    }
  }
}

resource "proxmox_virtual_environment_vm" "vms" {
  for_each  = local.vms
  name      = each.key
  node_name = "pve"
  vm_id     = each.value.vmid

  clone {
    vm_id = 9000
    full  = true
  }

  cpu {
    cores = each.value.cores
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = each.value.memory
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = each.value.disk
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  initialization {
    ip_config {
      ipv4 {
        address = "${each.value.ip}/24"
        gateway = "10.10.1.1"
      }
    }
    dns {
      servers = ["1.1.1.1"]
    }
    user_account {
      username = "debian"
      keys     = [var.ssh_public_key]
    }
  }

  agent {
    enabled = true
  }
}
