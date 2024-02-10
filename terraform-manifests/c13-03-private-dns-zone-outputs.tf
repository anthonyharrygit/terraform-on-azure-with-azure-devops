/*
# FQDN Outputs
output "iis01_dns_record" {
  description = "IIS01 FQDN"
  value = azurerm_private_dns_a_record.iis01_dns_record.fqdn
}

output "srv01_dns_record" {
  description = "srv01 FQDN"
  value = azurerm_private_dns_a_record.srv01_dns_record.fqdn
}

output "sql01_dns_record" {
  description = "sql01 FQDN"
  value = azurerm_private_dns_a_record.sql01_dns_record.fqdn
}

output "rmq01_dns_record" {
  description = "rmq01 FQDN"
  value = azurerm_private_dns_a_record.rmq01_dns_record.fqdn
}
*/