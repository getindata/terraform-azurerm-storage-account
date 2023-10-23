module "resource_group" {
  source  = "getindata/resource-group/azurerm"
  version = "1.2.1"

  context = module.this.context

  name     = var.resource_group_name
  location = var.location

  count = module.this.enabled && var.create_resource_group ? 1 : 0
}

module "storage" {
  source = "github.com/getindata/terraform-azurerm-storage?ref=2.9.0"

  count = module.this.enabled ? 1 : 0

  create_resource_group                = false
  resource_group_name                  = local.resource_group_name
  storage_account_name                 = local.name_from_descriptor
  account_kind                         = var.account_kind
  skuname                              = var.skuname
  is_hns_enabled                       = var.is_hns_enabled
  sftp_enabled                         = var.sftp_enabled
  access_tier                          = var.access_tier
  min_tls_version                      = var.min_tls_version
  blob_soft_delete_retention_days      = var.blob_soft_delete_retention_days
  container_soft_delete_retention_days = var.container_soft_delete_retention_days
  enable_versioning                    = var.enable_versioning
  last_access_time_enabled             = var.last_access_time_enabled
  change_feed_enabled                  = var.change_feed_enabled
  enable_advanced_threat_protection    = var.enable_advanced_threat_protection
  network_rules                        = local.network_rules
  containers_list                      = var.containers_list
  file_shares                          = var.file_shares
  queues                               = var.queues
  tables                               = var.tables
  lifecycles                           = var.lifecycles
  managed_identity_type                = var.managed_identity_type
  managed_identity_ids                 = var.managed_identity_ids
  cors_rule                            = var.cors_rule
  use_raw_name                         = var.use_raw_name

  tags = module.this.tags

  depends_on = [module.resource_group]
}

resource "azurerm_role_assignment" "this" {
  count = module.this.enabled ? length(var.storage_blob_data_contributors) : 0

  principal_id = var.storage_blob_data_contributors[count.index]
  scope        = local.storage_account_id

  role_definition_name = "Storage Blob Data Contributor"
}

resource "azurerm_role_assignment" "storage_blob_data_readers" {
  count = module.this.enabled ? length(var.storage_blob_data_readers) : 0

  principal_id = var.storage_blob_data_readers[count.index]
  scope        = local.storage_account_id

  role_definition_name = "Storage Blob Data Reader"
}

module "diagnostic_settings" {
  count = module.this.enabled && var.diagnostics_log_analytics_workspace_id != null ? 1 : 0

  source  = "claranet/diagnostic-settings/azurerm"
  version = "6.2.0"

  resource_id = local.storage_account_id
  logs_destinations_ids = [
    var.diagnostics_log_analytics_workspace_id
  ]
}

module "this_private_endpoint_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"
  context = module.this.context

  name = local.storage_account_name
}

resource "azurerm_private_endpoint" "this" {
  count = module.this.enabled && var.private_endpoint_enabled ? 1 : 0

  location            = local.resource_group_location
  name                = local.private_endpoint_name_from_descriptor
  resource_group_name = local.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    is_manual_connection           = false
    name                           = local.private_endpoint_name_from_descriptor
    private_connection_resource_id = local.storage_account_id
    subresource_names              = [var.private_endpoint_subresource_name]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = var.private_endpoint_private_dns_zone_ids
  }

  tags = module.this.tags
}

resource "azurerm_storage_account_local_user" "this" {
  for_each = local.local_users

  name                 = each.value.name
  storage_account_id   = local.storage_account_id
  ssh_password_enabled = each.value.ssh_password_enabled
  home_directory       = each.value.home_directory

  dynamic "permission_scope" {
    for_each = each.value.permissions
    content {
      service       = permission_scope.value.service
      resource_name = permission_scope.value.container
      permissions {
        read   = contains(permission_scope.value.permissions, "All") || contains(permission_scope.value.permissions, "Read")
        write  = contains(permission_scope.value.permissions, "All") || contains(permission_scope.value.permissions, "Write")
        delete = contains(permission_scope.value.permissions, "All") || contains(permission_scope.value.permissions, "Delete")
        list   = contains(permission_scope.value.permissions, "All") || contains(permission_scope.value.permissions, "List")
        create = contains(permission_scope.value.permissions, "All") || contains(permission_scope.value.permissions, "Create")
      }
    }
  }
}
