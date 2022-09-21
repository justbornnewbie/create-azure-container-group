output "acg_id" {
  description = "Azure Container Instance Group ID"
  value       = azurerm_container_group.acg.id
}

output "private_ip_address" {
  description = "Private Ip Address of Container Group"
  value       = azurerm_container_group.acg.ip_address
}