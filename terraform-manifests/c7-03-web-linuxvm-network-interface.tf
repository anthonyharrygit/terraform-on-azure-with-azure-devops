/*
# Resource-1: rabbitmq02 Create Network Interface
resource "azurerm_network_interface" "rabbitmq01_linuxvm_nic" {
  name = "${local.resource_name_prefix}-rabbitmq01-linuxvm-nic"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
   
  ip_configuration {
    name = "rabbitmq01-linuxvm-ip-1"
    subnet_id = azurerm_subnet.websubnet.id 
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.rabbitmq01_linuxvm_publicip.id
  }
}
*/

# Resource-3: iis Create Network Interface
resource "azurerm_network_interface" "iis01_vm_nic" {
  name = "${local.resource_name_prefix}-iis01_vm_nic"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
   
  ip_configuration {
    name = "iis01-vm-ip-1"
    subnet_id = azurerm_subnet.websubnet.id 
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.iis01_vm_publicip.id
  }
}
