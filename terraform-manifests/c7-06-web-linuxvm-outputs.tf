/*
## Public IP Address
output "Rabbitmq01_linuxvm_public_ip" {
  description = "Rabbitmq01 Linux VM Public Address"
  value = azurerm_public_ip.rabbitmq01_linuxvm_publicip.ip_address
}

# Network Interface Outputs
## Network Interface ID
output "Rabbitmq01_linuxvm_network_interface_id" {
  description = "Rabbitmq01 Linux VM Network Interface ID"
  value = azurerm_network_interface.rabbitmq01_linuxvm_nic.id
}
## Network Interface Private IP Addresses
output "RMQ_linuxvm_network_interface_private_ip_addresses" {
  description = "RMQ Linux VM Private IP Addresses"
  value = [azurerm_network_interface.rabbitmq01_linuxvm_nic.private_ip_addresses]
}

# Linux VM Outputs

## Virtual Machine Public IP
output "rabbitmq01_linuxvm_public_ip_address" {
  description = "Rabbitmq01 Linux Virtual Machine Public IP"
  value = azurerm_linux_virtual_machine.rabbitmq01_linuxvm.public_ip_address
}



## Virtual Machine 128-bit ID
output "RabbitMQ_linuxvm_virtual_machine_id_128bit" {
  description = "RMQ Linux Virtual Machine ID - 128-bit identifier"
  value = azurerm_linux_virtual_machine.rabbitmq01_linuxvm.virtual_machine_id
}
## Virtual Machine ID
output "RabbitMQ_linuxvm_virtual_machine_id" {
  description = "Web Linux Virtual Machine ID "
  value = azurerm_linux_virtual_machine.rabbitmq01_linuxvm.id
}
*/

output "IIIS_public_ip_address" {
  value = azurerm_windows_virtual_machine.iis01_vm.public_ip_address
}

output "iis_admin_password" {
  sensitive = true
  value     = azurerm_windows_virtual_machine.iis01_vm.admin_password
}

