module "storage_account" {
  source  = "../.."
  context = module.this.context

  name = "example"

  create_resource_group = true
  resource_group_name   = "sample-rg"
  location              = "West Europe"

  # Container lists with access_type to create
  containers_list = [
    {
      name        = "container"
      access_type = "private"
    }
  ]
}
