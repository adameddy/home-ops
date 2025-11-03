terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.66"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "~> 0.7"
    }
    sops = {
      source  = "carlpett/sops"
      version = "0.7.2"
    }
  }
}

data "sops_file" "proxmox_secrets" {
  source_file = "secrets.sops.yaml"
}

provider "proxmox" {
  endpoint  = data.sops_file.proxmox_secrets.data["pm_api_url"]
  api_token = "${data.sops_file.proxmox_secrets.data["pm_api_token_id"]}=${data.sops_file.proxmox_secrets.data["pm_api_token_secret"]}"
  insecure  = true
}
