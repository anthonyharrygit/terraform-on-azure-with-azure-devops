
# Create storage account for boot diagnostics
resource "azurerm_storage_account" "iis01_storage_account" {
  name                     = "mrsdiis${random_id.iis1_random_id.hex}"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


# Resource: Azure Linux Virtual Machines
resource "azurerm_windows_virtual_machine" "iis01_vm" {
  name = "${local.resource_name_prefix}-iis1"
  #computer_name = "web-linux-vm" # Hostname of the VM (Optional)
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  admin_username        = "tmaadmin"
  admin_password        = random_password.iis1_password.result
  size = "Standard_DS2_v2"
  network_interface_ids = [ azurerm_network_interface.iis01_vm_nic.id ]
  os_disk {
    name                 = "mrsdevIIS01OsDisk"
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }  
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer = "WindowsServer"
    sku = "2022-datacenter-azure-edition"
    version = "latest"
  }  

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.iis01_storage_account.primary_blob_endpoint
  }
  tags = var.tags
  
  #provisioner "file" {
  #  source      = "Files/Deployment/"
  #  destination = "C:/Temp"
  #}
}

# Install IIS web server to the virtual machine
resource "azurerm_virtual_machine_extension" "web_server_install" {
  name                       = "${local.resource_name_prefix}-wsi"
  virtual_machine_id         = azurerm_windows_virtual_machine.iis01_vm.id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.8"
  auto_upgrade_minor_version = true

  /*
  settings = <<SETTINGS
    {
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools"
      "fileUris": ["https://tmamkdevsa01.blob.core.windows.net/tmamwkdevsac01/tfsdeployment.ps1"]
    }
  SETTINGS
  */
  
  settings = <<SETTINGS
    {
        "fileUris": ["https://tmamkdevsa01.blob.core.windows.net/tmamwkdevsac01/tfsdeployment.ps1"]
    }
SETTINGS
 
  protected_settings = <<PROTECTED_SETTINGS
    {
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools",
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted -NoProfile -NonInteractive -File tfsdeployment.ps1",
      "storageAccountName": "tmamkdevsa01",
      "storageAccountKey": "ryQBe4PFPWkCMDMQUavx+PncK0Kv5ZhTBork2Xi3neTM/WzhNYF4QugyCegXHfuqNekKauIiH80v+AStbbZNkw=="
    }
  PROTECTED_SETTINGS


}


################

/*
# Install TFS deploymnet to the virtual machine
resource "azurerm_virtual_machine_extension" "tfs02" {
  name                       = "${local.resource_name_prefix}-tfs02"
  virtual_machine_id         = azurerm_windows_virtual_machine.iis01_vm.id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.8"
  auto_upgrade_minor_version = true


  settings = <<SETTINGS
    {
        "fileUris": ["https://tmamkdevsa01.blob.core.windows.net/tmamwkdevsac01/tfsdeployment.ps1"]
    }
SETTINGS
  protected_settings = <<PROTECTED_SETTINGS
    {
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted -NoProfile -NonInteractive -File tfsdeployment.ps1",
      "storageAccountName": "tmamkdevsa01",
      "storageAccountKey": "ryQBe4PFPWkCMDMQUavx+PncK0Kv5ZhTBork2Xi3neTM/WzhNYF4QugyCegXHfuqNekKauIiH80v+AStbbZNkw=="
    }
  PROTECTED_SETTINGS

  #depends_on = ["azurerm_virtual_machine_extension.tfs"]


}
*/

# Generate random text for a unique storage account name
resource "random_id" "iis1_random_id" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.rg.name
  }

  byte_length = 8
}

resource "random_password" "iis1_password" {
  length      = 20
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
  min_special = 1
  special     = true
}