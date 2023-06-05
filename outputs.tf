output "cluster_id" {
  value       = azapi_resource.provisionedCluster.id
  description = "the id of created hybrid aks"
}

output "resource_group_id" {
  value       = data.azurerm_resource_group.rg.id
  description = "the id of the resource group"
}
