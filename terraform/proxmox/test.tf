resource "proxmox_vm_qemu" "test" {
    target_node = "pve-prod-1"
    desc = "Cloudinit Ubuntu"
    count = 1
    onboot = false

    # The template name to clone this vm from
    clone = "23.04-non-KVM"

    # Activate QEMU agent for this VM
    agent = 0

    os_type = "cloud-init"
    cores = 2
    sockets = 2
    numa = true
    vcpus = 0
    cpu = "host"
    memory = 4096
    name = "k3s-master-0${count.index + 1}"

    cloudinit_cdrom_storage = "nvme"
    scsihw   = "virtio-scsi-single" 
    bootdisk = "scsi0"

    disks {
        scsi {
            scsi0 {
                disk {
                  storage = "nvme"
                  size = 12
                }
            }
        }
    }
}