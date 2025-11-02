locals {
    talos_nodes = {
        "talos-01" = {
            target_node = "pve-prod-1"
        },
        "talos-02" = {
            target_node = "pve-prod-2"
        },
    }
}

resource "proxmox_vm_qemu" "talos" {
    for_each = local.talos_nodes

    agent = 0
    memory = 1024
    name = each.key
    target_node = each.value.target_node

    cpu {
        type = "host"
        cores = 2
        }

    disks {
        ide {
            ide2 {
                cdrom {
                    iso = "local:iso/nocloud-amd64.iso"
                }
            }
        }

        scsi {
            scsi0 {
                disk {
                    size = "10G"
                    storage = "local-zfs"
                }
            }
        }
    }

    network {
        bridge = "vmbr0"
        model = "virtio"
        id = 0
    }
}