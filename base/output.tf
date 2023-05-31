output "default_subnet_id" {
  value = azurerm_subnet.default.id
}

output "db_subnet_id" {
  value = azurerm_subnet.db.id
}

output "pip_ids" {
  value = azurerm_public_ip.vm.id
}

output "asg_id" {
  value = azurerm_application_security_group.web.id
}
