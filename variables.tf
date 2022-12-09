variable "resource_group_name" {
  description = "A container that holds related resources for an Azure solution"
  type        = string
}

variable "location" {
  description = "Azure datacenter location, where resources will be deployed"
  default     = null
  type        = string
}

variable "create_resource_group" {
  description = "Whether to create resource group and use it for storage resources"
  default     = false
  type        = bool
}

variable "account_kind" {
  description = "The type of storage account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2"
  default     = "StorageV2"
  type        = string
}

variable "skuname" {
  description = "The SKUs supported by Microsoft Azure Storage. Valid options are Premium_LRS, Premium_ZRS, Standard_GRS, Standard_GZRS, Standard_LRS, Standard_RAGRS, Standard_RAGZRS, Standard_ZRS"
  default     = "Standard_RAGRS"
  type        = string
}

variable "is_hns_enabled" {
  type        = bool
  default     = false
  description = "Is Hierarchical Namespace enabled? This can be used with Azure Data Lake Storage Gen 2"
}

variable "access_tier" {
  description = "Defines the access tier for BlobStorage and StorageV2 accounts. Valid options are Hot and Cool"
  default     = "Hot"
  type        = string
}

variable "min_tls_version" {
  description = "The minimum supported TLS version for the storage account"
  default     = "TLS1_2"
  type        = string
}

variable "blob_soft_delete_retention_days" {
  description = "Specifies the number of days that the blob should be retained, between `1` and `365` days. Defaults to `7`"
  default     = 7
  type        = number
}

variable "container_soft_delete_retention_days" {
  description = "Specifies the number of days that the blob should be retained, between `1` and `365` days. Defaults to `7`"
  default     = 7
  type        = number
}

variable "enable_versioning" {
  description = "Is versioning enabled? Default to `false`"
  default     = false
  type        = bool
}

variable "last_access_time_enabled" {
  description = "Is the last access time based tracking enabled? Default to `false`"
  default     = false
  type        = bool
}

variable "change_feed_enabled" {
  description = "Is the blob service properties for change feed events enabled?"
  default     = false
  type        = bool
}

variable "enable_advanced_threat_protection" {
  description = "Boolean flag which controls if advanced threat protection is enabled"
  default     = false
  type        = bool
}

variable "network_rules" {
  description = "Network rules restricing access to the storage account"
  type        = object({ bypass = list(string), ip_rules = list(string), subnet_ids = list(string) })
  default     = null
}

variable "containers_list" {
  description = "List of containers to create and their access levels"
  type        = list(object({ name = string, access_type = string }))
  default     = []
}

variable "file_shares" {
  description = "List of containers to create and their access levels"
  type        = list(object({ name = string, quota = number }))
  default     = []
}

variable "queues" {
  description = "List of storages queues"
  type        = list(string)
  default     = []
}

variable "tables" {
  description = "List of storage tables"
  type        = list(string)
  default     = []
}
variable "lifecycles" {
  description = "Configure Azure Storage lifecycles"
  type        = list(object({ prefix_match = set(string), tier_to_cool_after_days = number, tier_to_archive_after_days = number, delete_after_days = number, snapshot_delete_after_days = number }))
  default     = []
}

variable "managed_identity_type" {
  description = "The type of Managed Identity which should be assigned to the Linux Virtual Machine. Possible values are `SystemAssigned`, `UserAssigned` and `SystemAssigned, UserAssigned`"
  default     = null
  type        = string
}

variable "managed_identity_ids" {
  description = "A list of User Managed Identity ID's which should be assigned to the Linux Virtual Machine"
  default     = null
  type        = list(string)
}

variable "storage_blob_data_contributors" {
  type        = list(string)
  default     = []
  description = "List of principal IDs that will have data contributor role"
}

variable "storage_blob_data_readers" {
  type        = list(string)
  default     = []
  description = "List of principal IDs that will have data reader role"
}

variable "diagnostics_log_analytics_workspace_id" {
  type        = string
  default     = null
  description = "Resource ID of the log analytics workspace. Used for diagnostics logs and metrics. If not provided, diagnostics will not be enabled"
}

variable "private_endpoint_enabled" {
  type        = bool
  default     = false
  description = "Should Private Endpoint for this storage account be enabled"
}

variable "private_endpoint_subnet_id" {
  type        = string
  default     = null
  description = "Subnet ID associated with the Private Endpoint"
}

variable "private_endpoint_subresource_name" {
  type        = string
  default     = "blob"
  description = "Subresource name for the Private Endpoint"
}

variable "private_endpoint_private_dns_zone_ids" {
  type        = list(string)
  default     = []
  description = "Private DNS Zone Ids associated with the Private Endpoint. They need to match the subresource name"
}
