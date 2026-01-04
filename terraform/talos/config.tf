# Generate Talos cluster secrets (shared across all nodes)
resource "talos_machine_secrets" "machine_secrets" {}

data "talos_client_configuration" "talosconfig" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  endpoints            = [for node in local.controller_nodes : node.ip_address]
}


# Generate machine configuration for control plane nodes
data "talos_machine_configuration" "controller" {
  cluster_name     = var.cluster_name
  cluster_endpoint = var.cluster_endpoint
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.machine_secrets.machine_secrets
  config_patches = [
    yamlencode({
      cluster = {
        network = {
          podSubnets     = var.pod_subnets
          serviceSubnets = var.service_subnets
          cni = {
            name = "none"
          }
        }
        proxy = {
          disabled = true
        }
      }
      machine = {
        features = {
          kubePrism = {
            enabled = true
            port    = 7445
          }
        }
        kubelet = {
          nodeIP = {
            validSubnets = [var.cluster_node_network]
          }
          extraArgs = {
            cloud-provider             = "external"
            rotate-server-certificates = true
            feature-gates              = "ImageVolume=true"
          }
        }
        network = {
          interfaces = [{
            interface = "eth0"
            vip = {
              ip = var.cluster_vip
            }
          }]
        }
      }
    })
  ]
}

# Generate machine configuration for worker nodes
data "talos_machine_configuration" "worker" {
  cluster_name     = var.cluster_name
  cluster_endpoint = var.cluster_endpoint
  machine_type     = "worker"
  machine_secrets  = talos_machine_secrets.machine_secrets.machine_secrets
  config_patches = [
    yamlencode({
      cluster = {
        network = {
          podSubnets     = var.pod_subnets
          serviceSubnets = var.service_subnets
          cni = {
            name = "none"
          }
        }
        proxy = {
          disabled = true
        }
      }
      machine = {
        features = {
          kubePrism = {
            enabled = true
            port    = 7445
          }
        }
        kernel = {
          modules = [
            { name = "nbd" },       # used for longhorn
            { name = "iscsi_tcp" }, # used for longhorn
          ]
        }
      }
    })
  ]
}

# Apply control plane nodes machine configuration
resource "talos_machine_configuration_apply" "cp_config_apply" {
  count                       = length(local.controller_nodes)
  depends_on                  = [proxmox_virtual_environment_vm.controllers]
  client_configuration        = talos_machine_secrets.machine_secrets.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controller.machine_configuration
  endpoint                    = local.controller_nodes[count.index].ip_address
  node                        = local.controller_nodes[count.index].ip_address
}

# Apply worker nodes machine configuration
resource "talos_machine_configuration_apply" "worker_config_apply" {
  count                       = length(local.worker_nodes)
  depends_on                  = [proxmox_virtual_environment_vm.workers]
  client_configuration        = talos_machine_secrets.machine_secrets.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
  endpoint                    = local.worker_nodes[count.index].ip_address
  node                        = local.worker_nodes[count.index].ip_address
}

# Bootstrap the cluster
resource "talos_machine_bootstrap" "bootstrap" {
  depends_on           = [talos_machine_configuration_apply.cp_config_apply]
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  endpoint             = local.controller_nodes[0].ip_address
  node                 = local.controller_nodes[0].ip_address
}

resource "talos_cluster_kubeconfig" "kubeconfig" {
  depends_on           = [talos_machine_bootstrap.bootstrap]
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  endpoint             = local.controller_nodes[0].ip_address
  node                 = local.controller_nodes[0].ip_address
}

# Save configs in tmp
resource "local_file" "kubeconfig" {
  content  = resource.talos_cluster_kubeconfig.kubeconfig.kubeconfig_raw
  filename = "../../tmp/kubeconfig"
}

resource "local_file" "talosconfig" {
  content  = data.talos_client_configuration.talosconfig.talos_config
  filename = "../../tmp/talosconfig"
}
