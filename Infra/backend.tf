terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "sumerlabsterraformstate"
    container_name       = "app1-tfstate"
    key                  = "dev/terraform.tfstate"

    use_azuread_auth = true
  }
}
