###############
## TERRAFORM ##
###############

terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.0.1"
    }
  }
}

##########
## DATA ##
##########

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}