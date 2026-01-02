locals {
# Using hardcoded version numbers instead of `var.talos_version` for rolling upgrades.
# Using `var.talos_version` for each image would upgrade everything at once.

  # Controller Nodes
  controller_nodes = [
    {
      name        = "talos-controller-01"
      target_node = "pve-prod-1"
      vm_id       = 161
      ip_address  = "10.0.0.161"
      memory      = 4 * 1024
      cores       = 2
      disk_size   = 10
      image       = "talos-1.12.0-nocloud-amd64.img"
    },
    {
      name        = "talos-controller-02"
      target_node = "pve-prod-2"
      vm_id       = 162
      ip_address  = "10.0.0.162"
      memory      = 4 * 1024
      cores       = 2
      disk_size   = 10
      image       = "talos-1.12.0-nocloud-amd64.img"
    },
    {
      name        = "talos-controller-03"
      target_node = "pve-prod-3"
      vm_id       = 163
      ip_address  = "10.0.0.163"
      memory      = 4 * 1024
      cores       = 2
      disk_size   = 10
      image       = "talos-1.12.0-nocloud-amd64.img"
    }
  ]

  # Worker Nodes
  worker_nodes = [
    {
      name              = "talos-worker-01"
      target_node       = "pve-prod-1"
      vm_id             = 171
      ip_address        = "10.0.0.171"
      memory            = 6 * 1024
      cores             = 2
      disk_size         = 10
      image             = "talos-1.12.0-nocloud-amd64.img"
      add_longhorn_disk = false
      hostpci_devices   = []
    },
    {
      name              = "talos-worker-02"
      target_node       = "pve-prod-2"
      vm_id             = 172
      ip_address        = "10.0.0.172"
      memory            = 6 * 1024
      cores             = 2
      disk_size         = 10
      image             = "talos-1.12.0-nocloud-amd64.img"
      add_longhorn_disk = false
      hostpci_devices   = []
    },
    {
      name              = "talos-worker-03"
      target_node       = "pve-prod-3"
      vm_id             = 173
      ip_address        = "10.0.0.173"
      memory            = 6 * 1024
      cores             = 2
      disk_size         = 10
      image             = "talos-1.12.0-nocloud-amd64.img"
      add_longhorn_disk = true
      hostpci_devices = [
        {
          device  = "hostpci0"
          mapping = "igpu"
        }
      ]
    }
  ]

  # Network
  network_gateway = "10.0.0.1"
  network_subnet  = "24"
}
