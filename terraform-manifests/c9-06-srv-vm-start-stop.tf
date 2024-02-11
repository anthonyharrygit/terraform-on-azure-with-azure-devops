variable "automation_account_name" {
    type = string
    default = "MRSTAutomationAccountDev"
}

resource "azurerm_automation_account" "mrstautomation" {
      name = var.automation_account_name
      location = azurerm_resource_group.rg.location
      resource_group_name = azurerm_resource_group.rg.name
      identity {
        type = "SystemAssigned"
      }
      sku_name = "Basic"
}
/*
resource "azurerm_automation_schedule" "scheduledstartvm" {
  name                    = "StartVM"
  resource_group_name     = azurerm_resource_group.rg.name
  #automation_account_name = "testautomation"
  automation_account_name = azurerm_automation_account.mrstautomation.name
  frequency               = "Day"
  interval                = 1
  timezone                = "Europe/London"
  start_time              = "2023-08-23T07:00:00Z"
  #daily_recurrence_time = "2200"
  description             = "Run every day"
}

resource "azurerm_automation_job_schedule" "startvm_sched" {
  resource_group_name     = azurerm_resource_group.rg.name
  automation_account_name = azurerm_automation_account.mwautomation.name
  schedule_name           = azurerm_automation_schedule.scheduledstartvm.name
  runbook_name            = azurerm_automation_runbook.startstopvmrunbook.name
   parameters = {
    action        = "Start"
  }
  depends_on = [azurerm_automation_schedule.scheduledstartvm]
}
*/

resource "azurerm_automation_schedule" "scheduledstopvm" {
  name                    = "StopVM"
  resource_group_name     = azurerm_resource_group.rg.name
  automation_account_name = azurerm_automation_account.mrstautomation.name
  frequency               = "Day"
  interval                = 1
  timezone                = "Europe/London"
  start_time              = "2024-02-12T17:30:00Z"
  #daily_recurrence_time = "2210"
  description             = "Run every day"
}

resource "azurerm_automation_job_schedule" "stopvm_sched" {
  resource_group_name     = azurerm_resource_group.rg.name
  automation_account_name = azurerm_automation_account.mrstautomation.name
  schedule_name           = azurerm_automation_schedule.scheduledstopvm.name
  runbook_name            = azurerm_automation_runbook.startstopvmrunbook.name
  parameters = {
    action        = "Stop"
  }
  depends_on = [azurerm_automation_schedule.scheduledstopvm]
}

data "local_file" "start_vm_parallel" {
      filename                       = "./app-scripts/mrsstartstopvmrunbook.ps1"
}

resource "azurerm_automation_runbook" "startstopvmrunbook" {
      name                           = "startstopvmrunbook"
      location                       = azurerm_resource_group.rg.location
      resource_group_name            = azurerm_resource_group.rg.name
      automation_account_name        = azurerm_automation_account.mrstautomationn.name
      log_verbose                    = "true"
      log_progress                   = "true"
      description                    = "This runbook starts VMs in parallel based on a matching tag value"
      runbook_type                   = "PowerShell"
      content                        = data.local_file.start_vm_parallel.content

      #publish_content_link {
      #  uri = "https://path.to.script/script.ps1"
      #}
}

