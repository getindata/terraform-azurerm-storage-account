output "resource_group_name" {
  description = "The name of the resource group in which resources are created"
  value       = local.resource_group_name
}

output "dno" {
   description = "yes"
   value       = local.storage_account_name
 }

output "resource_group_id" {
  description = "The id of the resource group in which resources are created"
  value       = one(module.storage[*].resource_group_id)
}

output "resource_group_location" {
  description = "The location of the resource group in which resources are created"
  value       = one(module.storage[*].resource_group_location)
}

output "storage_account_id" {
  description = "The ID of the storage account"
  value       = local.storage_account_id
}

output "storage_account_name" {
  description = "The name of the storage account"
  value       = local.storage_account_name
}

output "storage_account_primary_location" {
  description = "The primary location of the storage account"
  value       = one(module.storage[*].storage_account_primary_location)
}

output "storage_account_primary_blob_endpoint" {
  description = "The endpoint URL for blob storage in the primary location"
  value       = one(module.storage[*].storage_account_primary_blob_endpoint)
}

output "storage_account_primary_web_endpoint" {
  description = "The endpoint URL for web storage in the primary location"
  value       = one(module.storage[*].storage_account_primary_web_endpoint)
}

output "storage_account_primary_web_host" {
  description = "The hostname with port if applicable for web storage in the primary location"
  value       = one(module.storage[*].storage_account_primary_web_host)
}

output "storage_primary_connection_string" {
  description = "The primary connection string for the storage account"
  value       = one(module.storage[*].storage_primary_connection_string)
  sensitive   = true
}

output "storage_primary_access_key" {
  description = "The primary access key for the storage account"
  value       = one(module.storage[*].storage_primary_access_key)
  sensitive   = true
}

output "storage_secondary_access_key" {
  description = "The primary access key for the storage account"
  value       = one(module.storage[*].storage_secondary_access_key)
  sensitive   = true
}

output "containers" {
  description = "Map of containers"
  value       = one(module.storage[*].containers)
}

output "file_shares" {
  description = "Map of Storage SMB file shares"
  value       = one(module.storage[*].file_shares)
}

output "tables" {
  description = "Map of Storage SMB file shares"
  value       = one(module.storage[*].tables)
}

output "queues" {
  description = "Map of Storage SMB file shares"
  value       = one(module.storage[*].queues)
}
