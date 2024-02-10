# Resource-1: Create Public IP Address
resource "azurerm_public_ip" "sql01_vm_publicip" {
  name = "${local.resource_name_prefix}-sql01-vm-publicip"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  allocation_method = "Static"
  sku = "Standard"
  domain_name_label = "tma-mrsdev-sql01-vm-${random_string.myrandom.id}"
}
