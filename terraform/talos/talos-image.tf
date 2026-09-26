data "http" "talos_factory_schematic_id" {
  url    = "https://factory.talos.dev/schematics"
  method = "POST"

  request_headers = {
    Content-type = "text/x-yaml"
  }
  request_body = file("./schematic.yaml")
}

resource "proxmox_virtual_environment_download_file" "talos_nocloud_image" {
  content_type = "iso"
  datastore_id = "proxmox-nfs"
  node_name    = "pve-prod-1"

  file_name               = "talos-${var.talos_version}-nocloud-amd64.img"
  url                     = "https://factory.talos.dev/image/${jsondecode(data.http.talos_factory_schematic_id.response_body).id}/v${var.talos_version}/nocloud-amd64.raw.gz"
  decompression_algorithm = "gz"
  overwrite               = false
}
