output "Master-IPS" {
  value = flatten(proxmox_virtual_environment_vm.proxmox_vm_master[*].ipv4_addresses)
}

output "Worker-IPS" {
  value = flatten(proxmox_virtual_environment_vm.proxmox_vm_worker[*].ipv4_addresses)
}
