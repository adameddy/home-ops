# https://registry.terraform.io/providers/bpg/proxmox/0.62.0/docs/resources/virtual_environment_vm
resource "proxmox_virtual_environment_vm" "workers" {

  for_each = { for node in local.worker_nodes : node.ip_address => node }

  name            = each.value.name
  node_name       = each.value.target_node
  vm_id           = each.value.vm_id
  machine         = "q35"
  scsi_hardware   = "virtio-scsi-single"
  boot_order      = ["scsi0"]
  stop_on_destroy = true

  agent {
    enabled = true
    trim    = true
    timeout = "3m"
  }

  operating_system {
    type = "l26"
  }

  cpu {
    type  = "host"
    cores = each.value.cores
    numa  = true
  }

  memory {
    dedicated = each.value.memory
  }

  disk {
    datastore_id = "local-zfs"
    interface    = "scsi0"
    iothread     = true
    ssd          = true
    discard      = "on"
    size         = each.value.disk_size
    file_format  = "raw"
    file_id      = "proxmox-nfs:iso/${each.value.image}"
  }

  dynamic "network_device" {
    for_each = [1]
    content {
      bridge = "vmbr0"
      model  = "virtio"
    }
  }

  dynamic "hostpci" {
    for_each = each.value.hostpci_devices
    content {
      device = hostpci.value.device
      mapping = hostpci.value.mapping
    }
  }

  initialization {
    datastore_id = "local-zfs"
    interface    = "scsi1"

    ip_config {
      ipv4 {
        address = "${each.value.ip_address}/${local.network_subnet}"
        gateway = local.network_gateway
      }
    }

    user_account {
      username = "talos"
      password = "disabled"
    }
  }
}
