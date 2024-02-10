# Resource-2: Create Network Interface
resource "azurerm_network_interface" "lod01_vm_nic" {
  name = "${local.resource_name_prefix}-lod01-vm-nic"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
   
  ip_configuration {
    name = "tma-mrsdev-lod01-vm-ip-1"
    subnet_id = azurerm_subnet.appsubnet.id 
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.lod01_vm_publicip.id
  }
}


