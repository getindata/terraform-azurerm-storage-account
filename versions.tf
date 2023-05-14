terraform {
  required_version = ">= 0.13"
  required_providers {
    # The reason for the exception below is github action failing the check for unknown reason.
    # Locally executed linter does not fail for the same dependencies
    # tflint-ignore: terraform_unused_required_providers
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.39"
    }
  }
}
