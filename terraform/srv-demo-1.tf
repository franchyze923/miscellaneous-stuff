resource "proxmox_vm_qemu" "srv_demo_1" {

    count = 0 # just want 1 for now, set to 0 and apply to destroy VM
    name = "terraform-vm-${count.index + 1}"

    #name = "srv-demo-1"
    desc = "Ubuntu 22 Server"
    #vmid = "401"
    target_node = "franhost"

    clone = "ubuntu-cloud-22"
    cores = 2
    sockets = 1
    cpu = "host"
    memory = 2048

    #network {
        #bridge = "vmbr0"
        #model = "virtio"
    #}

    disk {

        storage = "ProxMox-ISOs"
        type = "scsi"
        size = "2252M"
    }
}