output "resource_group_name" {
  description = "The name of the resource group in which resources are created"
  value       = local.resource_group_name
}

output "storage_account_id" {
  description = "The ID of the storage account."
  value       = local.storage_account_id
}

output "storage_account_name" {
  description = "The name of the storage account."
  value       = local.storage_account_name
}
