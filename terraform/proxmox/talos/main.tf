# https://registry.terraform.io/providers/bpg/proxmox/0.62.0/docs/resources/virtual_environment_vm
resource "proxmox_virtual_environment_vm" "talos" {
  for_each = { for vm in local.talos_nodes : vm.ip => vm }

  name            = each.value.name
  node_name       = each.value.target_node
  vm_id           = local.vm_starting_vmid + index(local.talos_nodes, each.value)
  machine         = "q35"
  scsi_hardware   = "virtio-scsi-single"
  boot_order      = ["virtio0", "ide2"]
  stop_on_destroy = true

  agent {
    enabled = true
  }

  operating_system {
    type = "l26"
  }

  cpu {
    type  = "host"
    cores = try(each.value.cores, 1)
    numa  = true
  }

  memory {
    dedicated = try(each.value.memory, 1024)
  }

  cdrom {
    interface = "ide2"
    file_id   = "local:iso/nocloud-amd64.iso"
  }

  disk {
    datastore_id = "local-zfs"
    interface    = "virtio0"
    ssd          = true
    discard      = "on"
    size         = try(each.value.disk_size, "10")
  }

  dynamic "network_device" {
    for_each = [1]
    content {
      bridge = "vmbr0"
      model  = "virtio"
    }
  }

  initialization {
    ip_config {
      ipv4 {
        address = "${each.value.ip}/${local.network_subnet}"
        gateway = local.network_gateway
      }
    }

    user_account {
      username = "talos"
      password = "disabled"
    }
  }
}
