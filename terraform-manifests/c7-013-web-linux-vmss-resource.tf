/*
# Locals Block for custom data
locals {
webvm_custom_data = <<CUSTOM_DATA
#!/bin/sh
#sudo yum update -y
sudo yum install -y httpd
sudo systemctl enable httpd
sudo systemctl start httpd  
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo chmod -R 777 /var/www/html 
sudo echo "Welcome to stacksimplify - WebVM App1 - VM Hostname: $(hostname)" > /var/www/html/index.html
sudo mkdir /var/www/html/app1
sudo echo "Welcome to stacksimplify - WebVM App1 - VM Hostname: $(hostname)" > /var/www/html/app1/hostname.html
sudo echo "Welcome to stacksimplify - WebVM App1 - App Status Page" > /var/www/html/app1/status.html
sudo echo '<!DOCTYPE html> <html> <body style="background-color:rgb(250, 210, 210);"> <h1>Welcome to Stack Simplify - WebVM APP-1 </h1> <p>Terraform Demo</p> <p>Application Version: V1</p> </body></html>' | sudo tee /var/www/html/app1/index.html
sudo curl -H "Metadata:true" --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2020-09-01" -o /var/www/html/app1/metadata.html
CUSTOM_DATA  
}
*/

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "iisv_storage_account" {
  name                     = "mrsdiisv${random_id.iisvrandom_id.hex}"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Resource:Azure Linux Virtual Machine Scale Set - App1
resource "azurerm_windows_virtual_machine_scale_set" "web_vmss" {
  name = "${local.resource_name_prefix}-web-vmss"
  computer_name_prefix = "vmss-app1" # if name argument is not valid one for VMs, we can use this for our VM Names
  resource_group_name = azurerm_resource_group.rg.name 
  location            = azurerm_resource_group.rg.location 
  sku                 = "Standard_DS1_v2"
  #size = "Standard_DS2_v2"
  instances           = 2
  admin_username      = "azureuser" 
  admin_password       = random_password.iisv_password.result

#############################
  /*
  admin_ssh_key {
    username = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }

  

  source_image_reference {
    publisher = "RedHat"
    offer = "RHEL"
    sku = "83-gen2"
    version = "latest"
  }   

  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }  
  */
#################

 os_disk {
    #name    = "mrsdevIISVOsDisk"
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
    storage_account_uri = azurerm_storage_account.iisv_storage_account.primary_blob_endpoint
  }
  tags = var.tags
  upgrade_mode = "Automatic"

  network_interface {
    name = "web-vmss-nic"
    primary = "true"
    network_security_group_id = azurerm_network_security_group.web_vmss_nsg.id 
    ip_configuration {
      name = "internal"
      primary = true
      subnet_id = azurerm_subnet.websubnet.id 
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.web_lb_backend_address_pooldev.id]
    }
  }

  #custom_data = filebase64("${path.module}/app-scripts/redhat-webvm-script.sh")    
  #custom_data = base64encode(local.webvm_custom_data) 

}

# Install IIS web server to the virtual machine
resource "azurerm_virtual_machine_scale_set_extension" "web_serverinstall" {
  name                       = "${local.resource_name_prefix}-wsi"
  #virtual_machine_id         = azurerm_windows_virtual_machine.iis01_vm.id
  virtual_machine_scale_set_id = azurerm_windows_virtual_machine_scale_set.web_vmss.id
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
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools",
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted -NoProfile -NonInteractive -File tfsdeployment.ps1",
      "storageAccountName": "tmamkdevsa01",
      "storageAccountKey": "ryQBe4PFPWkCMDMQUavx+PncK0Kv5ZhTBork2Xi3neTM/WzhNYF4QugyCegXHfuqNekKauIiH80v+AStbbZNkw=="
    }
  PROTECTED_SETTINGS
}


# Generate random text for a unique storage account name
resource "random_id" "iisvrandom_id" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.rg.name
  }

  byte_length = 8
}

resource "random_password" "iisv_password" {
  length      = 20
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
  min_special = 1
  special     = true
}