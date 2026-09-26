# Disabled since lifecycle block prevents `terraform destory` from working

# Nocloud with qemu-guest-agent & i915
# resource "proxmox_virtual_environment_download_file" "talos_nocloud_image" {
#   count        = length(local.proxmox_nodes)
#   content_type = "iso"
#   datastore_id = "local"
#   node_name    = local.proxmox_nodes[count.index]

#   file_name               = "talos-${var.talos_version}-nocloud-amd64.img"
#   url                     = "https://factory.talos.dev/image/d3dc673627e9b94c6cd4122289aa52c2484cddb31017ae21b75309846e257d30/v${var.talos_version}/nocloud-amd64.raw.gz"
#   decompression_algorithm = "gz"
#   overwrite               = false

#   lifecycle {
#     prevent_destroy = true
#   }
# }
