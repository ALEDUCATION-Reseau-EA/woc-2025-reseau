resource "proxmox_vm_qemu" "test_vm" {
  name        = "terraform-vm"
  target_node = "formation"
  vmid        = 150
  clone       = "debiantm"

  os_type = "cloud-init"
  cores   = 2
  memory  = 2048

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  disk {
    type    = "scsi"
    storage = "local-lvm"
    size    = "10G"
  }

  sshkeys = file("~/.ssh/id_rsa.pub")  # Ajout de la clé SSH
}

# On stocke l'IP publique de Proxmox pour Ansible
output "proxmox_public_ip" {
  value = var.proxmox_public_ip
}
