## Bastion Host Public IP Output
output "bastion_host_linuxvm_public_ip_addres" {
  description = "Bastion Host Linux VM Public Address"
  value = azurerm_public_ip.bastion_host_publicip.ip_address
}

output "bas1_admin_password" {
  sensitive = true
  value     = azurerm_windows_virtual_machine.bastion_host.admin_password
}