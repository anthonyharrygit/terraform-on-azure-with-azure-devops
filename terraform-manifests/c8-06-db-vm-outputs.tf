## Public IP Address
output "SQL_vm_public_ip" {
  description = "SQL VM Public Address"
  value = azurerm_public_ip.sql01_vm_publicip.ip_address
}

# Network Interface Outputs
## Network Interface ID
output "sql_vm_network_interface_id" {
  description = "SQL VM Network Interface ID"
  value = azurerm_network_interface.sql01_vm_nic.id
}
## Network Interface Private IP Addresses
output "SQL_vm_network_interface_private_ip_addresses" {
  description = "SQL VM Private IP Addresses"
  value = [azurerm_network_interface.sql01_vm_nic.private_ip_addresses]
}

# SQL VM Outputs


## Virtual Machine 128-bit ID
output "sql01_vm_virtual_machine_id_128bit" {
  description = "SQL01 Virtual Machine ID - 128-bit identifier"
  value = azurerm_windows_virtual_machine.sql01_vm.virtual_machine_id
}
## Virtual Machine ID
output "SQL01_vm_virtual_machine_id" {
  description = "SQL01 Virtual Machine ID "
  value = azurerm_windows_virtual_machine.sql01_vm.id
}
output "sql01_admin_user" {
  value     = azurerm_windows_virtual_machine.sql01_vm.admin_username
}

output "sql01_admin_password" {
  sensitive = true
  value     = azurerm_windows_virtual_machine.sql01_vm.admin_password
}
/*
output "sql02_admin_user" {
  value     = azurerm_windows_virtual_machine.sql02_vm.admin_username
}

output "sql02_admin_password" {
  sensitive = true
  value     = azurerm_windows_virtual_machine.sql02_vm.admin_password
}
*/