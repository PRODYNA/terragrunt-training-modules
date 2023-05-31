output "default_subnet_id" {
  value = azurerm_subnet.default.id
}

output "db_subnet_id" {
  value = azurerm_subnet.db.id
}

output "private_dns_zone_id" {
  value = azurerm_private_dns_zone.mysql.id
}

output "pip_ids" {
  value = { for x in azurerm_public_ip.vm : x.id => x.id }
}

output "asg_id" {
  value = azurerm_application_security_group.web.id
}
