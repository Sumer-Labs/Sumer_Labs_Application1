module "vnet" {
  source = "git::https://github.com/Sumer-Labs/Azure_Central_Terraform_Modules.git//Infra/networking/vnet?ref=platform-v1.3.0"

  name                = "sumerlabs-app1-dev-vnet"
  location            = "Central India"
  resource_group_name = "SumerLabs-Application1"

  address_space = [
    "10.50.0.0/16"
  ]

  subnets = {
    aks = {
      address_prefixes = ["10.50.0.0/22"]
    }

    app-gateway = {
      address_prefixes = ["10.50.10.0/24"]
    }

    private-endpoint = {
      address_prefixes = ["10.50.20.0/24"]
    }
  }

  tags = {
    environment = "dev"
    managed_by  = "terraform"
    application = "app1"
  }
}
