

#Service Vault create_options
/*
resource "azurerm_recovery_services_vault" "mrsdevsrvvault" {
  name                = "${local.resource_name_prefix}-sv01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  storage_mode_type   = "LocallyRedundant"
}

resource "azurerm_backup_policy_vm" "mrsdevbackpolicy" {
  name                = "${local.resource_name_prefix}-bp01"
  resource_group_name = azurerm_resource_group.rg.name
  recovery_vault_name = azurerm_recovery_services_vault.mrsdevsrvvault.name

  backup {
    frequency = "Daily"
    time      = "16:00"
  }
#instant_restore_retention_days = 10

  retention_daily {
    count = 10
  }

  retention_weekly {
    count    = 4
    weekdays = ["Saturday"]
  }

  retention_monthly {
    count    = 6
    weekdays = ["Saturday"]
    weeks    = ["Last"]
  }
}




#Backup of lod Machine

resource "azurerm_backup_protected_vm" "tma-mrsdev-lod1" {
  resource_group_name = azurerm_resource_group.rg.name
  recovery_vault_name = azurerm_recovery_services_vault.mrsdevsrvvault.name
  source_vm_id        = azurerm_windows_virtual_machine.lod1_vm.id
  backup_policy_id    = azurerm_backup_policy_vm.mrsdevbackpolicy.id
}

#Backup of SQL Machine

resource "azurerm_backup_protected_vm" "tma-mrsdev-sql01" {
  resource_group_name = azurerm_resource_group.rg.name
  recovery_vault_name = azurerm_recovery_services_vault.mrsdevsrvvault.name
  source_vm_id        = azurerm_windows_virtual_machine.sql01_vm.id
  backup_policy_id    = azurerm_backup_policy_vm.mrsdevbackpolicy.id
}

#Backup of IIS Machine

resource "azurerm_backup_protected_vm" "tma-mrsdev-iis01" {
  resource_group_name = azurerm_resource_group.rg.name
  recovery_vault_name = azurerm_recovery_services_vault.mrsdevsrvvault.name
  source_vm_id        = azurerm_windows_virtual_machine.iis01_vm.id
  backup_policy_id    = azurerm_backup_policy_vm.mrsdevbackpolicy.id
}
*/