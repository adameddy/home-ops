tofu output -state=../../proxmox/talos/terraform.tfstate -raw kubeconfig > $HOME/.kube/config
tofu output -state=../../proxmox/talos/terraform.tfstate -raw talosconfig > $HOME/.talos/config
