locals {
  fluxcd_helm_values = {
    // Increase concurrent reconciliations for fluxcd controllers
    kustomizeController = {
      container = {
        additionalArgs = ["--concurrent=15", "--concurrent-ssa=15"]
      }
    }
    helmController = {
      container = {
        additionalArgs = ["--concurrent=15"]
      }
    }
  }
  flux_sync_helm_values = {
    gitRepository = {
      spec = {
        url = "https://github.com/adameddy/home-ops.git"
        secretRef = {
          name = "flux-git-credentials"
        }
        ref = {
          branch = "main"
        }
        interval = "1m"
        ignore   = <<EOF
          # Ignore all folders, but include the ones with cluster resources
          /*
          # Cluster folders include
          !/kubernetes/flux
          !/kubernetes/apps/
          !/kubernetes/core/
          # Remove flux-system as well
          kubernetes/flux/flux-system/
          EOF
      }
    }
    kustomization = {
      spec = {
        prune = true
        force = true
        path  = "./kubernetes/flux"
      }
    }
  }
}

resource "kubernetes_namespace_v1" "flux_system" {
  metadata {
    name = "flux-system"
  }
}

resource "kubernetes_secret_v1" "flux_git_credentials" {
  depends_on = [kubernetes_namespace_v1.flux_system]
  metadata {
    name      = "flux-git-credentials"
    namespace = kubernetes_namespace_v1.flux_system.metadata[0].name
  }

  type = "Opaque"

  data = {
    "username" = data.sops_file.flux_secrets.data["flux_git_user"]
    "password" = data.sops_file.flux_secrets.data["flux_git_token"]
  }
}

resource "kubernetes_secret_v1" "sops_age" {
  depends_on = [kubernetes_namespace_v1.flux_system]
  metadata {
    name      = "sops-age"
    namespace = kubernetes_namespace_v1.flux_system.metadata[0].name
  }

  type = "Opaque"

  data = {
    "identity.agekey" = data.sops_file.flux_secrets.data["agekey"]
  }
}

# example from https://github.com/fluxcd/terraform-provider-flux/blob/main/examples/helm-install/main.tf
resource "helm_release" "fluxcd" {
  depends_on = [kubernetes_secret_v1.flux_git_credentials]
  repository      = "https://fluxcd-community.github.io/helm-charts"
  chart           = "flux2"
  version         = "2.17.2"
  name            = "flux2"
  namespace       = "flux-system"
  upgrade_install = true
  values          = [yamlencode(local.fluxcd_helm_values)]
}

resource "helm_release" "fluxcd_sync" {
  depends_on = [helm_release.fluxcd]
  repository = "https://fluxcd-community.github.io/helm-charts"
  chart      = "flux2-sync"
  version    = "1.14.1"

  # Note: Do not change the name or namespace of this resource. The below mimics the behaviour of "flux bootstrap".
  name            = "flux-system"
  namespace       = "flux-system"
  upgrade_install = true

  values     = [yamlencode(local.flux_sync_helm_values)]
}
