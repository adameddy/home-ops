# Update configs for k9s
# TODO - Run automatically on state change
tofu output -state=./terraform.tfstate -raw kubeconfig > $HOME/.kube/config
tofu output -state=./terraform.tfstate -raw talosconfig > $HOME/.talos/config
