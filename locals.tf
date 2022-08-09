locals {
  name_from_descriptor                  = replace(lookup(module.this.descriptors, "storage-account", module.this.id), "/-+/", "")
  private_endpoint_name_from_descriptor = replace(lookup(module.this_private_endpoint_label.descriptors, "private-endpoint", module.this_private_endpoint_label.id), "/-+/", "")

  account_tier             = (var.account_kind == "FileStorage" ? "Premium" : split("_", var.skuname)[0])
  account_replication_type = (local.account_tier == "Premium" ? "LRS" : split("_", var.skuname)[1])

  network_rules = (var.private_endpoint_enabled && var.network_rules == null ? {
    subnet_ids = []
    bypass     = ["AzureServices"]
    ip_rules   = []
  } : var.network_rules)

  resource_group_name     = var.create_resource_group ? one(module.resource_group[*].name) : var.resource_group_name
  resource_group_location = var.create_resource_group ? one(module.resource_group[*].location) : one(module.storage[*].resource_group_location)

  storage_account_id       = one(module.storage[*].storage_account_id)
  storage_account_name     = one(module.storage[*].storage_account_name)
  storage_account_location = one(module.storage[*].resource_group_location)
}
