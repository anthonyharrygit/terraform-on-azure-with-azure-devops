#---------------------------------------------
# Public IP for Virtual Network Gateway
#---------------------------------------------


# Resource-3: Create Public IP Address
resource "azurerm_public_ip" "pip_gw" {
  name = "${local.resource_name_prefix}-s2s_publicip"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  allocation_method = "Static"
  sku = "Standard"
  domain_name_label = "tma-mrsdev-s2s-${random_string.myrandom.id}"
}
/*
resource "azurerm_public_ip" "pip_aa" {
  count               = var.enable_active_active ? 1 : 0
  name = "${local.resource_name_prefix}-gw-aa-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "tma-mwkdev-gw-aa-pip-${random_string.myrandom.id}"
}
*/
#-------------------------------
# Virtual Network Gateway 
#-------------------------------
resource "azurerm_virtual_network_gateway" "vpngw" {
  name                = "${local.resource_name_prefix}-vpngw"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  type                = "Vpn"
  vpn_type            = "RouteBased"
  sku                 = "VpnGw2" #--A whole load of oddities occur around SKUs
  active_active       = false
  enable_bgp          = false
  generation          = "Generation2"
  #availability_zone = "1"
  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.pip_gw.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gatewaysubnet.id
  }
}

#---------------------------
# Local Network Gateway
#---------------------------
resource "azurerm_local_network_gateway" "gatewick" {
  name                = "${local.resource_name_prefix}-gatewickgw"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  gateway_address     = "185.167.229.148"
  address_space       = var.peer_subnet_address_spaces
}

#---------------------------------------
# Virtual Network Gateway Connection
#---------------------------------------
resource "azurerm_virtual_network_gateway_connection" "connection" {
  name                            = "${local.resource_name_prefix}-connection"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  type                            = "IPsec"
  virtual_network_gateway_id      = azurerm_virtual_network_gateway.vpngw.id
  local_network_gateway_id        = azurerm_local_network_gateway.gatewick.id
  shared_key                      = var.vpn_psk
  }
  

  #---------------------------
# Local Network Gateway ByFleet
#---------------------------
resource "azurerm_local_network_gateway" "byfleetgw" {
  name                = "${local.resource_name_prefix}-byfleetgw"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  gateway_address     = "94.228.42.242"
  address_space       = var.peer_subnet_address_spaces_byfleet
}

#---------------------------------------
# Virtual Network Gateway Connection ByFleet
#---------------------------------------
resource "azurerm_virtual_network_gateway_connection" "byfleetconnection" {
  name                            = "${local.resource_name_prefix}-byfleetconnection"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  type                            = "IPsec"
  virtual_network_gateway_id      = azurerm_virtual_network_gateway.vpngw.id
  local_network_gateway_id        = azurerm_local_network_gateway.byfleetgw.id
  shared_key                      = var.vpn_psk_byfleet

  dynamic "ipsec_policy" {
    for_each = var.local_networks_ipsec_policy != null ? [true] : []
    content {
      dh_group         = "DHGroup14"
      #dh_group         = var.local_networks_ipsec_policy.dh_group
      ike_encryption   = var.local_networks_ipsec_policy.ike_encryption
      #ike_integrity    = "SHA256"
      ike_integrity    = var.local_networks_ipsec_policy.ike_integrity
      ipsec_encryption = var.local_networks_ipsec_policy.ipsec_encryption
      ipsec_integrity  = var.local_networks_ipsec_policy.ipsec_integrity
      pfs_group        = var.local_networks_ipsec_policy.pfs_group
      sa_datasize      = var.local_networks_ipsec_policy.sa_datasize
      sa_lifetime      = var.local_networks_ipsec_policy.sa_lifetime
    }
  }
}
   #---------------------------
# Local Network Gateway Stratogen/Access Alto Endpoing
#---------------------------
resource "azurerm_local_network_gateway" "altoendpoing" {
  name                = "${local.resource_name_prefix}-alto"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  gateway_address     = "212.54.133.34"
  address_space       = var.peer_subnet_address_spaces_altoendpoing
}

#---------------------------------------
# Virtual Network Gateway Connection altoendpoing
#---------------------------------------
resource "azurerm_virtual_network_gateway_connection" "altoendpoingconnection" {
  name                            = "${local.resource_name_prefix}-altoendpoingconnection"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  type                            = "IPsec"
  virtual_network_gateway_id      = azurerm_virtual_network_gateway.vpngw.id
  local_network_gateway_id        = azurerm_local_network_gateway.altoendpoing.id
  shared_key                      = var.vpn_psk_altoendpoing

  dynamic "ipsec_policy" {
    for_each = var.local_networks_ipsec_policy != null ? [true] : []
    content {
      dh_group         = "DHGroup14"
      #dh_group         = var.local_networks_ipsec_policy.dh_group
      ike_encryption   = var.local_networks_ipsec_policy.ike_encryption
      #ike_integrity    = "SHA256"
      ike_integrity    = var.local_networks_ipsec_policy.ike_integrity
      ipsec_encryption = var.local_networks_ipsec_policy.ipsec_encryption
      ipsec_integrity  = var.local_networks_ipsec_policy.ipsec_integrity
      pfs_group        = var.local_networks_ipsec_policy.pfs_group
      sa_datasize      = var.local_networks_ipsec_policy.sa_datasize
      sa_lifetime      = var.local_networks_ipsec_policy.sa_lifetime
    }
  }


 

  /*
   dynamic "ipsec_policy" {
    for_each = try(each.value.ipsec_policy, null) == null ? [] : ["IPSecPolicy"]
    #for_each = var.local_networks_ipsec_policy != null ? [true] : []

    content {
        dh_group         = "DHGroup14"
        ike_encryption   = "AES256"
        ike_integrity    = "SHA256"
        ipsec_encryption = "AES256"
        ipsec_integrity  = "GCMAES256"
        pfs_group        = "none"
        sa_datasize      = "102400000"
        sa_lifetime      = "3600"
      }
      

  }
  */


  }
