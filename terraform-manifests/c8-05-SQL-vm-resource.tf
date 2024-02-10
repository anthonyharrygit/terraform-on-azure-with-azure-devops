
# Create storage account for boot diagnostics
resource "azurerm_storage_account" "sql01_storage_account" {
  name                     = "mrsdsql${random_id.sql1_random_id.hex}"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


# Resource: Azure Windows Virtual Machine
resource "azurerm_windows_virtual_machine" "sql01_vm" {
  name = "${local.resource_name_prefix}-sql1"
  #computer_name = "web-linux-vm" # Hostname of the VM (Optional)
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  admin_username        = "tmaadmin"
  admin_password        = random_password.sql1_password.result 
  size = "Standard_B4ms"
  network_interface_ids = [ azurerm_network_interface.sql01_vm_nic.id ]
  os_disk {
    name                 = "mrsdevSQL01OsDisk"
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }  
  source_image_reference {
    publisher = "MicrosoftSQLServer"
    offer = "sql2022-ws2022"
    sku = "standard-gen2"
    version = "latest"
  }  

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.sql01_storage_account.primary_blob_endpoint
  }
  tags = var.tags
}

# Install TFS deploymnet to the virtual machine
resource "azurerm_virtual_machine_extension" "tfssql01" {
  name                       = "${local.resource_name_prefix}-tfs02"
  virtual_machine_id         = azurerm_windows_virtual_machine.sql01_vm.id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.8"
  auto_upgrade_minor_version = true

  /*
  settings = <<settings
    {
        "fileUris": ["https://github.com/anthonyharrygit/tma/blob/main/test.ps1"],
        "commandtoexecute": "powershell.exe -executionpolicy unrestricted -noprofile -noninteractive -file test.ps1"
    }
  settings
  */

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

# Generate random text for a unique storage account name
resource "random_id" "sql1_random_id" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.rg.name
  }

  byte_length = 8
}

resource "random_password" "sql1_password" {
  length      = 20
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
  min_special = 1
  special     = true
}