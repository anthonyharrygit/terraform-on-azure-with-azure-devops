## Public IP Address
output "LOD1_vm_public_ip" {
  description = "LOD VM Public Address"
  value = azurerm_public_ip.lod01_vm_publicip.ip_address
}

# Network Interface Outputs
## Network Interface ID
#output "lod_vm_network_interface_id" {
#  description = "LOD VM Network Interface ID"
# value = azurerm_network_interface.lod01_vm_nic.id
#}
## Network Interface Private IP Addresses
output "LOD1_vm_network_interface_private_ip_addresses" {
  description = "LOD VM Private IP Addresses"
  value = [azurerm_network_interface.lod01_vm_nic.private_ip_addresses]
}

# SQL VM Outputs


## Virtual Machine 128-bit ID
output "LOD01_vm_virtual_machine_id_128bit" {
  description = "lod01 Virtual Machine ID - 128-bit identifier"
  value = azurerm_windows_virtual_machine.lod1_vm.virtual_machine_id
}
## Virtual Machine ID
output "LOD01_vm_virtual_machine_id" {
  description = "LOD01 Virtual Machine ID "
  value = azurerm_windows_virtual_machine.lod1_vm.id
}
output "lod1_admin_user" {
  value     = azurerm_windows_virtual_machine.lod1_vm.admin_username
}

output "lod1_admin_password" {
  sensitive = true
  value     = azurerm_windows_virtual_machine.lod1_vm.admin_password
}
