data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

module "resource_group" {
  source  = "getindata/resource-group/azurerm"
  version = "1.2.1"
  context = module.this.context

  name     = "example-rg"
  location = "West Europe"
}

module "vnet" {
  source  = "Azure/vnet/azurerm"
  version = "2.6.0"

  resource_group_name = module.resource_group.name
  address_space       = ["10.0.0.0/16"]
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24"]
  subnet_names        = ["PublicSubnet", "PrivateSubnet"]

  depends_on = [module.resource_group]
}

resource "azurerm_private_dns_zone" "blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = module.resource_group.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob" {
  name                  = module.vnet.vnet_name
  resource_group_name   = module.resource_group.name
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = module.vnet.vnet_id
}

resource "azurerm_user_assigned_identity" "cmk" {
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  name                = "cmk"
}

resource "azurerm_user_assigned_identity" "readers" {
  for_each            = toset(["user-identity1", "user-identity2"])
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  name                = each.key
}

module "storage_account" {
  source  = "../.."
  context = module.this.context

  name = "example"

  location            = module.resource_group.location
  resource_group_name = module.resource_group.name

  # To enable advanced threat protection set argument to `true`
  enable_advanced_threat_protection = true

  # Container lists with access_type to create
  containers_list = [
    { name = "mystore250", access_type = "private" },
    { name = "blobstore251", access_type = "blob" },
    { name = "containter252", access_type = "container" }
  ]

  # SMB file share with quota (GB) to create
  file_shares = [
    { name = "smbfileshare1", quota = 50 },
    { name = "smbfileshare2", quota = 50 }
  ]

  # Storage queues
  queues = ["queue1", "queue2"]

  # Configure managed identities - used for instance for accessing encryption keys
  # Possible types are `SystemAssigned`, `UserAssigned` and `SystemAssigned, UserAssigned`.
  managed_identity_type = "UserAssigned"
  managed_identity_ids  = [azurerm_user_assigned_identity.cmk.id]

  # Configure Azure AD
  storage_blob_data_readers = [for k in azurerm_user_assigned_identity.readers : k.principal_id]

  # Lifecycle management for storage account.
  # Must specify the value to each argument and default is `0`
  lifecycles = [
    {
      prefix_match               = ["mystore250/folder_path"]
      tier_to_cool_after_days    = 0
      tier_to_archive_after_days = 50
      delete_after_days          = 100
      snapshot_delete_after_days = 30
    },
    {
      prefix_match               = ["blobstore251/another_path"]
      tier_to_cool_after_days    = 0
      tier_to_archive_after_days = 30
      delete_after_days          = 75
      snapshot_delete_after_days = 30
    }
  ]

  network_rules = {
    subnet_ids = []
    bypass     = ["AzureServices"]
    ip_rules   = [chomp(data.http.myip.body)]
  }

  #This will create a private endpoint, so connection to the storage will be made via private IP.
  private_endpoint_enabled          = true
  private_endpoint_subresource_name = "blob"
  private_endpoint_subnet_id        = module.vnet.vnet_subnets[1]
  private_endpoint_private_dns_zone_ids = [
    azurerm_private_dns_zone.blob.id
  ]

  depends_on = [module.resource_group]
}
