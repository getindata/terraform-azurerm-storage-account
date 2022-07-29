# Azure Storage Account - basic example

```terraform
module "resource_group" {
  source  = "getindata/resource-group/azurerm"
  version = "1.1.0"
  context = module.this.context

  name     = "example-rg"
  location = "West Europe"
}

module "storage_account" {
  source  = "../.."
  context = module.this.context

  name = "example"

  location            = module.resource_group.location
  resource_group_name = module.resource_group.name

  # Container lists with access_type to create
  containers_list = [
    {
      name        = "container"
      access_type = "private"
    }
  ]

  depends_on = [module.resource_group]
}
```
