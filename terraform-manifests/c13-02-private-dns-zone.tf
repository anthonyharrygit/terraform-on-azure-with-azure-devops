/*
# Resource-1: Create Azure Private DNS Zone
resource "azurerm_private_dns_zone" "private_dns_zone_dev" {
  name = "tmadataservicesdev.co.uk"
  resource_group_name = azurerm_resource_group.rg.name 
}

# Resource-2: Associate Private DNS Zone to Virtual Network
resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_vnet_associate_dev" {
  name = "${local.resource_name_prefix}-private-dns-zone-vnet-associate"
  resource_group_name = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_dev.name 
  virtual_network_id = azurerm_virtual_network.vnet.id 
}

# Resource-3: Internal Load Balancer DNS A Record
resource "azurerm_private_dns_a_record" "iis01_dns_record" {
  #depends_on = [azurerm_lb.app_lb ]
  depends_on = [azurerm_windows_virtual_machine.iis01_vm ]
  name                = "tma-mwdev-iis01"
  zone_name           = azurerm_private_dns_zone.private_dns_zone_dev.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  #records             = ["${azurerm_lb.app_lb.frontend_ip_configuration[0].private_ip_address}"]
  records             = ["10.1.1.4"]
}


# Resource-4: Internal Load Balancer DNS A Record
resource "azurerm_private_dns_a_record" "srv01_dns_record" {
  #depends_on = [azurerm_lb.app_lb ]
  depends_on = [azurerm_windows_virtual_machine.srv01_vm ]
  name                = "tma-mwdev-srv01"
  zone_name           = azurerm_private_dns_zone.private_dns_zone_dev.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  #records             = ["${azurerm_lb.app_lb.frontend_ip_configuration[0].private_ip_address}"]
  records             = ["10.1.11.4"]
  #records             = ["${azurerm_network_interface.srv01_vm_nic.ip_configuration[0].private_ip_address_allocation}"]
}

# Resource-5: Internal Load Balancer DNS A Record
resource "azurerm_private_dns_a_record" "sql01_dns_record" {
  #depends_on = [azurerm_lb.app_lb ]
  depends_on = [azurerm_windows_virtual_machine.sql01_vm ]
  name                = "tma-mwdev-sql01"
  zone_name           = azurerm_private_dns_zone.private_dns_zone_dev.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  #records             = ["${azurerm_lb.app_lb.frontend_ip_configuration[0].private_ip_address}"]
  records             = ["10.1.21.4"]
  #records             = ["${azurerm_network_interface.srv01_vm_nic.ip_configuration[0].private_ip_address_allocation}"]
}


# Resource-5: Internal Load Balancer DNS A Record
resource "azurerm_private_dns_a_record" "rmq01_dns_record" {
  #depends_on = [azurerm_lb.app_lb ]
  depends_on = [azurerm_windows_virtual_machine.sql01_vm ]
  name                = "tma-mwdev-rmq01"
  zone_name           = azurerm_private_dns_zone.private_dns_zone_dev.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  #records             = ["${azurerm_lb.app_lb.frontend_ip_configuration[0].private_ip_address}"]
  records             = ["10.1.1.5"]
  #records             = ["${azurerm_network_interface.srv01_vm_nic.ip_configuration[0].private_ip_address_allocation}"]
}
*/