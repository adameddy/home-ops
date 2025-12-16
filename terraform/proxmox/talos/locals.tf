locals {

  # Controller Nodes
  controller_nodes = [
    {
      name        = "talos-controller-01"
      target_node = "pve-dev-1"
      vm_id       = 161
      ip_address  = "10.0.0.161"
      memory      = 4096
      cores       = 2
      disk_size   = 10
      image       = "talos-${var.talos_version}-nocloud-amd64.img"
    },
    {
      name        = "talos-controller-02"
      target_node = "pve-dev-1"
      vm_id       = 162
      ip_address  = "10.0.0.162"
      memory      = 4096
      cores       = 2
      disk_size   = 10
      image       = "talos-${var.talos_version}-nocloud-amd64.img"
    }
  ]

  # Worker Nodes
  worker_nodes = [
    {
      name        = "talos-worker-01"
      target_node = "pve-dev-1"
      vm_id       = 171
      ip_address  = "10.0.0.171"
      memory      = 4096
      cores       = 2
      disk_size   = 10
      image       = "talos-${var.talos_version}-nocloud-amd64.img"
    },
    {
      name        = "talos-worker-02"
      target_node = "pve-dev-1"
      vm_id       = 172
      ip_address  = "10.0.0.172"
      memory      = 4096
      cores       = 2
      disk_size   = 10
      image       = "talos-${var.talos_version}-nocloud-amd64.img"
    }
  ]

  # Network
  network_gateway = "10.0.0.1"
  network_subnet  = "24"
}
