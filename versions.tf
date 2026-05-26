terraform {
  required_version = ">= 1.8.0"

  required_providers {
    aci = {
      source  = "CiscoDevNet/aci"
      version = ">= 2.17.0"
    }
    utils = {
      source  = "netascode/utils"
      version = "=2.0.0-beta3"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.3.0"
    }
  }
}
