# talos cluster setup via tofu (terraform)

## common commands

$ tofu init
$ tofu apply
$ tofu destroy
$ tofu output -raw kubeconfig
$ tofu output -raw talosconfig
$ talosctl dashboard --nodes 10.0.0.161

## upgrade talos

important note: currently this nukes any longhorn volume attached to the vm

1. change the version in the variables file
2. pull new image (tofu apply)
3. change image version for each node (locals file) one at a time
4. re-apply the machine config to each node (see below)

## re-apply machine config to [x] node

### in this example the config for the [2] control plane node is re-applied

$ tofu apply -replace="talos_machine_configuration_apply.cp_config_apply[2]"

### in this example the config for the [2] worker node is re-applied

$ tofu apply -replace="talos_machine_configuration_apply.worker_config_apply[2]"
