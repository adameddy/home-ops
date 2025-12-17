# https://search.opentofu.org/providers

terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "3.1.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.0.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.6.1"
    }
    sops = {
      source  = "carlpett/sops"
      version = "0.7.2"
    }
  }
}

provider "helm" {
  kubernetes = {
    config_path = "../../tmp/kubeconfig"
  }
}

provider "kubernetes" {
  config_path = "../../tmp/kubeconfig"
}

data "sops_file" "flux_git_credentials" {
  source_file = "secrets.sops.yaml"
}
