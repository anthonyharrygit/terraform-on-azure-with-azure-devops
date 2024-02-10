/*
# Resource-1: Create Public IP Address
resource "azurerm_public_ip" "rabbitmq01_linuxvm_publicip" {
  name = "${local.resource_name_prefix}-rabbitmq01-linuxvm-publicip"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  allocation_method = "Static"
  sku = "Standard"
  domain_name_label = "tma-mrsdev-rq01-vm-${random_string.myrandom.id}"
}
*/

# Resource-3: Create Public IP Address
resource "azurerm_public_ip" "iis01_vm_publicip" {
  name = "${local.resource_name_prefix}-iis01_vm_publicip"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  allocation_method = "Static"
  sku = "Standard"
  domain_name_label = "tma-mrsdev-iis01-vm-${random_string.myrandom.id}"
}