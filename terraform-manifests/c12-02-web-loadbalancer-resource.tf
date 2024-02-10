# Resource-1: Create Public IP Address for Azure Load Balancer
resource "azurerm_public_ip" "web_lbpublicipdev" {
  name = "${local.resource_name_prefix}-lbpublicipdev"
  resource_group_name = azurerm_resource_group.rg.name 
  location = azurerm_resource_group.rg.location
  allocation_method = "Static"
  sku = "Standard"
  tags = local.common_tags
}
# Resource-2: Create Azure Standard Load Balancer
resource "azurerm_lb" "web_lbdev" {
  name = "${local.resource_name_prefix}-web-lbdev"
  resource_group_name = azurerm_resource_group.rg.name 
  location = azurerm_resource_group.rg.location  
  sku = "Standard"
  frontend_ip_configuration {
    name = "web-lb-publicip-dev1"
    public_ip_address_id = azurerm_public_ip.web_lbpublicipdev.id
  }

  /*
  # fyi we have multiple frontend ip confiured to Azure LB, see example
 frontend_ip_configuration {
    name = "web-lb-publicip-qa1"
    public_ip_address_id = azurerm_public_ip.web_lbpublicipdev.id
  }
  frontend_ip_configuration {
    name = "web-lb-publicip-qa2"
    public_ip_address_id = azurerm_public_ip.web_lbpublicipdev.id
  }

  #you can refer this way " frontend_ip_configuration_name = azurerm_lb.web_lbqa.frontend_ip_configuration[0].name "
  */

}
# Resource-3: Create LB Backend Pool
resource "azurerm_lb_backend_address_pool" "web_lb_backend_address_pooldev" {
  name = "web-backenddev"
  loadbalancer_id = azurerm_lb.web_lbdev.id
}
# Resource-4: Create LB Probe
resource "azurerm_lb_probe" "web_lb_probe_http_dev" {
  name = "http-probedev"
  protocol = "Tcp"
  port = 80
  loadbalancer_id = azurerm_lb.web_lbdev.id
  #resource_group_name = azurerm_resource_group.rg.name 
}
# Resource-5: Create LB Rule
resource "azurerm_lb_rule" "web_lb_rule_dev" {
  name = "web-dev-rule"
  protocol = "Tcp"
  frontend_port = 80
  backend_port = 80
  frontend_ip_configuration_name = azurerm_lb.web_lbdev.frontend_ip_configuration[0].name
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.web_lb_backend_address_pooldev.id]
  probe_id = azurerm_lb_probe.web_lb_probe_http_dev.id 
  loadbalancer_id = azurerm_lb.web_lbdev.id
  #resource_group_name = azurerm_resource_group.rg.name 
}
# Resource-6: Associate Network Interface and Standard Load Balancer
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_backend_address_pool_association
resource "azurerm_network_interface_backend_address_pool_association" "web_nic_lb_associate" {
  network_interface_id = azurerm_network_interface.iis01_vm_nic.id 
  ip_configuration_name = azurerm_network_interface.iis01_vm_nic.ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.web_lb_backend_address_pooldev.id   
}