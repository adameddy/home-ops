locals {
  vm_starting_vmid = 6000
  network_gateway  = "10.0.0.1"
  network_subnet   = "24"

  talos_nodes = [
    {
      name        = "talos-01"
      target_node = "pve-prod-1"
      ip          = "10.0.0.120"
      memory      = 1024
      cores       = 2
      disk_size   = 10
    },
    {
      name        = "talos-02"
      target_node = "pve-prod-2"
      ip          = "10.0.0.121"
      memory      = 1024
      cores       = 2
      disk_size   = 10
    }
  ]
}
